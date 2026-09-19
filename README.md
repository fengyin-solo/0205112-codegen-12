# 贵州红色文化旅游景点信息管理系统

> 基于 SpringBoot 的全栈旅游景点信息管理平台，支持游客端与管理端双入口，具备景点浏览、旅游线路、红色文化传播、酒店美食预订、多语言、地图展示、审核工作流等完整业务功能。

---

## 1. 快速启动

```bash
docker compose up --build -d
```

启动后等待约 20-30 秒，待后端服务完成数据库初始化，即可访问：

| 入口 | 地址 |
|------|------|
| 🌐 游客端 | http://localhost:8083 |
| 🔧 管理端 | http://localhost:8084 |
| 🔌 后端 API | http://localhost:8089/api/ |
| 🗄️ 数据库 | localhost:8088（root / root123） |

---

## 2. 测试账号

| 角色 | 用户名 | 密码 | 登录入口 |
|------|--------|------|---------|
| 管理员 | admin | admin123 | http://localhost:8084 |
| 工作人员 | staff1 | 123456 | http://localhost:8084 |
| 工作人员 | staff2 | 123456 | http://localhost:8084 |
| 游客 | zhangsan | 123456 | http://localhost:8083 |
| 游客 | lisi | 123456 | http://localhost:8083 |

---

## 3. 功能模块

### 游客端（http://localhost:8083）— 22 个页面

| 页面 | 核心功能 |
|------|---------|
| 首页 `index.html` | 景点轮播图、热门景点卡片、推荐线路、红色文化快速入口 |
| 景点列表 `spots.html` | 分页展示、地区/主题/状态多条件筛选、关键词搜索、距离/人气/好评排序 |
| 景点详情 `spot-detail.html` | 图片轮播、基础信息、红色文化解读（历史背景/革命事件/人物故事）、Leaflet 嵌入式地图、相关景点推荐、用户评论、预订门票、问题反馈跳转、**信息更正提交**、**打卡盖章** |
| **我的集章** `stamps.html` | 主题集章进度（已集/总数、还差几个）、盖章记录、集满主题生成纪念册（导出图片/打包下载） |
| 线路列表 `routes.html` | 天数（1-7天）/主题分类筛选、收藏 |
| 线路详情 `route-detail.html` | 行程安排、景点地图标注（OpenStreetMap）、交通住宿预算建议、预订、**导出/打印** |
| 红色文化列表 `culture.html` | 分类浏览、关键词搜索、点赞、收藏 |
| 红色文化详情 `culture-detail.html` | 富文本内容、点赞、收藏、分享 |
| 酒店列表/详情 `hotels.html` / `hotel-detail.html` | 酒店信息（早餐/客房服务）、日期房间选择、预订、模拟支付 |
| 美食列表/详情 `foods.html` / `food-detail.html` | 美食分类、门店信息（位置/卫生/品类）、购买、模拟支付 |
| 登录/注册/找回密码 | 账号密码登录（记住我）、手机号注册、旧密码验证找回 |
| 个人中心 `profile.html` | 修改昵称/手机号/头像、修改密码 |
| 我的订单 `orders.html` | 订单列表（按状态筛选）、立即支付、取消、申请退款 |
| 我的收藏 `favorites.html` | 景点/线路/文化/酒店收藏管理 |
| 消息通知 `messages.html` | 系统消息列表（审核结果/评论回复/反馈回复自动推送） |
| 我的线路 `my-routes.html` | 创建/编辑/删除自定义线路，拖拽添加景点，提交申请官方推荐，查看审核状态与驳回原因 |
| 问题反馈 `feedback.html` | 提交 Bug/建议/投诉（支持从景点详情预填信息），查看历史反馈及管理员回复 |
| 客服中心 `faq.html` | 智能客服（FAQ关键词匹配自动回复）+ **人工客服**（一键切换，5秒轮询实时显示管理员回复） |
| 多语言 | 中/英/日三语切换（导航栏 select，后端 API 支持 `lang=zh/en/ja` 参数） |

### 管理端（http://localhost:8084）— 16 个页面

| 页面 | 核心功能 |
|------|---------|
| 仪表盘 `index.html` | 用户数/景点数/订单数/收入总览，快捷入口卡片 |
| 用户管理 `users.html` | 列表（角色/状态/关键词筛选）、新增/编辑、禁用/启用、重置密码、删除、**CSV 导出**、**盖章数统计与集章详情查看** |
| 景点管理 `spots.html` | 景点 CRUD、图片上传管理、开放状态切换、访问量/收藏量/评分统计 |
| 线路管理 `routes.html` | 推荐线路 CRUD、行程景点关联与排序、封面图上传 |
| 文化管理 `culture.html` | 文化内容 CRUD、分类管理、**Quill 富文本编辑器**（支持图片/视频/表格插入） |
| 酒店管理 `hotels.html` | 酒店 CRUD、早餐/客房服务配置 |
| 美食管理 `foods.html` | 美食 CRUD、门店 CRUD |
| 留言管理 `comments.html` | 查看所有评论、回复留言（自动发送通知）、删除违规评论 |
| 订单管理 `orders.html` | 订单列表（类型/状态筛选）、完成/取消/退款/删除，显示具体支付方式 |
| FAQ 管理 `faqs.html` | 常见问题 CRUD（供智能客服匹配使用） |
| 问题反馈 `feedbacks.html` | 查看用户反馈、回复（自动消息通知）、状态流转（待处理→处理中→已解决）、删除 |
| 线路审核 `route-review.html` | 审核用户申请推荐的自定义线路，通过后纳入官方推荐，驳回填写原因，操作自动通知用户 |
| **景点审核** `spot-review.html` | 审核用户提交的景点信息更正建议，通过后自动更新景点字段，驳回附理由，操作自动通知用户 |
| **权限配置** `permissions.html` | 角色 CRUD（新增/修改/删除角色）、菜单权限精细化分配（启用/禁用各角色对菜单/按钮的访问） |
| **人工客服** `customer-service.html` | 左侧用户会话列表（显示最新消息预览），右侧对话面板，管理员实时回复用户咨询 |
| 管理员登录 `login.html` | 独立管理员身份验证 |

---

## 4. API 端点速查

### 认证
| 端点 | 说明 |
|------|------|
| `GET /api/auth/login?username=&password=` | 登录（支持 remember-me） |
| `GET /api/auth/register?username=&password=&phone=` | 注册 |
| `GET /api/auth/resetPassword?phone=&oldPassword=&newPassword=` | 密码找回 |
| `GET /api/auth/logout` | 退出登录 |
| `GET /api/auth/me` | 获取当前登录用户信息 |

### 景点
| 端点 | 说明 |
|------|------|
| `GET /api/spot/list?page=&size=&region=&theme=&status=&keyword=&orderBy=&lang=` | 列表（lang: zh/en/ja，orderBy: viewCount/rating/favoriteCount/commentCount） |
| `GET /api/spot/detail?id=&lang=` | 详情 |
| `GET /api/spot/carousel` | 首页轮播图 |
| `GET /api/spot/search?keyword=&orderBy=&lang=` | 模糊搜索 |
| `GET /api/spot/related?id=&region=&theme=` | 相关景点推荐 |

### 线路
| 端点 | 说明 |
|------|------|
| `GET /api/route/list?page=&size=&days=&theme=&lang=` | 推荐线路列表 |
| `GET /api/route/detail?id=&lang=` | 线路详情（含行程景点列表） |

### 红色文化
| 端点 | 说明 |
|------|------|
| `GET /api/culture/list?page=&size=&categoryId=&keyword=&lang=` | 文化内容列表 |
| `GET /api/culture/detail?id=&lang=` | 文化内容详情 |
| `GET /api/culture/categories` | 分类列表 |

### 酒店 / 美食
| 端点 | 说明 |
|------|------|
| `GET /api/hotel/list?page=&size=&keyword=&orderBy=` | 酒店列表 |
| `GET /api/hotel/detail?id=` | 酒店详情 |
| `GET /api/food/list?page=&size=&category=&keyword=` | 美食列表 |
| `GET /api/food/detail?id=` | 美食详情（含门店信息） |

### 用户交互
| 端点 | 说明 |
|------|------|
| `GET /api/order/create?orderType=&targetId=&targetName=&amount=&quantity=` | 创建订单 |
| `GET /api/order/pay?orderId=&payMethod=` | 模拟支付（payMethod: WECHAT/BANK_ICBC/BANK_CCB/BANK_ABC/BANK_BOC/BANK_BOCOM/BANK_CMB/BANK_PSBC） |
| `GET /api/order/cancel?orderId=` | 取消订单 |
| `GET /api/order/refund?orderId=` | 申请退款 |
| `GET /api/order/myList?page=&size=` | 我的订单列表 |
| `GET /api/favorite/add?targetType=&targetId=` | 收藏/取消收藏 |
| `GET /api/favorite/list?targetType=` | 收藏列表 |
| `GET /api/like/add?targetType=&targetId=` | 点赞/取消点赞 |
| `GET /api/comment/add?targetType=&targetId=&content=&rating=` | 发表评论 |
| `GET /api/comment/list?targetType=&targetId=&page=&size=` | 评论列表 |
| `GET /api/message/list?page=&size=` | 消息通知列表 |
| `GET /api/message/unreadCount` | 未读消息数 |

### 打卡集章
| 端点 | 说明 |
|------|------|
| `GET /api/stamp/checkin?spotId=` | 打卡盖章（需登录；重复到访只保留一枚章与首次到访时间） |
| `GET /api/stamp/check?spotId=` | 查询当前景点是否已盖章 |
| `GET /api/stamp/my` | 我的盖章记录列表 |
| `GET /api/stamp/count` | 我的盖章总数（与后台用户列表盖章数同一口径） |
| `GET /api/stamp/progress` | 按主题的集章进度（含 remaining=还差几个） |
| `GET /api/stamp/album/export?theme=&format=` | 导出主题纪念册（format: image/zip；需已集满该主题；原子写入，重新导出覆盖上一次结果） |
| `GET /api/stamp/album/list` | 我的纪念册列表（已集满主题及已生成文件） |

### 自定义线路
| 端点 | 说明 |
|------|------|
| `GET /api/customRoute/list` | 我的自定义线路列表 |
| `GET /api/customRoute/save?name=&description=&days=&spotData=` | 保存线路 |
| `GET /api/customRoute/delete?id=` | 删除线路 |
| `GET /api/customRoute/submitForReview?id=` | 申请官方推荐 |

### 客服 & 反馈
| 端点 | 说明 |
|------|------|
| `GET /api/faq/list` | FAQ 列表 |
| `GET /api/faq/ask?question=` | 智能客服问答 |
| `GET /api/chat/send?content=` | 向人工客服发送消息（需登录） |
| `GET /api/chat/history` | 查看与客服的对话记录 |
| `GET /api/feedback/submit?category=&title=&content=` | 提交问题反馈 |
| `GET /api/feedback/my` | 我的反馈记录 |

### 景点信息更正
| 端点 | 说明 |
|------|------|
| `GET /api/spotSuggestion/submit?spotId=&fieldName=&newValue=&reason=` | 提交更正建议（fieldName: name/description/location/openTime/ticketPrice/trafficInfo） |
| `GET /api/spotSuggestion/my` | 我的更正建议列表 |

### 管理端（需 ADMIN 或 STAFF 角色）
| 端点 | 说明 |
|------|------|
| `GET /api/admin/user/list?page=&size=&role=&status=&keyword=` | 用户列表 |
| `GET /api/admin/user/save?username=&role=&nickname=&phone=&password=` | 新增/编辑用户 |
| `GET /api/admin/user/toggleStatus?id=` | 禁用/启用用户 |
| `GET /api/admin/user/resetPassword?id=&newPassword=` | 重置密码 |
| `GET /api/admin/user/delete?id=` | 删除用户 |
| `GET /api/admin/user/export` | 导出全部用户 CSV |
| `GET /api/admin/user/stamps?userId=` | 查看指定用户的盖章记录（总数与列表盖章数同口径） |
| `GET /api/admin/spot/list?page=&size=` | 景点列表（STAFF 仅返回本人所属景点） |
| `GET /api/admin/spot/save?...` | 景点新增/编辑（STAFF 新增自动绑定 `staff_id`） |
| `GET /api/admin/spot/delete?id=` | 删除景点（STAFF 仅可删本人景点） |
| `GET /api/admin/spot/toggleStatus?id=` | 切换景点状态（STAFF 仅可操作本人景点） |
| `GET /api/admin/spot/addImage?spotId=&imageUrl=&sortOrder=` | 添加景点图片（STAFF 仅可操作本人景点） |
| `GET /api/admin/spot/deleteImage?imageId=` | 删除景点图片（STAFF 仅可操作本人景点） |
| `GET /api/admin/route/*` | 线路 CRUD |
| `GET /api/admin/culture/*` | 文化内容 CRUD |
| `GET /api/admin/hotel/*` | 酒店 CRUD |
| `GET /api/admin/food/*` | 美食 CRUD |
| `GET /api/admin/comment/*` | 留言管理（list/reply/delete） |
| `GET /api/admin/order/*` | 订单管理（list/complete/cancel/refund/delete） |
| `GET /api/admin/faq/*` | FAQ CRUD |
| `GET /api/admin/feedback/*` | 反馈管理（list/reply/status/delete） |
| `GET /api/admin/customRoute/list?status=` | 用户提交的线路审核列表 |
| `GET /api/admin/customRoute/approve?id=` | 通过线路审核（纳入推荐） |
| `GET /api/admin/customRoute/reject?id=&reason=` | 驳回线路 |
| `GET /api/admin/customRoute/pendingCount` | 线路待审数量 |
| `GET /api/admin/spotSuggestion/list?status=` | 景点更正审核列表 |
| `GET /api/admin/spotSuggestion/approve?id=` | 通过景点更正（自动更新景点数据） |
| `GET /api/admin/spotSuggestion/reject?id=&reason=` | 驳回景点更正 |
| `GET /api/admin/spotSuggestion/pendingCount` | 景点更正待审数量 |
| `GET /api/admin/chat/sessions` | 客服用户会话列表 |
| `GET /api/admin/chat/history?userId=` | 查看指定用户对话记录 |
| `GET /api/admin/chat/send?userId=&content=` | 管理员发送客服消息 |
| `GET /api/admin/role/list` | 角色列表 |
| `GET /api/admin/role/save?code=&name=&description=` | 新增/编辑角色 |
| `GET /api/admin/role/delete?id=` | 删除角色 |
| `GET /api/admin/role/menu/list?roleCode=` | 角色菜单权限列表 |
| `GET /api/admin/role/menu/save?roleCode=&menuKey=&menuName=` | 新增菜单权限 |
| `GET /api/admin/role/menu/toggle?id=` | 启用/禁用菜单权限 |
| `GET /api/admin/role/menu/delete?id=` | 删除菜单权限 |
| `GET /api/admin/stats` | 系统统计数据 |

---

## 5. 角色设计说明

### 三角色架构（含工作人员隔离）

本系统当前采用 **USER（游客）**、**ADMIN（管理员）**、**STAFF（工作人员）** 三角色并行模型，其中 STAFF 专门用于满足“工作人员仅操作所属景点”的审计要求。

| 角色 | 权限边界 |
|------|---------|
| USER | 游客端浏览、收藏、评论、下单、自定义线路、问题反馈、景点信息更正、客服咨询 |
| ADMIN | 管理端全量权限，可管理全部景点与全系统业务数据 |
| STAFF | 可访问管理端景点管理能力，但仅能操作 `scenic_spot.staff_id = 当前用户ID` 的景点，越权操作统一拒绝 |

景点权限隔离的强约束已落在后端接口层（`/api/admin/spot/*`），包含列表过滤、编辑/删除/状态切换、图片新增/删除的所属校验。

---

## 6. 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | Spring Boot 2.7.18 + Spring Security |
| ORM | MyBatis-Plus 3.5.3.1 |
| 数据库 | MySQL 8.0 |
| 运行时 | JDK 1.8（eclipse-temurin:8-jre） |
| 构建 | Maven 3.9 |
| 前端 | 原生 HTML5 + CSS3 + JavaScript（无框架） |
| 富文本 | Quill.js 1.3.6 |
| 地图 | Leaflet 1.9.4 + OpenStreetMap |
| 容器 | Docker + Docker Compose + Nginx alpine |
| 设计约束 | 密码明文存储、HttpSession 认证、全 GET 请求、CORS 全局配置 |

---

## 7. 项目结构

```
label-02051/
├── backend/                          # SpringBoot 后端（~4000 行代码）
│   ├── src/main/java/com/redtourism/
│   │   ├── config/                   # Security / CORS / MybatisPlus / WebMvc 配置
│   │   ├── common/                   # Result 统一响应、全局异常处理、常量
│   │   ├── entity/                   # 23 个实体类
│   │   ├── mapper/                   # 23 个 MyBatis-Plus Mapper
│   │   ├── service/                  # 11 个业务接口 + 实现
│   │   └── controller/               # 20 个 REST Controller（~1900 行）
│   ├── src/main/resources/
│   │   ├── schema.sql                # 建表脚本（23 张表）
│   │   ├── data.sql                  # 初始化数据（景点/线路/文化/酒店/美食/FAQ等）
│   │   └── application.yml           # 应用配置（session 30min、文件上传 10MB）
│   ├── uploads/                      # 图片资源（49 张，含景点/线路/酒店/美食封面）
│   ├── Dockerfile                    # 标准构建（含 mvn package）
│   └── Dockerfile.fast               # 快速构建（直接拷贝预编译 JAR）
├── frontend-user/                    # 游客端前端（22 个页面）
│   ├── css/style.css                 # 全局样式（CSS 变量 + 响应式）
│   ├── js/common.js                  # 公共函数（api/getUser/i18n/分页/Toast等）
│   └── *.html                        # 业务页面
├── frontend-admin/                   # 管理端前端（16 个页面）
│   ├── css/admin.css                 # 管理端样式
│   ├── js/admin-common.js            # 管理端公共函数（requireAdmin/renderSidebar等）
│   └── *.html                        # 管理页面
├── nginx/
│   └── default.conf                  # 反向代理配置（:80→游客端 :81→管理端 /api/→后端）
├── docker-compose.yml                # 三服务编排（MySQL + Backend + Nginx）
└── docs/                             # 项目文档
    ├── Requirements.md
    ├── Roadmap.md
    ├── DesignSpec.md
    ├── AuditReport.md
    └── SelfTestReport.md
```

### 数据库表清单（23 张）

| 表名 | 说明 | 初始数据 |
|------|------|---------|
| `sys_user` | 用户（USER/ADMIN/STAFF） | 6 条 |
| `sys_role` | 角色定义 | 3 条 |
| `sys_role_menu` | 角色菜单权限 | 25 条 |
| `scenic_spot` | 景点信息（含多语言字段） | 8 条 |
| `scenic_spot_image` | 景点图片 | 若干 |
| `route` | 推荐线路 | 5 条 |
| `route_spot` | 线路-景点关联 | 若干 |
| `culture_category` | 红色文化分类 | 若干 |
| `culture_content` | 红色文化内容 | 6 条 |
| `hotel` | 酒店信息 | 5 条 |
| `food` | 美食信息 | 7 条 |
| `food_store` | 美食门店 | 若干 |
| `comment` | 用户评论/留言 | 若干 |
| `favorite` | 收藏记录 | — |
| `like_record` | 点赞记录 | — |
| `order_info` | 订单信息 | — |
| `message` | 系统消息通知 | — |
| `faq` | 常见问题 | 8 条 |
| `feedback` | 用户问题反馈 | 若干 |
| `user_custom_route` | 用户自定义线路 | 3 条 |
| `spot_suggestion` | 景点信息更正建议 | — |
| `service_chat` | 人工客服对话记录 | — |
| `spot_stamp` | 打卡集章记录（user_id+spot_id 唯一，保留首次到访时间） | 5 条 |

---

## 8. 支付说明（Mock 模式）

支付为完整模拟流程，调用 `/api/order/pay` 即立即标记为已支付，无需真实扣款。

支持以下支付方式（前端均有对应选项）：

| 方式代码 | 显示名称 |
|---------|---------|
| `WECHAT` | 微信支付 |
| `BANK_ICBC` | 工商银行 |
| `BANK_CCB` | 建设银行 |
| `BANK_ABC` | 农业银行 |
| `BANK_BOC` | 中国银行 |
| `BANK_BOCOM` | 交通银行 |
| `BANK_CMB` | 招商银行 |
| `BANK_PSBC` | 邮储银行 |

**真实对接方式**：替换 `OrderServiceImpl.payOrder()` 方法，在其中按 `payMethod` 路由调用对应支付 SDK（微信支付 SDK / 各银行开放平台 API），保持接口签名不变即可无缝切换。

---

## 9. 注意事项

1. **Docker 构建**：使用多阶段 `Dockerfile`，容器内自动执行 Maven 构建，无需本地预装 Java/Maven 环境，真正一键启动。首次构建因需下载 Maven 依赖耗时约 3-5 分钟，后续有层缓存构建会快很多。
2. **数据持久化**：MySQL 数据通过 Docker named volume `mysql-data` 持久化，`docker compose down` 不会丢失数据；`docker compose down -v` 会清除数据并在下次启动时重新初始化。已有数据卷升级时，`docker-entrypoint-initdb.d` 脚本不会重复执行，需手动执行 `schema.sql` 中新增的 `spot_stamp` 建表语句（或 `down -v` 重建）。
3. **图片上传**：支持 10MB 以内图片上传，存储于 `backend/uploads/` 目录，通过 Nginx 静态服务以 `/uploads/` 路径访问。
4. **打卡集章与纪念册**：景点详情页打卡即盖章（同一景点仅一枚，保留首次到访时间）；集满主题可在「我的集章」导出纪念册（PNG 图片或 ZIP 打包，含主题名称、景点列表、到访日期）。纪念册生成采用"临时文件 + 原子替换"：导出中断不会留下损坏文件，重新导出覆盖上一次结果；文件保存在 `backend/uploads/albums/`。后端镜像已内置 Noto CJK 中文字体，保证纪念册中文渲染正常。
5. **智能客服**：基于 FAQ 表关键词相似度匹配实现自动回复，非 AI 大模型；人工客服采用前端轮询（5 秒间隔）模拟实时效果。
6. **多语言**：英文（en）和日文（ja）内容需在管理端景点/线路/文化编辑页面手动填写对应语言字段（`name_en`/`name_ja`/`description_en`/`description_ja` 等），初始化数据中已为部分景点提供英/日文示例。
7. **Session 超时**：默认 30 分钟，配置于 `application.yml`；前端每 5 分钟检测一次 session 状态，超时自动弹窗提示并跳转登录页。
