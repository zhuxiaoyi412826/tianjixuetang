# 天机学堂 (Tianji Learning)

> 基于 Spring Cloud 微服务架构的在线教育平台，由学成在线项目升级而来。

## 目录

- [项目简介](#项目简介)
- [技术栈](#技术栈)
- [项目结构](#项目结构)
- [微服务模块](#微服务模块)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [启动指南](#启动指南)
- [API 网关](#api-网关)
- [文档](#文档)

---

## 项目简介

**天机学堂** 是一个功能完整的在线教育平台，包含用户端和管理后台两个部分，实现了课程学习、交易支付、考试测评、AI 智能助手等核心业务流程。

### 核心功能

- 📚 **课程体系** - 课程录播视频、免费课程学习、学习进度跟踪
- 🛒 **交易系统** - 购物车管理、支付宝支付、订单处理
- 🎟️ **促销系统** - 优惠券发放与使用
- 📝 **学习工具** - 笔记记录、课程问答、学习计划
- 📋 **考试系统** - 在线考试、答题评分
- 🤖 **AI 助手** - 智能对话、课程推荐、购买决策
- 👤 **个人中心** - 我的课程、订单、考试、积分、收藏

---

## 技术栈

### 后端

| 技术 | 版本 | 用途 |
|------|------|------|
| Java | 17 | 编程语言 |
| Spring Boot | 3.3.5 | 应用框架 |
| Spring Cloud | 2023.0.3 | 微服务框架 |
| Spring Cloud Alibaba | 2023.0.3.2 | 服务治理 |
| Spring AI | 1.0.0 | AI 集成 |
| MyBatis Plus | 3.5.9 | ORM 框架 |
| MySQL | 8.0.23 | 关系型数据库 |
| Redis (Redisson) | 3.13.6 | 缓存 |
| Elasticsearch | 7.12.1 | 全文搜索 |
| MongoDB | - | NoSQL 数据库 |
| Nacos | 2.3.0 | 注册/配置中心 |
| Seata | 1.5.1 | 分布式事务 |
| XXL-Job | 2.3.1 | 定时任务 |
| RocketMQ | 5.1.4 | 消息队列 |

### 前端

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.2.25 | 前端框架 |
| Vite | 2.9.9 | 构建工具 |
| Element Plus | 2.2.9 | UI 组件库 |
| Pinia | 2.0.15 | 状态管理 |
| Vue Router | 4.1.2 | 路由管理 |
| Sass | 1.53.0 | CSS 预处理 |
| Axios | 0.27.2 | HTTP 请求 |

### 云服务

| 服务 | SDK | 用途 |
|------|-----|------|
| 阿里云 OSS | 3.10.2 | 对象存储 |
| 阿里云支付 | 4.33.12 | 支付处理 |
| 腾讯云 COS | 5.6.89 | 对象存储 |
| 腾讯云 VOD | 2.1.5 | 视频点播 |

---

## 项目结构

```
tianjixuetang/
├── tj-portal-src-master/       # 前端 - 用户端门户
├── tjxt/                       # 后端 - 完整微服务项目
│   ├── tj-common/              #   公共模块
│   ├── tj-api/                 #   API 定义模块
│   ├── tj-auth/                #   认证服务
│   ├── tj-gateway/             #   API 网关
│   ├── tj-user/                #   用户服务
│   ├── tj-course/              #   课程服务
│   ├── tj-learning/            #   学习服务
│   ├── tj-media/               #   媒体服务
│   ├── tj-search/              #   搜索服务
│   ├── tj-trade/               #   交易服务
│   ├── tj-pay/                 #   支付服务
│   ├── tj-exam/                #   考试服务
│   ├── tj-promotion/           #   促销服务
│   ├── tj-remark/              #   评论服务
│   ├── tj-data/                #   数据服务
│   ├── tj-message/             #   消息服务
│   ├── tj-aigc/                #   AI 智能服务
│   └── pom.xml                 #   父工程 POM
├── tjxt-javaai02/              # 后端 - 空壳代码（仅 pom.xml）
├── tjxt-stu-1.0/               # 后端 - 学生端简化版
├── md/                         # 项目文档
│   ├── 项目.md
│   ├── 启动后端项目流程.md
│   └── ...
└── README.md
```

---

## 微服务模块

| 服务 | 模块 | 路由前缀 | 说明 |
|------|------|---------|------|
| 网关服务 | tj-gateway | - | 统一路由转发 (端口 10010) |
| 认证服务 | tj-auth | /as | JWT 认证与授权 |
| 用户服务 | tj-user | /us | 用户注册、登录、信息管理 |
| 课程服务 | tj-course | /cs | 课程 CRUD、目录管理 |
| 学习服务 | tj-learning | /ls | 学习进度、笔记、问答 |
| 媒体服务 | tj-media | /ms | 视频上传、转码、播放 |
| 搜索服务 | tj-search | /ss | 课程全文搜索 |
| 交易服务 | tj-trade | /ts | 购物车、订单创建 |
| 支付服务 | tj-pay | /ps | 支付宝支付处理 |
| 考试服务 | tj-exam | /es | 在线考试、答题评分 |
| 促销服务 | tj-promotion | /prs | 优惠券管理 |
| 评论服务 | tj-remark | /rs | 课程评论与评分 |
| 数据服务 | tj-data | /ds | 数据统计与报表 |
| 消息服务 | tj-message | /sms | 消息推送与通知 |
| AI 服务 | tj-aigc | /ais | AI 对话、推荐、购买助手 |

---

## 环境要求

| 环境 | 版本 | 说明 |
|------|------|------|
| JDK | 17+ | Java 开发工具包 |
| Maven | 3.6+ | 构建工具 |
| Node.js | 14+ | 前端运行环境 |
| npm | 6+ | 前端包管理 |

### 基础设施

| 组件 | 端口 | 版本 | 必填 |
|------|------|------|------|
| Nacos | 8848 | 2.3.0 | ✅ |
| MySQL | 3306 | 8.0.23 | ✅ |
| Redis | 6379 | 7.x+ | ✅ |
| Elasticsearch | 9200 | 7.12.1 | ⚠️ 搜索服务 |
| MongoDB | 27017 | 6.x+ | ⚠️ AI 服务 |
| RocketMQ | 9876 | 5.1.4 | ⚠️ 可选 |
| Seata | 8091 | 1.5.1 | ⚠️ 可选 |
| XXL-Job | 8800 | 2.3.1 | ⚠️ 可选 |

---

## 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd tianjixuetang
```

### 2. 启动基础设施

```bash
# Docker 一键启动（推荐）
docker run -d --name nacos -p 8848:8848 -e MODE=standalone nacos/nacos-server:v2.3.0
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql:8.0.23
docker run -d --name redis -p 6379:6379 redis:7
```

### 3. 配置 Nacos

访问 `http://127.0.0.1:8848/nacos`（账号: nacos / 密码: nacos），创建共享配置：

- `shared-spring.yaml` - Spring 通用配置
- `shared-redis.yaml` - Redis 连接
- `shared-mybatis.yaml` - MyBatis Plus 配置
- `shared-logs.yaml` - 日志配置
- `shared-feign.yaml` - Feign 配置

### 4. 编译与启动后端

```bash
cd tjxt

# 安装公共模块
mvn install -pl tj-common,tj-api -am -DskipTests

# 编译全部
mvn clean package -DskipTests

# 按顺序启动各服务（详见启动指南）
```

### 5. 启动前端

```bash
cd tj-portal-src-master

# 安装依赖
npm install

# 开发模式
npm run dev

# 访问 http://localhost:18082
```

---

## 启动指南

详细的启动说明请参考：[启动后端项目流程.md](md/启动后端项目流程.md)

### 最小化启动（核心功能）

```
启动基础设施 → 编译公共模块 → auth → user → course → learning → gateway
```

### 完全化启动（全部功能）

```
启动基础设施 → 编译公共模块 → auth → user → course → learning → media → search → trade → pay → promotion → exam → remark → data → message → aigc → gateway
```

---

## API 网关

所有微服务通过网关统一访问：

```
http://127.0.0.1:10010/{路由前缀}/**
```

| 示例 | URL |
|------|-----|
| 用户登录 | `POST http://127.0.0.1:10010/as/auth/login` |
| 课程列表 | `GET http://127.0.0.1:10010/cs/course/list` |
| 购物车 | `GET http://127.0.0.1:10010/ts/cart/list` |

---

## 文档

| 文档 | 说明 |
|------|------|
| [项目.md](md/项目.md) | 项目完整识别报告 |
| [启动后端项目流程.md](md/启动后端项目流程.md) | 详细启动指南 |
| [后端服务配置.txt](md/后端服务配置.txt) | 基础设施依赖说明 |
| [后端服务下载链接.txt](md/后端服务下载链接.txt) | 相关组件下载地址 |

---

## 项目迭代

| 版本 | 时间 | 主要功能 |
|------|------|---------|
| v1.1 | 2022.7.11 - 2022.7.31 | 用户、课程、搜索、购买、优惠券、财务 |
| v1.2 | 2022.8.4 - 2022.8.12 | 免费课程、视频播放、问答、笔记 |
| v1.3 | 2022.8.12 - 2022.9.20 | 个人中心、考试、订单、积分 |

---

## License

MIT License
