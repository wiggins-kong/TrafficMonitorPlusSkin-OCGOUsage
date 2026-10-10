# 生成 OCGO 皮肤：背景图 + 遮罩 + skin.xml
# 用法： pwsh -File gen\build.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root  = Split-Path -Parent $PSScriptRoot
$page  = 'file:///' + ((Join-Path $PSScriptRoot 'bg.html') -replace '\\', '/')
$edge  = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
$skins = Join-Path $root 'skins'

# 100% DPI 下的窗口尺寸
$DIM = @{ l = @{ w = 260; h = 424 }; s = @{ w = 260; h = 220 } }

function New-Mask([string]$path, [int]$w, [int]$h, [int]$radius) {
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Black)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $d = $radius * 2
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc(0, 0, $d, $d, 180, 90)
    $p.AddArc($w - $d, 0, $d, $d, 270, 90)
    $p.AddArc($w - $d, $h - $d, $d, $d, 0, 90)
    $p.AddArc(0, $h - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    $b = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($b, $p)
    $g.Dispose(); $b.Dispose(); $p.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Bmp)
    $bmp.Dispose()
}

foreach ($theme in @('light', 'dark')) {
    $name = 'OCGO-' + $theme.Substring(0, 1).ToUpper() + $theme.Substring(1)
    $dir = Join-Path $skins $name
    New-Item -ItemType Directory -Force -Path $dir | Out-Null

    foreach ($mode in @('l', 's')) {
        $d = $DIM[$mode]
        $file = if ($mode -eq 'l') { 'background_l.png' } else { 'background.png' }
        $out = Join-Path $dir $file
        $url = "${page}?theme=$theme&mode=$mode"
        & $edge --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=2 `
            "--window-size=$($d.w),$($d.h)" --default-background-color=00000000 `
            "--screenshot=$out" $url | Out-Null
        if (-not (Test-Path $out)) { throw "Edge 未生成 $out" }
    }
    New-Mask (Join-Path $dir 'background_mask_l.bmp') ($DIM.l.w * 2) ($DIM.l.h * 2) 16
    New-Mask (Join-Path $dir 'background_mask.bmp')   ($DIM.s.w * 2) ($DIM.s.h * 2) 16

    # skin.xml：文字全部画在背景图里，所以所有 display_text 留空
    $textColor = if ($theme -eq 'light') { 1710618 } else { 16777215 }
    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<root>
	<skin>
		<skin_author>wiggins-kong</skin_author>
		<text_color>$textColor</text_color>
		<specify_each_item_color>0</specify_each_item_color>
		<font name="Segoe UI Variable Text" size="9" style="1"/>
		<display_text>
			<up></up>
			<down></down>
			<cpu></cpu>
			<cpu_freq></cpu_freq>
			<cpu_temperature></cpu_temperature>
			<gpu></gpu>
			<gpu_temperature></gpu_temperature>
			<memory></memory>
			<go5h_left></go5h_left>
			<go5h_reset></go5h_reset>
			<gow_left></gow_left>
			<gow_reset></gow_reset>
			<gom_left></gom_left>
			<gom_reset></gom_reset>
		</display_text>
	</skin>
	<plugin_map>
		<go5h_left>ocg5hleft</go5h_left>
		<go5h_reset>ocg5hreset</go5h_reset>
		<gow_left>ocgwleft</gow_left>
		<gow_reset>ocgwreset</gow_reset>
		<gom_left>ocgmleft</gom_left>
		<gom_reset>ocgmreset</gom_reset>
	</plugin_map>
	<layout text_height="28" no_label="0">
		<!-- 数值由宿主用 GDI+ 垂直居中绘制，基线比背景里的标签高约 3px，所以 item 的 y = 行坐标 + 3 -->
		<layout_l width="260" height="424">
			<up x="140" y="49" width="100" align="1" show="1"/>
			<down x="140" y="77" width="100" align="1" show="1"/>
			<cpu x="140" y="105" width="100" align="1" show="1"/>
			<cpu_temperature x="140" y="133" width="100" align="1" show="1"/>
			<gpu x="140" y="161" width="100" align="1" show="1"/>
			<gpu_temperature x="140" y="189" width="100" align="1" show="1"/>
			<memory x="140" y="217" width="100" align="1" show="1"/>
			<cpu_freq x="140" y="245" width="100" align="1" show="1"/>
			<go5h_left x="101" y="325" width="40" align="0" show="1"/>
			<go5h_reset x="185" y="325" width="60" align="0" show="1"/>
			<gow_left x="101" y="353" width="40" align="0" show="1"/>
			<gow_reset x="185" y="353" width="60" align="0" show="1"/>
			<gom_left x="101" y="381" width="40" align="0" show="1"/>
			<gom_reset x="185" y="381" width="60" align="0" show="1"/>
		</layout_l>
		<layout_s width="260" height="220">
			<up x="140" y="41" width="100" align="1" show="1"/>
			<down x="140" y="69" width="100" align="1" show="1"/>
			<cpu x="140" y="97" width="100" align="1" show="1"/>
			<cpu_temperature x="140" y="125" width="100" align="1" show="1"/>
			<gpu x="140" y="153" width="100" align="1" show="1"/>
			<memory x="140" y="181" width="100" align="1" show="1"/>
		</layout_s>
	</layout>
	<preview width="300" height="700">
		<l x="20" y="20"/>
		<s x="20" y="460"/>
	</preview>
</root>
"@
    Set-Content -Path (Join-Path $dir 'skin.xml') -Value $xml -Encoding UTF8
    "built $name"
}
