# 红色旅游小网站 - 项目说明

## 项目概述

本项目为**红色旅游小网站**，包含三个子项目：
- **H5 移动端**：uni-app (Vue 2) — 用户访问入口
- **管理后台**：Vue 3 + Vite + Element Plus — 管理员运营系统
- **后台服务**：Spring Boot 3 + MyBatis-Plus — 前后端分离 API 服务

---

## 1. 数据库

### 初始化

```bash
# 1. 创建数据库
mysql -u root -p
CREATE DATABASE red_tourism DEFAULT CHARACTER SET utf8mb4;
EXIT;

# 2. 执行初始化脚本
mysql -u root -p red_tourism < sql/init.sql
```

> 脚本路径：`sql/init.sql`
> 数据库名：`red_tourism`

### 默认管理员账号

| 账号 | 密码 | 角色 |
|------|------|------|
| admin | 123456 | 超级管理员 |
| operator | 123456 | 运营人员 |

---

## 2. 后端服务（Spring Boot）

**目录**：`camping-life-admin/`

### 启动

```bash
cd camping-life-admin/camping-life-admin
mvn spring-boot:run
```

服务地址：`http://localhost:8080`

### 接口说明

| 模块 | 接口前缀 | 说明 |
|------|----------|------|
| 管理员登录 | `/api/admin/*` | 登录、获取信息 |
| H5公开接口 | `/api/h5/*` | 首页、景点、路线、预约 |
| 管理后台接口 | `/admin/*` | CRUD管理（需登录） |
| 数据看板 | `/admin/dashboard/*` | 统计数据 |

---

## 3. 管理后台（Vue 3）

**目录**：`camping-admins-vue/camping-admins-vue/`

### 安装与启动

```bash
cd camping-admins-vue/camping-admins-vue
npm install
npm run dev
```

启动后访问：`http://localhost:5173`

### 页面说明

- `/login` — 管理员登录
- `/dashboard` — 数据看板（ECharts统计图）
- `/red-attraction` — 红色景点管理（CRUD）
- `/travel-route` — 旅游路线管理（CRUD）
- `/team-booking` — 团队预约管理（确认/拒绝/完成/取消）

---

## 4. H5移动端（uni-app）

**目录**：`camping-wx-uniapp/camping-wx-uniapp/`

### 开发调试（H5）

```bash
cd camping-wx-uniapp/camping-wx-uniapp
npm install
# 使用 HBuilderX 打开项目，运行 → 运行到浏览器 → Chrome
```

### 页面说明

| 页面路径 | 说明 |
|----------|------|
| `pages/index/index` | 首页（轮播图+快捷入口+景点/路线Tab） |
| `pages/attraction/detail` | 景点详情（简介+红色历史故事） |
| `pages/route/detail` | 路线详情（行程安排+费用说明+集合信息） |
| `pages/booking/form` | 团队预约表单 |
| `pages/booking/order` | 我的预约列表 |

---

## 技术栈

| 模块 | 技术 |
|------|------|
| H5移动端 | uni-app (Vue 2)、uni-ui |
| 管理后台 | Vue 3、Vite、TypeScript、Element Plus、Pinia、ECharts |
| 后端服务 | Spring Boot 3、MyBatis-Plus、MySQL、BCrypt |

---

## 目录结构

```
.
├── sql/
│   └── init.sql                    # 数据库初始化脚本
├── camping-life-admin/             # Spring Boot 后端
│   └── src/main/java/com/camping/life/
│       ├── RedTourismApplication.java
│       ├── common/                 # 统一响应、异常处理
│       ├── redtour/
│       │   ├── controller/admin/   # 管理端API
│       │   ├── controller/api/     # H5端API
│       │   ├── domain/             # 实体类
│       │   ├── mapper/             # Mapper接口
│       │   └── service/impl/       # 业务实现
│       └── src/main/resources/
│           └── application.yml      # 配置文件
├── camping-admins-vue/             # Vue 3 管理后台
│   └── camping-admins-vue/
│       └── src/
│           ├── api/                # API请求封装
│           ├── layouts/            # 布局组件
│           ├── router/             # 路由配置
│           ├── store/              # Pinia状态管理
│           ├── types/              # TypeScript类型
│           ├── utils/              # 请求工具
│           └── views/              # 页面组件
└── camping-wx-uniapp/             # uni-app H5移动端
    └── camping-wx-uniapp/
        ├── pages/                  # 页面
        ├── static/                 # 静态资源
        └── utils/
            └── api.js              # API请求封装
```
