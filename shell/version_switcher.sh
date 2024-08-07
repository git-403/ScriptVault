#!/bin/zsh

# Java 环境变量
export JAVA_8_HOME="/jdk1.8.0_221.jdk/Contents/Home"
export JAVA_21_HOME="/jdk-21.jdk/Contents/Home"

# Maven 环境变量
export MAVEN_3_6_3_HOME="/apache-maven-3.6.3"
export MAVEN_3_9_8_HOME="/apache-maven-3.9.8"

# 可用 Node.js 版本
NODE_VERSIONS=("16.14.0" "20.16.0")

# 缓存文件路径
CACHE_FILE="$HOME/.version_cache"

# 切换函数
function use() {
    local type=$1
    local version=$2

    case $type in
        jdk)
            case $version in
                8)
                    export JAVA_HOME=$JAVA_8_HOME
                    ;;
                21)
                    export JAVA_HOME=$JAVA_21_HOME
                    ;;
                *)
                    echo "Invalid JDK version. Use '8' or '21'."
                    return 1
                    ;;
            esac
            export PATH=$JAVA_HOME/bin:$PATH
            ;;
        maven)
            case $version in
                3.6.3)
                    export MAVEN_HOME=$MAVEN_3_6_3_HOME
                    ;;
                3.9.8)
                    export MAVEN_HOME=$MAVEN_3_9_8_HOME
                    ;;
                *)
                    echo "Invalid Maven version. Use '3.6.3' or '3.9.8'."
                    return 1
                    ;;
            esac
            export PATH=$MAVEN_HOME/bin:$PATH
            ;;
        node)
            if [[ " ${NODE_VERSIONS[@]} " =~ " ${version} " ]]; then
                export PATH="$HOME/.nvm/versions/node/v$version/bin:$PATH"
            else
                echo "Invalid Node.js version. Available versions: ${NODE_VERSIONS[*]}"
                return 1
            fi
            ;;
        *)
            echo "Usage: use {jdk|maven|node} {version}"
            return 1
            ;;
    esac

    # 更新缓存文件
    echo "JAVA_HOME=$JAVA_HOME" > $CACHE_FILE
    echo "MAVEN_HOME=$MAVEN_HOME" >> $CACHE_FILE
    echo "NODE_VERSION=$(nvm current | sed 's/v//')" >> $CACHE_FILE
}

# 读取缓存并应用
function read_cache() {
    if [[ -f $CACHE_FILE ]]; then
        while IFS= read -r line; do
            local key=$(echo $line | cut -d'=' -f1)
            local value=$(echo $line | cut -d'=' -f2-)
            
            case $key in
                JAVA_HOME)
                    export JAVA_HOME=$value
                    export PATH=$JAVA_HOME/bin:$PATH
                    ;;
                MAVEN_HOME)
                    export MAVEN_HOME=$value
                    export PATH=$MAVEN_HOME/bin:$PATH
                    ;;
                NODE_VERSION)
                    if [[ " ${NODE_VERSIONS[@]} " =~ " ${value} " ]]; then
                        export PATH="$HOME/.nvm/versions/node/v$value/bin:$PATH"
                    else
                        # 使用默认 Node.js 版本
                        export PATH="$HOME/.nvm/versions/node/v20.16.0/bin:$PATH"
                    fi
                    ;;
            esac
        done < $CACHE_FILE
    else
        # 设置默认版本
        use jdk 21
        use maven 3.9.8
        use node 20.16.0
    fi
}

# 启动时读取缓存
read_cache
