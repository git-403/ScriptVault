1. version_switcher.sh 
    # version_switcher.sh 使用教程
    
    `version_switcher.sh` 脚本可以帮助你进行 Node.js、JDK 和 Maven 版本的丝滑切换（Node.js 使用的 `nvm`）。以下是使用该脚本的步骤：
    
    ## 1. 设置权限
    
    首先，确保 `version_switcher.sh` 脚本具有执行权限。运行以下命令：
    
    ```bash
    chmod +x ~/.version_switcher.sh
    
    ## 2. 编辑 .zshrc 文件（或者 .bashrc，取决于你使用的 shell）：
    
    ```bash
    vim ~/.zshrc

    ## 3. 添加和替换内容（首先，确保已安装nvm）：
    
    ```bash
    # 解决安装nvm后终端启动慢的问题
    export NVM_DIR="$HOME/.nvm"
    nvm() { . "$NVM_DIR/nvm.sh" ; nvm $@ ; }
    
    source "version_switcher.sh"

    ## 4. 刷新：
    
    ```bash
    source ~/.zshrc

    ## 5. 使用示例：
    
    ```bash
    #切换 Node.js 版本
    use node 20.16.0

    #切换 JDK 版本：
    use jdk 21

    #切换 Maven 版本：
    use maven 3.9.8