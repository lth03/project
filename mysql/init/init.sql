-- ============================================================
-- 图书馆管理系统 - 数据库初始化脚本
-- ============================================================

-- 创建数据库（如果 docker-compose 已指定则忽略）
CREATE DATABASE IF NOT EXISTS library DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE library;

-- ─── 用户表 ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密)',
    name VARCHAR(100) NOT NULL COMMENT '真实姓名',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user' COMMENT '角色',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 1=启用 0=禁用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表';

-- ─── 图书分类表 ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '分类ID',
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书分类表';

-- ─── 图书表 ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '图书ID',
    isbn VARCHAR(20) NOT NULL UNIQUE COMMENT 'ISBN 编号',
    title VARCHAR(200) NOT NULL COMMENT '书名',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    publisher VARCHAR(100) DEFAULT NULL COMMENT '出版社',
    publish_year YEAR DEFAULT NULL COMMENT '出版年份',
    category_id INT DEFAULT NULL COMMENT '分类ID',
    description TEXT DEFAULT NULL COMMENT '简介',
    cover_url VARCHAR(255) DEFAULT NULL COMMENT '封面URL',
    total_count INT NOT NULL DEFAULT 1 COMMENT '总数量',
    available_count INT NOT NULL DEFAULT 1 COMMENT '可借数量',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 1=上架 0=下架',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书表';

-- ─── 借阅记录表 ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '记录ID',
    user_id INT NOT NULL COMMENT '用户ID',
    book_id INT NOT NULL COMMENT '图书ID',
    borrow_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '借书日期',
    due_date DATETIME NOT NULL COMMENT '应还日期',
    return_date DATETIME DEFAULT NULL COMMENT '实际归还日期',
    status ENUM(
        'borrowed',
        'returned',
        'overdue'
    ) NOT NULL DEFAULT 'borrowed' COMMENT '状态',
    renew_count INT NOT NULL DEFAULT 0 COMMENT '续借次数',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '借阅记录表';

-- ─── 管理员初始账号 ──────────────────────────────────
-- 密码: admin123 (bcrypt 加密)
INSERT INTO
    users (
        username,
        password,
        name,
        role
    )
VALUES (
        'admin',
        '$2b$10$uqqR2sS5q/zhdt5vBty5y.BKzj0WFdVN4iZLlpc9mkfvER8WA0Xz.',
        '系统管理员',
        'admin'
    );