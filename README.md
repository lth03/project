# 📚 图书馆管理系统

基于 Docker Compose 的图书馆管理系统（MySQL + Node.js + Nginx）。

## 快速启动

```bash
# 如有本地镜像包则先加载
docker load -i library-images.tar

# 启动所有服务
docker compose up -d
```

访问 `http://localhost` 即可使用。

## 服务概览

| 服务      | 镜像                         | 端口 |
| --------- | ---------------------------- | ---- |
| MySQL 8.0 | `mysql:8.0`                  | 3306 |
| Backend   | `luotinghao/library-backend` | 3000 |
| Nginx     | `luotinghao/library-nginx`   | 80   |

## 默认账号

| 角色   | 账号                                     | 密码       |
| ------ | ---------------------------------------- | ---------- |
| 管理员 | `admin`                                  | `admin123` |
| 用户   | `zhangsan` / `lisi` / `wangwu` / `sunqi` | `123456`   |

> ⚠️ `zhaoliu` 账号已被禁用。

## 常用命令

```bash
# 查看状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止
docker compose stop

# 停止并删除
docker compose down
```

## 数据重初始化

```bash
docker compose down
sudo rm -rf mysql/data
docker compose up -d
```

> ⚠️ 生产环境请修改 `DB_PASSWORD` 和 `JWT_SECRET`。
