# leader key的流程图

```mermaid
flowchart TD
    A(["按下 Leader"]) --> n1["展示root菜单"]
    n1 -- 超时 --> n3(["退出"])
    n4(["菜单展示"]) --> n5["按下leader"] & n7["按下模式键"] & n12["按下command"]
    n5 --> n6(["进入pin状态"])
    n7 --> n10["匹配当前模式"]
    n1 --> n4
    n8(["进入模式菜单"]) --> n5 & n9["退出键"]
    n6 --> n9
    n9 --> n3
    n10 --> n8
    n11(["切换当前应用"]) --> n10
    n8 -- 超时 --> n3
    n12 --> n13["执行command"]
    n13 --> n3

    style A stroke:#D50000
    style n3 stroke:#D50000
    style n4 stroke:#FFD600
    style n6 stroke:#FFD600
    style n8 stroke:#FFD600
    style n11 stroke:#D50000
```

# 实体设计

* 菜单 - Menu
  * 属性
    * id
    * name
    * father
    * items
    * status
      * PINED
      * SHOWN
      * HIDDEN
    * timeout 展示的超时时间（秒）
    * view webview对象
    * mode show后状态：pin or float
  * 方法
    * show
    * hide
    * pin
    * back

* 菜单项 - MenuItem
  * key
  * description
  * type
    * MENU
      * menu
    * COMMAND
      * command
    * FUNCTION
      * before
      * after
  * env 根据wifi判断环境

* 命令 - Command
  * type 也是路径
    * hotkey
    * window
    * app
    * task
  * params 参数
  * desciption

* 命令管理器 - CommandRegister
  * regist(command)
  * excute(command)
