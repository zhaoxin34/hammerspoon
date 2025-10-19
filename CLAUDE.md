# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 在此代码库中工作时提供指导。

## 概述

这是一个 Hammerspoon 配置仓库，通过 Lua 脚本提供 macOS 自动化功能。配置重点关注窗口管理、应用程序启动以及使用 leader 键系统的生产力工作流。

## 核心架构

### 主入口点
- `init.lua` - 加载所有模块和 spoons 的主配置文件
- 设置日志记录、IPC 和加载核心功能
- 使用 `package.path` 包含 `modules/` 目录

### 核心模块 (modules/)
- `appWatcher.lua` - 处理应用程序切换（强制英文输入法）和屏幕锁定/解锁事件
- `leader.lua` - 实现双击 Cmd leader 键系统和模态菜单
- `utils.lua` - 空间管理和窗口跟踪的实用函数
- `menu.lua` - 为 leader 接口提供基于 HTML 的菜单渲染系统
- `leader/` - 包含模态实现的子目录：
  - `chromeModal.lua` - Chrome 专用模态
  - `mouseModal.lua` - 鼠标相关功能
  - 菜单渲染的 HTML 模板

### 配置文件
- `leader.toml` - MyLeader spoon 的 TOML 配置，定义：
  - 菜单结构和层次
  - 键绑定和热键
  - 应用程序启动器
  - Yabai 窗口管理集成
  - CSS 自定义样式

### Spoons
使用的预构建 Hammerspoon 扩展：
- `SpoonInstall` - Spoon 管理
- `LookupSelection` - 选中文本的字典/记事本
- `MyLeader` - 自定义 leader 键实现
- `EmmyLua` - Lua IDE 支持

## 开发命令

### 配置管理
```bash
# 重新加载 Hammerspoon 配置（在 Hammerspoon 控制台中）
hs.reload()

# 打开 Hammerspoon 控制台
hs.openConsole()

# 安装 IPC CLI 工具
hs.ipc.cliInstall("/opt/homebrew/")
```

### 文件结构
```
~/.hammerspoon/
├── init.lua              # 主配置文件
├── leader.toml           # Leader 菜单配置
├── modules/              # 自定义 Lua 模块
│   ├── appWatcher.lua
│   ├── leader.lua
│   ├── utils.lua
│   ├── menu.lua
│   └── leader/
│       ├── chromeModal.lua
│       ├── mouseModal.lua
│       ├── chrome_menu.html
│       ├── leader_menu.html
│       └── mouse_menu.html
└── Spoons/               # Hammerspoon 扩展
    ├── MyLeader.spoon/
    ├── SpoonInstall.spoon/
    └── EmmyLua.spoon/
```

## 核心功能

### Leader 键系统
- 双击 Cmd 激活 leader 模式
- 具有键绑定的分层菜单系统
- 与外部工具集成（Yabai、Raycast、Sketchybar）
- 应用程序启动和窗口管理

### 应用程序管理
- 应用切换时自动切换到英文输入法
- 屏幕锁定/解锁自动化（关闭/打开特定应用）
- 开发工具的焦点管理

### 外部工具集成
- **Yabai**: 窗口管理和空间导航
- **Raycast**: 剪贴板历史和搜索
- **Sketchybar**: 菜单栏集成
- **系统**: URL 处理、应用程序启动

## 配置模式

### 添加新的 Leader 菜单项
编辑 `leader.toml`：
```toml
[root]
new_key = ["app", "应用程序名称", "描述"]

[root.new_section]
name = "部分名称"
item1 = ["url", "https://example.com", "描述"]
```

### 模块结构
模块遵循以下模式：
```lua
local obj = {}

-- 模块函数
obj.functionName = function()
    -- 实现
end

return obj
```

### 热键绑定
- Leader 模式：双击 Cmd 激活
- 应用特定模态在 `modules/leader/` 中
- 系统级热键在 `init.lua` 中

## 依赖项
- 安装了 Hammerspoon 的 macOS
- Yabai（用于窗口管理）
- Raycast（用于剪贴板历史）
- Sketchybar（用于菜单栏集成）

## 自定义
- 修改 `leader.toml` 调整菜单结构
- 编辑 `modules/leader/` 中的 HTML 模板调整菜单样式
- 在 `modules/` 目录中添加新模块
- 在 `leader.toml` 的相应部分配置外部工具