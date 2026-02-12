# 修改记录

## 2026-02-12

### refactor: 将 MyLeader 触发键从右 Command 改为 F18 功能键

**变更描述：**

将 MyLeader spoon 的触发键从 right command (右 Command 键) 改为 F18 功能键，提供更可靠的触发方式。

**具体变更：**

- 删除了对 `rightCmdKey.lua` 的引用
- 改用 `hs.hotkey.bind` 绑定 F18 键来触发 leader 菜单

**相关文件：**

- `Spoons/MyLeader.spoon/init.lua`

**作者：**

Zhaoxin
