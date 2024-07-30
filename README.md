# 功能
建立内网环境的 Python 组件下载缓存，提供简单、快速、低成本的缓存服务。

功能要求：
1. 支持 conda 及 pypi 镜像源
2. 支持国内镜像源
3. 部署简单，一键启停

# 部署
## 构建 docker image
### 基础镜像准备
```shell
docker pull python:3.10-bookworm
docker pull nginx:stable
```
### pypi 缓存服务
```shell
cd ./devpi
chmod +x build.sh
./build.sh 
```

### conda 缓存服务
```shell
cd ./quetz
chmod +x build.sh
./build.sh 
```
## 启动 docker image 
### 修改环境变量
```shell
vi .env
```    
| 变量              | 定义         |
|-----------------|------------|
| PYPI_PATH       | pypi的缓存目录  |
| CONDA_PATH      | conda的缓存目录 |
| NGINX_CONF_PATH | nginx配置文件  |

### 修改源地址
- 修改 conda 源地址
```shell
vi ./quetz/init_channels.sql
```

- 修改 pypi 源地址
```shell
vi ./devpi/main.py
```
修改变量: _pypi_ixconfig_default 的定义


### 启动
```shell
docker compose up -d   
```
### 关闭
```shell
docker compose down
```
### 查看状态及日志
```shell
docker compose stats
docker compose logs  
```
## 使用
IP地址及端口需根据实际部署配置调整。
### conda
```shell
vi ~/.condarc
```

```shell
channels:
  - defaults
show_channel_urls: true
auto_activate_base: false
default_channels:
  - http://localhost:8003/get/cloud/conda-forge
custom_channels:
  main: http://localhost:8003/get/pkgs
```

### pip
```shell
pip config set --user global.index-url http://localhost:8004/root/pypi/+simple/
```

# 坑
## quetz
conda的缓存代理基于 [quetz](https://github.com/mamba-org/quetz) 实现

### 1. 用户鉴权
quetz需用户页面登录后获取API_KEY然后再通过API进行管理（包括代理配置）。

但官方默认的登录实现不支持使用用户名和密码登录。

使用 [dict鉴权插件](https://github.com/mamba-org/quetz/blob/main/plugins/quetz_dictauthenticator) 实现用户名密码登录。
使用这种方式登录的用户其默认角色只能是`config.toml`的`[user]`的默认角色,且写入用户表的步骤是在登录后触发；无法实现分权管理，非常不安全;

## 2. 代理配置
代理配置会直接写入到配置表`main.channels`,参见 `init_channels.sql`。
同时， 在 `~/.condarc` 中，
1. default_channels 定义的是完整访问路径
2. custom_channels 定义的是repo:路径的关系。具体访问时，会拼接：路径+repo 得到完整路径再访问。

所以代理配置是 cloud 和 pkgs 二个根目录，具体使用在使用层进行定义

### 3. 最后实现
跳过初始化步骤，直接使用脚本修改数据库脚本进行配置。

## devpi
pypi的缓存代理基于 [devpi](https://github.com/devpi/devpi) 实现

### 国内源的兼容性
在提交的request的head里面添加了自定义的信息，导致国内源（清华源）直接返回404。

相关代码没有自定义head的入口，故直接修改源码`mirror.py`。具体修改位置请全文搜索 `liuzhou`后查看

### 用户登录及配置
尚未解决在同一个docker容器中调用 `supervisord` 后执行客户端进行用户创建、用户登录、配置代理等操作。
参见 `entrypoint.sh` 的实现。

为了实现同一个docker实现缓存代理， 修改 `main.py` 对变量 `_pypi_ixconfig_default` 二次赋值设置为清华源。

这样只能支持一个国内源，但满足目前需求。
