# build_proposal_docx_template.ps1 — 通用开题报告学校模板回填构建器
# 把分节 Markdown 正文 + 参考文献库回填进用户提供的学校 Word 模板，
# 保留模板的封面、基本信息表、审核意见表和成绩单。
#
# 用法（PowerShell）:
#   .\build_proposal_docx_template.ps1 `
#     -TemplateDocx "C:\path\template.docx" `
#     -OutputDocx   "C:\path\out.docx" `
#     -SectionsDir  "C:\path\drafts\sections" `
#     -RefsFile     "C:\path\references.md" `
#     -NewTitle     "新论文题目" `
#     -ConfigJson   "C:\path\config.json"        # 可选：学校模板章节锚点覆盖
#
# config.json 可选字段（不提供则使用内置默认锚点）:
#   {
#     "old_title": "旧题目（找不到时自动跳过标题替换）",
#     "heading_anchor": ["一、立题依据", "二、研究内容和目标", ...],
#     "section_title_regex": "^\\d+_",
#     "keep_sixth_table": true,
#     "section_files": [ ["01_x.md", ...], ["02_y.md", ...], ... ]
#   }
#
# section_files 条目支持 "file.md#章节标题"：抽取该 md 中从指定一级标题起的子块。
# 依赖：仅 Windows 内置（tar 解包、Compress-Archive 打包），无需 Python。

param(
  [Parameter(Mandatory=$true)][string]$TemplateDocx,
  [Parameter(Mandatory=$true)][string]$OutputDocx,
  [Parameter(Mandatory=$true)][string]$SectionsDir,
  [string]$RefsFile = '',
  [string]$NewTitle = '',
  [string]$ConfigJson = ''
)

$ErrorActionPreference = 'Stop'
$temp = Join-Path ([System.IO.Path]::GetTempPath()) ('propbuild-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force $temp | Out-Null

function Read-Utf8([string]$p){ Get-Content -Raw -Encoding UTF8 $p }

function Escape-Xml([string]$s){
  if($null -eq $s){return ''}
  return $s.Replace('&','&amp;').Replace('<','&lt;').Replace('>','&gt;').Replace('"','&quot;')
}

function ParaXml([string]$text, [string]$style){
  $t = Escape-Xml $text
  return "<w:p><w:pPr><w:pStyle w:val=`"$style`"/></w:pPr><w:r><w:t xml:space=`"preserve`">$t</w:t></w:r></w:p>"
}

function MarkdownXml([string]$path, [bool]$skipTop=$false, [string]$fromSection=''){
  $lines = Get-Content -Encoding UTF8 $path
  $out = New-Object System.Text.StringBuilder
  $topSkipped = $false
  $inSection = ($fromSection -eq '')
  $emitHeadings = ($fromSection -eq '')
  foreach($line in $lines){
    $isH1 = ($line -match '^# (.+)$')
    if($isH1){
      if(-not $emitHeadings -and -not $inSection){
        if($Matches[1].Trim() -eq $fromSection.Trim()){ $inSection=$true; $emitHeadings=$true }
        continue
      } elseif($inSection -and $emitHeadings -and $fromSection -ne ''){
        if($Matches[1].Trim() -ne $fromSection.Trim()){ break }
      }
    }
    if(-not $emitHeadings){ continue }
    if($isH1){
      if($skipTop -and -not $topSkipped){ $topSkipped=$true; continue }
      [void]$out.Append((ParaXml $Matches[1] 'Heading2')); continue
    }
    if($line -match '^## (.+)$'){ [void]$out.Append((ParaXml $Matches[1] 'Heading2')); continue }
    if($line -match '^### (.+)$'){ [void]$out.Append((ParaXml $Matches[1] 'Heading3')); continue }
    if($line -match '^#### (.+)$'){ [void]$out.Append((ParaXml $Matches[1] 'Heading4')); continue }
    if($line.Trim() -eq ''){ continue }
    $body = $line.Trim()
    $body = [regex]::Replace($body, '`([^`]+)`', '$1')
    $body = $body -replace '^\*\*|\*\*$',''
    $body = $body -replace '^\*|\*$',''
    [void]$out.Append((ParaXml $body 'BodyText'))
  }
  return $out.ToString()
}

# ---- 1. 解包模板 ----
Write-Host '[1/5] 解包学校模板...'
Push-Location $temp
& tar -xf $TemplateDocx 2>$null
Pop-Location
$docPath = Join-Path $temp 'word/document.xml'
if(-not (Test-Path $docPath)){ throw "无法找到 word/document.xml，请确认模板是有效的 .docx" }
$xml = Read-Utf8 $docPath
# 成绩单/论证意见表格边界：其后的锚点一律不参与回填，避免误匹配固定表格
$safeLimit = $xml.Length
foreach($marker in @('开题报告论证小组意见','硕士研究生成绩单','学院开题报告审核小组意见')){
  $idx = $xml.IndexOf($marker)
  if($idx -ge 0 -and $idx -lt $safeLimit){ $safeLimit = $idx }
}

# ---- 2. 解析配置 ----
$cfg = @{
  old_title = $null
  heading_anchor = @('一、立题依据','二、研究内容和目标','三、研究方案设计及可行性分析','四、本研究课题的特色与创新之处','五、研究基础与工作条件','六、研究工作计划及预期研究结果')
  section_title_regex = '^\d+_'
  keep_sixth_table = $true
  section_files = $null
}
if($ConfigJson -and (Test-Path $ConfigJson)){
  $u = Get-Content -Raw -Encoding UTF8 $ConfigJson | ConvertFrom-Json
  foreach($k in @('old_title','heading_anchor','section_title_regex','keep_sixth_table','section_files')){
    if($u.PSObject.Properties.Name -contains $k -and $null -ne $u.$k){ $cfg[$k] = $u.$k }
  }
}
if(-not $cfg.old_title){ $cfg.old_title = '' }

# ---- 3. 标题替换 ----
if($NewTitle){
  Write-Host '[2/5] 替换论文题目...'
  if($cfg.old_title){
    if($xml.Contains($cfg.old_title)){
      $xml = $xml.Replace($cfg.old_title, $NewTitle)
      Write-Host "   旧标题「$($cfg.old_title)」已替换为「$NewTitle」。"
    }
  }
  # 未提供旧标题：定位"论文题目"之后的旧题目标签并替换
  if(-not $xml.Contains($NewTitle)){
    $idx = $xml.IndexOf('论文题目')
    if($idx -ge 0 -and $idx -lt $safeLimit){
      # 先跳过"论文题目"本身的 w:t 结束，再找下一个真正的 w:t（即旧题目）。
      # 注意正则必须用 (?:\s[^>]*)?> 匹配，避免把 w:tcW/w:tblBorders/w:t 前缀标签误当 w:t。
      $firstTClose = $xml.IndexOf('</w:t>', $idx)
      if($firstTClose -ge 0){
        $searchFrom = $firstTClose + 6
        $m = [regex]::Match($xml.Substring($searchFrom), '<w:t(?:\s[^>]*)?>(.*?)</w:t>')
        if($m.Success){
          $oldTitle = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
          $repl = '<w:t xml:space="preserve">' + (Escape-Xml $NewTitle) + '</w:t>'
          $absPos = $searchFrom + $m.Index
          $xml = $xml.Substring(0, $absPos) + [regex]::Replace($xml.Substring($absPos, $m.Length), [regex]::Escape($m.Value), $repl, 1) + $xml.Substring($absPos + $m.Length)
          Write-Host "   已替换论文题目后的旧标题「$oldTitle」为「$NewTitle」。"
        }
      }
    }
  }
}

# ---- 4. 分节回填（字符串定位 + 固定表格区域保护） ----
Write-Host '[3/5] 回填正文分节...'
$sectionFiles = Get-ChildItem $SectionsDir -Filter *.md | Sort-Object Name
if($sectionFiles.Count -eq 0){ throw "SectionsDir 中没有 .md 分节文件" }

function Get-TableCellRange([string]$xmlText, [string]$anchorText, [int]$limit){
  $i = $xmlText.IndexOf($anchorText)
  if($i -lt 0 -or $i -ge $limit){ return $null }
  $start = $xmlText.LastIndexOf('<w:tc>', $i)
  if($start -lt 0){ return $null }
  $end = $xmlText.IndexOf('</w:tc>', $i)
  if($end -lt 0 -or $end -gt $limit){ return $null }
  $end += 7
  return [pscustomobject]@{ Start=$start; End=$end; Len=$end-$start }
}

$anchors = @($cfg.heading_anchor)
for($ai = 0; $ai -lt $anchors.Count; $ai++){
  $anchor = $anchors[$ai]
  $targets = @()
  if($cfg.section_files -ne $null -and $ai -lt @($cfg.section_files).Count){
    $sf = @($cfg.section_files)[$ai]
    foreach($item in @($sf)){
      if($item){
        $baseName = $item -replace '^(.*?\.md)#.*$','$1'
        $m = $sectionFiles | Where-Object { $_.Name -eq $baseName -or $_.BaseName -eq $baseName } | Select-Object -First 1
        if($m){ $targets += ([pscustomobject]@{ File=$m.FullName; Name=$item }) }
      }
    }
  } else {
    $fileMatch = $sectionFiles | Where-Object { $_.BaseName -match $cfg.section_title_regex } | Select-Object -Skip $ai -First 1
    if($fileMatch){ $targets += $fileMatch }
  }
  if($ai -ge 5 -and $cfg.keep_sixth_table){
    Write-Host "   第 $($ai+1) 段「$anchor」保留模板计划表格。"
    continue
  }
  if($targets.Count -eq 0){
    Write-Host "   警告：未找到第 $($ai+1) 段「$anchor」对应分节文件，跳过。"
    continue
  }
  $range = Get-TableCellRange $xml $anchor $safeLimit
  if(-not $range){
    Write-Host "   警告：模板中未找到锚点「$anchor」，跳过。"
    continue
  }
  # 保留完整 tcPr（含 gridSpan/tcW/vAlign），确保通栏
  $cellText = $xml.Substring($range.Start, $range.Len)
  $tcPrEnd = $cellText.IndexOf('</w:tcPr>')
  $keep = if($tcPrEnd -ge 0){ $cellText.Substring(0, $tcPrEnd + 9) } else { '<w:tc>' }
  $markdown = ''
  # 段大标题（锚点原文），使用模板已验证可用的 Heading2 样式，避免引用不存在的 Heading1
  $markdown += ParaXml $anchor 'Heading2'
  foreach($tf in $targets | Where-Object { $_ }){
    $fromSection = ''
    $fName = $tf.Name
    if($fName -match '^(.*?\.md)#(.*)$'){ $fName = $Matches[1]; $fromSection = $Matches[2] }
    $mdPath = Join-Path $SectionsDir $fName
    if(-not (Test-Path $mdPath)){ $mdPath = $(if($tf.File){$tf.File}else{$tf.FullName}) }
    $markdown += MarkdownXml $mdPath $false $fromSection
    Write-Host "   分节「$fName$(if($fromSection){'#'+$fromSection})」已回填到「$anchor」。"
  }
  $newCell = $keep + $markdown + '</w:tc>'
  $xml = $xml.Substring(0, $range.Start) + $newCell + $xml.Substring($range.End)
}

# ---- 5. 参考文献追加到立题依据段末尾 ----
if($RefsFile -and (Test-Path $RefsFile)){
  Write-Host '[4/5] 追加参考文献...'
  $refLines = Get-Content -Encoding UTF8 $RefsFile
  $refXml = New-Object System.Text.StringBuilder
  foreach($rl in $refLines){
    $trim = $rl.Trim()
    if($trim -ne '' -and -not $trim.StartsWith('#') -and -not $trim.StartsWith('>')){
      [void]$refXml.Append((ParaXml $trim 'RefItem'))
    }
  }
  $anchor = $anchors[0]
  $range = Get-TableCellRange $xml $anchor $safeLimit
  if($range){
    # 直接插在单元格闭合 </w:tc> 之前，保证所有新段落都是独立闭合的 w:p
    $insertPos = $range.End - 7
    $refTitle = '<w:p><w:pPr><w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t xml:space="preserve">主要参考文献</w:t></w:r></w:p>'
    $xml = $xml.Substring(0, $insertPos) + $refTitle + $refXml.ToString() + $xml.Substring($insertPos)
    Write-Host "   已追加 $($refLines.Count) 行文献到「$anchor」段。"
  }
}

Set-Content -Encoding UTF8 $docPath $xml

# ---- 6. 打包为标准 ZIP（Compress-Archive 保证 Word 可打开） ----
Write-Host '[5/5] 打包为标准 .docx...'
$staged = Join-Path $temp 'staged'
New-Item -ItemType Directory -Force $staged | Out-Null
Get-ChildItem $temp | Where-Object { $_.Name -ne 'staged' } | Copy-Item -Destination $staged -Recurse -Force
if(Test-Path $OutputDocx){ Remove-Item -Force $OutputDocx -ErrorAction SilentlyContinue }
$zip = $OutputDocx + '.zip'
Remove-Item -Force $zip -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $staged '*') -DestinationPath $zip -CompressionLevel Optimal
Move-Item $zip $OutputDocx
Remove-Item -Recurse -Force $temp

$fs = Get-Item $OutputDocx
Write-Host ''
Write-Host "完成：$($fs.FullName)（$($fs.Length) 字节）"
Write-Host '验收建议：'
Write-Host '  1) 用 doc_read 或 Word 打开检查标题、六大章节、参考文献和审核表；'
Write-Host '  2) 用 Word.ExportAsFixedFormat 导出 PDF 逐页目检版式。'








