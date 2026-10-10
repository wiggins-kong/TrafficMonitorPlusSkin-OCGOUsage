# OCGO — TrafficMonitorPlus Win11 皮肤

Win11 Fluent 风格的双主题皮肤，附带 OpenCode Go 的 5 小时 / 每周 / 每月剩余额度与重置倒计时。

## 皮肤内容

| 区域 | 项目 |
| --- | --- |
| 网络 | 上传、下载 |
| CPU | 使用率、温度、频率 |
| GPU | 使用率、温度 |
| 内存 | 占用率 |
| OpenCode Go | 5 小时 / 每周 / 每月：剩余百分比 + 重置倒计时 |

- `skins/OCGO-Light` — 浅色（强调色 `#0067C0`）
- `skins/OCGO-Dark` — 深色（强调色 `#4CC2FF`）

文字全部烘焙在背景图里，程序只画数值，所以标签颜色/字重可以精确贴合 Win11 规范。

## 安装

1. 把 `skins/OCGO-Light`、`skins/OCGO-Dark` 复制到 TrafficMonitorPlus 的 `skins\` 目录。
2. Go 用量需要 `OpenCodeGoUsage.dll` 插件（含 `ocg5hleft` / `ocgwleft` / `ocgmleft` 剩余项，v1.2 及以上），在插件选项里填好 API Key。
3. 主窗口右键 → 皮肤 → 选择皮肤。
4. 想跟随系统深浅色：皮肤对话框里勾选「自动切换」。

> 剩余额度直接使用插件原生的「剩余」项，无需给插件打补丁；皮肤只负责排版。

## 重新生成皮肤

```powershell
pwsh -File gen\build.ps1
```

`gen/bg.html` 是背景图模板（`?theme=light|dark&mode=l|s`），`gen/build.ps1` 用无头 Edge 按 2 倍分辨率截图，再生成遮罩 BMP 和 `skin.xml`。

布局改尺寸时，`gen/bg.html` 里的坐标常量和 `gen/build.ps1` 里的 `layout_*` 坐标要一起改。

## 尺寸

| 模式 | 窗口 |
| --- | --- |
| `layout_l`（详细） | 260 × 424 |
| `layout_s`（普通） | 260 × 220 |

详细模式为单列排版：上面 8 行硬件信息，下面 OpenCode Go 卡片。
