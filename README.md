# docker-opencode

基于 Docker 的 AI 编码开发环境，集成 Opencode + Playwright MCP + VNC + SSH，开箱即用。

## 镜像说明

| 镜像 | 说明 |
|------|------|
| `fellow99/dev-in-one` | 基础开发环境（SSH + Node + Python + Java + 数据库客户端） |
| `fellow99/dev-opencode` | 完整 AI 编码环境（dev-in-one + Opencode + Playwright MCP + VNC） |
| `fellow99/dev-playwright` | Playwright 浏览器环境（dev-in-one + Playwright MCP + VNC，不含 Opencode） |

### 基础环境（dev-in-one）

- **Node.js**: v24，通过 `n` 可切换 v26 / v22 / v16
- **Python**: python3 + pip + venv + uv
- **Java**: SDKMAN 管理，预装 8 / 17 / 21 / 25 / 26（默认 26），含 Maven + Gradle
- **数据库客户端**: PostgreSQL、MariaDB、Redis、SQLite
- **工具**: ffmpeg、imagemagick、git、curl、wget、jq、socat、zip/unzip
- **全局 npm 包**: pm2、pnpm、bun、typescript、ts-node、playwright、chrome-devtools-mcp
- **SSH**: openssh-server，通过 `ROOT_PASSWORD` 环境变量设置密码
- **C++/Rust 编译**: build-essential、g++、clang、cmake、gdb、valgrind

### Opencode 环境（dev-opencode，基于 dev-in-one）

- **Opencode**: 通过 `VERSION_OPENCODE` 指定版本
- **插件**: oh-my-openagent、opencode-pty、@tarquinen/opencode-dcp
- **SpecKit**: specify-cli（GitHub spec-kit）
- **Codegraph**: 代码知识图谱索引
- **语言服务器**: Vue、TypeScript
- **Playwright MCP**: 浏览器自动化（Chromium）
- **VNC**: x11vnc + noVNC（Web 访问 `http://localhost:6080`）
- **窗口管理器**: fluxbox

### Playwright 环境（dev-playwright，基于 dev-in-one）

- Chromium 浏览器及完整依赖
- Playwright MCP 服务
- Xvfb 虚拟显示 + VNC + noVNC

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/fellow99/docker-opencode.git
cd docker-opencode
```

### 2. 构建镜像

```bash
# 一键构建并推送（可修改 build.sh 中的版本号）
./build.sh
```

`build.sh` 会依次构建两个镜像：

```bash
# dev-in-one 基础镜像
docker build -t fellow99/dev-in-one:20260609 -f Dockerfile-dev-in-one .

# dev-opencode（依赖 dev-in-one）
docker build -t fellow99/dev-opencode:1.17.13 \
  -f Dockerfile-dev-opencode \
  --build-arg VERSION_DEV_IN_ONE=20260609 \
  --build-arg VERSION_OPENCODE=1.17.13 .
```

> `Dockerfile-dev-playwright` 未包含在 `build.sh` 中，如需构建可单独执行。

### 3. 启动容器

**推荐使用 docker-compose：**

```bash
# 编辑 .env 设置 ROOT_PASSWORD（SSH 密码）
cp .env .env.local    # 参考 .env 文件，添加 ROOT_PASSWORD
docker-compose --env-file .env.local up -d
```

**或直接 docker run：**

```bash
docker run -d --name dev-opencode \
  -e ROOT_PASSWORD=your_password \
  -v ./workspace:/root/workspace \
  -v ./.opencode:/root/.config/opencode \
  -v ./.local_share_opencode:/root/.local/share/opencode \
  -v ./.agents:/root/.agents \
  -v ./.m2:/root/.m2 \
  -v ./.gradle:/root/.gradle \
  -p 2222:22 \
  -p 4096:4096 \
  -p 8931:8931 \
  -p 6080:6080 \
  fellow99/dev-opencode:1.17.13
```

## 端口映射

| 端口 | 服务 | 说明 |
|------|------|------|
| 22 (→2222) | SSH | 远程终端，密码由 `ROOT_PASSWORD` 设置 |
| 4096 | Opencode Serve | Opencode API / Web 服务 |
| 8931 | Playwright MCP | 浏览器自动化 MCP 服务 |
| 6080 | noVNC | 浏览器 VNC 客户端 |
| 5173 / 8080 / 8000 / 3000 | 开发端口 | 预留给开发中的应用 |

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `ROOT_PASSWORD` | SSH root 密码 | 无（必须设置，否则 SSH 无法登录） |
| `TZ` | 时区 | `Asia/Shanghai` |
| `TERM` | 终端类型 | `xterm-256color` |

## 目录挂载

| 容器路径 | 用途 |
|----------|------|
| `/root/workspace` | 工作目录（代码存放） |
| `/root/.config/opencode/opencode.json` | Opencode 主配置 |
| `/root/.config/opencode/oh-my-openagent.json` | Oh-My-OpenAgent 配置 |
| `/root/.config/opencode/plugins/` | Opencode 插件目录 |
| `/root/.local/share/opencode` | Opencode 数据目录 |
| `/root/.local/state/opencode` | Opencode 状态目录 |
| `/root/.agents` | 自定义 Agent 技能 |
| `/root/.m2` | Maven 本地仓库 |
| `/root/.gradle` | Gradle 本地缓存 |

## 容器内服务

容器通过 PM2 管理以下服务（`dev-opencode.pm2.json`）：

| 服务 | 说明 |
|------|------|
| `init-sshd` | SSH 初始化（设置密码并启动 sshd） |
| `init-dev-in-one` | 开发环境初始化（设置默认 Java 版本） |
| `init-vnc` | VNC 环境初始化（Xvfb + fluxbox + x11vnc + noVNC） |
| `playwright` | Playwright MCP 服务（端口 8931） |
| `opencode-serve` | Opencode Serve 服务（端口 4096） |
