# AGENTS.md

TrafficMonitorPlus 的 Win11 Fluent 双主题皮肤（OCGO），附带 OpenCode Go 剩余额度的纯文字展示与重置倒计时。皮肤由无头 Edge 截图生成，仓库里没有编译/测试流程。

## 环境

- Windows + PowerShell 7（`pwsh`）
- 无头生成背景图需要 Edge：`C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`
- 预览 demo 需要 Node.js

## 命令

- 重新生成皮肤（背景图 + 遮罩 + `skin.xml`）：`pwsh -File gen\build.ps1`
- 本地预览 demo：`node demo\serve.js` → http://127.0.0.1:8765

## 约定

- 文案与最新变更说明用中文；命令、路径、标识符保持原样。
- 文字（标签、标题）全部烘焙进背景图，程序只画数值，所以 `skin.xml` 里所有 `display_text` 留空。
- `skins/OCGO-Light` 强调色 `#0067C0`，`skins/OCGO-Dark` 强调色 `#4CC2FF`。
- 无测试、无 CI、无 lint。改动靠 `gen\build.ps1` 重新生成 + demo 预览验证。

## 目录

- `gen/` — 皮肤生成器。`bg.html` 是背景图模板（`?theme=light|dark&mode=l|s`），`build.ps1` 按 2 倍分辨率截图并生成遮罩 BMP 与 `skin.xml`。
- `skins/OCGO-Light`、`skins/OCGO-Dark` — 生成产物（背景图、遮罩、`skin.xml`）。
- `demo/` — 预览页。`serve.js` 托管 `skin-demo.html`（`?theme=dark` 切深色，`?values=0` 隐藏数值）；`index.html` 是纯静态稿。

## 注意

- 不要手改生成物：`skins/*/skin.xml`、`background*.png`、`background_mask*.bmp` 都会被 `gen\build.ps1` 覆盖。
- 改布局尺寸时，`gen/bg.html` 里的坐标常量（`COL1`、`L`/`S`）和 `gen/build.ps1` 里的 `$DIM` 及 `layout_*` 坐标必须一起改，否则标签与数值会错位。
- `layout_*` 里 item 的 y = 行坐标 + 3：宿主用 GDI+ 垂直居中画数值，基线比背景标签高约 3px，这个偏移别丢。
- Go 用量用插件原生的剩余项（`ocg*hleft`），不需要补丁；进度条已移除。
