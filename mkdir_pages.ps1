$ErrorActionPreference = 'Continue'
$base = 'C:\Users\Administrator\Desktop\2026年1月7日\卡歌\红色旅游小网站\camping-wx-uniapp\camping-wx-uniapp\pages'
$dirs = @('route', 'booking', 'attraction')
foreach ($d in $dirs) {
    $path = Join-Path $base $d
    New-Item -Path $path -ItemType Directory -Force | Out-Null
    Write-Output "Created: $path"
}
Write-Output 'All directories created successfully.'
