# 📚 图书馆管理系统

基于 **Docker Compose** 部署的图书馆管理系统，包含 MySQL 数据库、Node.js 后端服务和 Nginx 反向代理。

---

## 📋 目录

- [项目结构](#项目结构)
- [环境要求](#环境要求)
- [快速启动](#快速启动)
- [服务说明](#服务说明)
- [数据库说明](#数据库说明)
- [默认账号](#默认账号)
- [常用命令](#常用命令)
- [常见问题](#常见问题)

---

## 项目结构

```
project/
├── docker-compose.yml          # Docker Compose 编排文件
├── mysql/
│   ├── data/                   # MySQL 数据持久化目录（启动后自动生成）
│   └── init/
│       ├── init.sql            # 数据库初始化脚本（建表）
│       └── seed.sql            # 模拟数据填充脚本
└── README.md                   # 本文件
```

---

## 环境要求

| 依赖           | 版本要求                | 说明         |
| -------------- | ----------------------- | ------------ |
| Docker         | ≥ 20.x                  | 容器运行时   |
| Docker Compose | ≥ 2.x                   | 容器编排工具 |
| 系统           | Linux / macOS / Windows | 跨平台支持   |

> 💡 检查安装：`docker --version && docker compose version`

---

## 快速启动

### 1️⃣ 启动所有服务

如果你已经有本地镜像包 `library-images.tar`，请先加载镜像：

```bash
cd /home/luotinghao/vscodeProjects/project
docker load -i library-images.tar
```

然后启动服务：

```bash
docker compose up -d
```

首次启动会自动：

- 拉取所需的 Docker 镜像
- 创建 `library-network` 网络
- 按顺序启动：`mysql` → `backend` → `nginx`
- 自动执行 `mysql/init/` 下的 SQL 脚本完成数据库初始化和数据填充

### 2️⃣ 查看启动状态

```bash
docker compose ps
```

所有服务状态为 `Up` 即表示启动成功。

### 3️⃣ 访问系统

| 服务             | 地址                  | 说明                    |
| ---------------- | --------------------- | ----------------------- |
| 前端页面 / API   | http://localhost      | 通过 Nginx 反向代理访问 |
| 后端 API（直连） | http://localhost:3000 | 开发调试用              |

### 4️⃣ 停止服务

```bash
# 停止并保留容器
docker compose stop

# 停止并删除容器
docker compose down

# 停止并删除容器、网络（保留数据卷）
docker compose down --volumes
```

---

## 服务说明

### 🗄️ MySQL (数据库)

| 配置项   | 值                            |
| -------- | ----------------------------- |
| 镜像     | `mysql:8.0`                   |
| 容器名   | `library-mysql`               |
| 端口     | `3306:3306`                   |
| 数据库名 | `library`                     |
| 根密码   | `123456`                      |
| 数据卷   | `./mysql/data:/var/lib/mysql` |

> ⚠️ **生产环境请务必修改默认密码！**

### ⚙️ Backend (后端服务)

| 配置项   | 值                                  |
| -------- | ----------------------------------- |
| 镜像     | `luotinghao/library-backend:latest` |
| 容器名   | `library-backend`                   |
| 端口     | `3000:3000`                         |
| 内部通信 | 通过 `mysql:3306` 连接数据库        |

**环境变量说明：**

| 变量名           | 值            | 说明                   |
| ---------------- | ------------- | ---------------------- |
| `NODE_ENV`       | `production`  | 运行环境               |
| `PORT`           | `3000`        | 服务端口               |
| `DB_HOST`        | `mysql`       | 数据库主机名（容器名） |
| `DB_PORT`        | `3306`        | 数据库端口             |
| `DB_USER`        | `root`        | 数据库用户             |
| `DB_PASSWORD`    | `123456`      | 数据库密码             |
| `DB_NAME`        | `library`     | 数据库名               |
| `JWT_SECRET`     | `7c443bce...` | JWT 签名密钥           |
| `JWT_EXPIRES_IN` | `3d`          | Token 有效期（3天）    |

> ⚠️ **生产环境请务必修改 `JWT_SECRET` 和 `DB_PASSWORD`！**

### 🌐 Nginx (反向代理)

| 配置项 | 值                                |
| ------ | --------------------------------- |
| 镜像   | `luotinghao/library-nginx:latest` |
| 容器名 | `library-nginx`                   |
| 端口   | `80:80`                           |

Nginx 负责将所有 `http://localhost` 的请求转发到后端服务。

---

## 数据库说明

### 表结构

| 表名             | 说明                             |
| ---------------- | -------------------------------- |
| `users`          | 用户表（含管理员和普通用户）     |
| `categories`     | 图书分类表（文学、科技、历史等） |
| `books`          | 图书信息表                       |
| `borrow_records` | 借阅记录表                       |

### ER 关系

```
users ──┐
         ├── borrow_records ── books
categories ──┘
```

### 初始化脚本

- **`init.sql`** — 创建数据库和所有表结构，并插入默认管理员账号
- **`seed.sql`** — 填充示例数据（分类、用户、图书）

> 脚本在容器**首次启动**时自动执行且仅执行一次。如需重新初始化，请删除 `mysql/data` 目录后重启。

---

## 默认账号

| 角色     | 用户名     | 密码       | 说明              |
| -------- | ---------- | ---------- | ----------------- |
| 管理员   | `admin`    | `admin123` | 系统管理权限      |
| 普通用户 | `zhangsan` | `123456`   | 示例用户          |
| 普通用户 | `lisi`     | `123456`   | 示例用户          |
| 普通用户 | `wangwu`   | `123456`   | 示例用户          |
| 普通用户 | `zhaoliu`  | `123456`   | ⚠️ 该用户已被禁用 |
| 普通用户 | `sunqi`    | `123456`   | 示例用户          |

---

## 常用命令

### 服务管理

```bash
# 启动所有服务
docker compose up -d

# 查看服务日志
docker compose logs -f
docker compose logs -f backend    # 只看后端日志
docker compose logs -f mysql      # 只看数据库日志

# 重启某个服务
docker compose restart backend

# 重新构建并启动（镜像有更新时）
docker compose pull
docker compose up -d
```

### 数据库操作

```bash
# 进入 MySQL 容器
docker compose exec mysql mysql -uroot -p123456 library

# 导出数据库
docker compose exec mysql mysqldump -uroot -p123456 library > backup.sql

# 导入数据库
cat backup.sql | docker compose exec -T mysql mysql -uroot -p123456 library
```

### 数据管理

```bash
# 重新初始化数据库（⚠️ 会删除所有已有数据）
docker compose down
sudo rm -rf mysql/data
docker compose up -d
```

---

## 常见问题

### ❓ 端口被占用

如果 `3306`、`3000` 或 `80` 端口已被占用，修改 `docker-compose.yml` 中的 `ports` 映射：

```yaml
ports:
  - "3307:3306" # 宿主机 3307 → 容器 3306
```

### ❓ 数据库连接失败

确保 MySQL 已经完全启动后再启动后端：

```bash
# 检查 MySQL 是否就绪
docker compose logs mysql | grep "ready for connections"

# 手动重启后端
docker compose restart backend
```

### ❓ 数据持久化

MySQL 数据存储在 `./mysql/data/` 目录中，删除该目录会导致数据丢失。备份数据请使用 `mysqldump` 命令。

### ❓ 如何修改配置

编辑 `docker-compose.yml` 后重新应用：

```bash
docker compose up -d
```

### ❓ 权限问题 (Linux)

如果遇到 `./mysql/data` 目录权限问题：

```bash
sudo chown -R 999:999 mysql/data
```

> MySQL 容器内使用 UID 999 (mysql 用户) 运行。

---

> 📝 **提示**：本项目仅供开发测试使用，请勿直接用于生产环境。部署到生产环境前，请务必修改默认密码和 JWT 密钥。11
