# ☁️ HDFS Cloud Disk SSM | HDFS 云盘系统 - 基于 SSM 框架 + 分布式 HDFS 存储

> **A distributed cloud disk system built with SSM (Spring + SpringMVC + MyBatis) framework and Apache HDFS for scalable file storage. Features user management, file upload/download, file metadata tracking, and a JSP-based web dashboard.**
>
> 基于 SSM（Spring + SpringMVC + MyBatis）框架和 Apache HDFS 构建的分布式云盘系统，支持可扩展文件存储。功能包括用户管理、文件上传/下载、文件元数据追踪和基于 JSP 的 Web 仪表盘。

---

## 🌟 Why This Project? | 项目亮点

Traditional cloud storage systems face scalability challenges with centralized storage. This project implements a **distributed cloud disk system** leveraging **Apache HDFS** for scalable, fault-tolerant file storage, combined with the **SSM (Spring + SpringMVC + MyBatis)** framework for robust backend architecture. The system supports user registration/login, file upload to HDFS, file download, file metadata management in MySQL, and a responsive JSP-based web dashboard.

传统云存储系统面临集中式存储的可扩展性挑战。本项目实现了一个**分布式云盘系统**，利用 **Apache HDFS** 实现可扩展、容错的文件存储，结合 **SSM（Spring + SpringMVC + MyBatis）** 框架构建健壮的后端架构。系统支持用户注册/登录、文件上传到 HDFS、文件下载、MySQL 文件元数据管理，以及响应式的 JSP Web 仪表盘。

| Feature | Details |
|---------|---------|
| **Backend Framework** | SSM (Spring + SpringMVC + MyBatis) |
| **Distributed Storage** | Apache HDFS (Hadoop Distributed File System) |
| **Database** | MySQL (file metadata, user accounts) |
| **Frontend** | JSP + JSTL + CSS (index + dashboard) |
| **User Management** | Registration, login, session management |
| **File Operations** | Upload, download, delete, list, metadata |
| **Build Tool** | Maven (pom.xml) |
| **Connection Pool** | HikariCP / Druid (via Spring config) |
| **Logging** | Logback |

---

## 🏗️ Architecture | 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                     Web Browser (Client)                       │
│              JSP Pages: index.jsp, dashboard.jsp               │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTP/HTTPS
                               ▼
┌─────────────────────────────────────────────────────────────┐
│              Spring MVC Controller Layer                       │
│  ┌─────────────────────┐  ┌─────────────────────┐           │
│  │  FileController     │  │  UserController     │           │
│  │  • upload()         │  │  • register()       │           │
│  │  • download()       │  │  • login()          │           │
│  │  • delete()         │  │  • logout()         │           │
│  │  • listFiles()      │  │  • getUserInfo()    │           │
│  └──────────┬──────────┘  └──────────┬──────────┘           │
└─────────────┼──────────────────────────┼──────────────────────┘
              │                          │
              ▼                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   Service Layer (Spring)                       │
│  ┌─────────────────────┐  ┌─────────────────────┐           │
│  │  FileService        │  │  UserService        │           │
│  │  • saveFile()       │  │  • registerUser()   │           │
│  │  • getFile()        │  │  • authenticate()   │           │
│  │  • deleteFile()     │  │  • getUserById()    │           │
│  │  • listUserFiles()  │  │                     │           │
│  └──────────┬──────────┘  └──────────┬──────────┘           │
└─────────────┼──────────────────────────┼──────────────────────┘
              │                          │
    ┌─────────┴──────────┐    ┌────────┴──────────┐
    ▼                    ▼    ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ HdfsService  │  │ FileInfoMapper│  │ UserMapper   │  │   MySQL DB   │
│              │  │   (MyBatis)   │  │  (MyBatis)   │  │              │
│ • upload()   │  │ • insert()     │  │ • insert()    │  │ • user table │
│ • download() │  │ • selectById() │  │ • selectBy... │  │ • file_info  │
│ • delete()   │  │ • selectByUser()│ │ • update()    │  │              │
│ • listDir()  │  │ • delete()     │  │ • delete()    │  │              │
└──────┬───────┘  └──────────────┘  └──────────────┘  └──────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│              Apache HDFS (Distributed Storage)                 │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  NameNode (metadata) + DataNodes (block storage)        │  │
│  │  • Replication: 3x (default)                            │  │
│  │  • Block size: 128MB (default)                          │  │
│  │  • Path: /user/{username}/files/                        │  │
│  └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure | 项目结构

```
HDFS-Cloud-Disk-SSM/
├── pom.xml                              # Maven build configuration
├── README.md                            # This file
├── 快速启动指南.md                      # Quick start guide (Chinese)
├── MyBatis参数绑定修复报告.md           # MyBatis parameter binding fix report
├── 精品博客.md                          # Technical blog
├── 汉化说明.md                          # Localization notes
├── src/main/
│   ├── java/com/hdfs/cloud/
│   │   ├── controller/
│   │   │   ├── FileController.java      # File operations REST controller
│   │   │   └── UserController.java      # User management controller
│   │   ├── entity/
│   │   │   ├── FileInfo.java            # File metadata entity
│   │   │   └── User.java                # User entity
│   │   ├── mapper/
│   │   │   ├── FileInfoMapper.java      # MyBatis mapper for file metadata
│   │   │   └── UserMapper.java          # MyBatis mapper for users
│   │   └── service/
│   │       ├── FileService.java          # File business logic
│   │       ├── HdfsService.java          # HDFS operations wrapper
│   │       └── UserService.java          # User business logic
│   ├── resources/
│   │   ├── applicationContext.xml        # Spring core configuration
│   │   ├── spring-mvc.xml                # Spring MVC configuration
│   │   ├── mybatis-config.xml            # MyBatis configuration
│   │   ├── db.properties                  # Database connection properties
│   │   ├── hdfs.properties                # HDFS connection properties
│   │   ├── logback.xml                   # Logging configuration
│   │   └── init.sql                      # Database initialization script
│   └── webapp/
│       ├── index.jsp                     # Login/registration page
│       ├── dashboard.jsp                 # Main file management dashboard
│       └── WEB-INF/
│           └── web.xml                   # Web application deployment descriptor
└── src/test/java/com/hdfs/cloud/service/
    └── UserServiceTest.java              # Unit tests for UserService
```

---

## 🚀 Quick Start | 快速开始

### Prerequisites | 前置条件

- JDK 8+
- Maven 3.6+
- MySQL 5.7+ / 8.0+
- Apache Hadoop HDFS 2.7+ / 3.x (running cluster)
- (Optional) Tomcat 8.5+ / 9.x for deployment

### 1. Configure Database | 配置数据库

```bash
# Create database and tables
mysql -u root -p < src/main/resources/init.sql
```

Update `src/main/resources/db.properties`:
```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/hdfs_cloud?useSSL=false&serverTimezone=UTC
jdbc.username=root
jdbc.password=your_password
```

### 2. Configure HDFS | 配置 HDFS

Update `src/main/resources/hdfs.properties`:
```properties
hdfs.uri=hdfs://localhost:9000
hdfs.user=hadoop
hdfs.base.path=/user/cloud/files
```

### 3. Build and Run | 构建并运行

```bash
# Build WAR file
mvn clean package

# Deploy to Tomcat (or run with embedded server)
cp target/hdfs-cloud-disk.war $TOMCAT_HOME/webapps/
$TOMCAT_HOME/bin/startup.sh
```

### 4. Access the Application | 访问应用

```
http://localhost:8080/hdfs-cloud-disk/
```

---

## 🔧 Core Features | 核心功能

### User Management | 用户管理

- **Registration**: Create new user accounts with username/password
- **Login**: Secure authentication with session management
- **Session**: Track logged-in user across requests
- **Logout**: Invalidate session and return to login page

### File Operations | 文件操作

| Operation | Description | HDFS Action |
|-----------|-------------|-------------|
| **Upload** | Upload local file to HDFS | `FileSystem.copyFromLocalFile()` |
| **Download** | Download file from HDFS to local | `FileSystem.open()` + stream |
| **Delete** | Delete file from HDFS and metadata | `FileSystem.delete()` + DB delete |
| **List** | List all files for current user | DB query + HDFS metadata |
| **Metadata** | Track filename, size, upload time, owner | MySQL `file_info` table |

### HDFS Integration | HDFS 集成

The `HdfsService` class wraps the Hadoop `FileSystem` API:
- **Upload**: Streams local file to HDFS path `/user/{username}/files/{filename}`
- **Download**: Opens HDFS file stream and writes to HTTP response
- **Delete**: Removes file from HDFS
- **Directory management**: Creates user-specific directories on first upload

---

## 📊 Database Schema | 数据库架构

### user table | 用户表

| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK, AUTO_INCREMENT) | User ID |
| username | VARCHAR(50, UNIQUE) | Username |
| password | VARCHAR(100) | Password (hashed) |
| email | VARCHAR(100) | Email address |
| create_time | DATETIME | Registration time |

### file_info table | 文件信息表

| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK, AUTO_INCREMENT) | File ID |
| user_id | INT (FK) | Owner user ID |
| file_name | VARCHAR(255) | Original filename |
| file_size | BIGINT | File size in bytes |
| hdfs_path | VARCHAR(500) | HDFS storage path |
| upload_time | DATETIME | Upload timestamp |
| file_type | VARCHAR(50) | MIME type / extension |

---

## 📚 References | 参考文献

1. **Shvachko, K., et al.** (2010). *The Hadoop Distributed File System.* IEEE MSST.
2. **Spring Framework Documentation.** (2024). *Spring Framework Reference.*
3. **MyBatis.** (2024). *MyBatis 3 User Guide.*
4. **Apache Hadoop.** (2024). *HDFS Architecture Guide.*
5. **Walls, C.** (2018). *Spring in Action (5th Edition).* Manning Publications.

---

## 📄 License | 许可证

MIT License — free to use, modify, and distribute.

---

<div align="center">

**Built with ☁️ for distributed storage research**

[Report Bug](https://github.com/Windyhhh/HDFS-Cloud-Disk-SSM/issues) · [Request Feature](https://github.com/Windyhhh/HDFS-Cloud-Disk-SSM/issues)

</div>
