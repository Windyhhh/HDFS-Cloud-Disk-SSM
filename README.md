# ☁️ HDFS 云盘 SSM 系统 | HDFS Cloud Disk with SSM

> **基于 Hadoop HDFS 的分布式云存储系统——Spring + SpringMVC + MyBatis 全栈架构，支持大文件分片上传、秒传、断点续传，存储容量无限扩展。**
>
> *Distributed cloud storage system based on Hadoop HDFS — Spring + SpringMVC + MyBatis full-stack architecture, supporting large file chunked upload, instant upload, resumable upload, infinitely scalable storage.*

---

## ⭐ 核心卖点 | Why Star This

| 卖点 | Feature | 一句话 |
|------|---------|--------|
| 🐘 **HDFS 分布式存储** | HDFS Storage | 基于 Hadoop 分布式文件系统，存储容量无限扩展 |
| 🍃 **SSM 全栈框架** | SSM Framework | Spring + SpringMVC + MyBatis 经典 Java Web 架构 |
| 📦 **大文件分片上传** | Chunked Upload | 大文件分片上传，支持断点续传和秒传 |
| ⚡ **秒传功能** | Instant Upload | MD5 去重，已上传文件秒传，节省带宽和存储 |
| 🔐 **用户权限管理** | User Permission | 多用户隔离，文件分享，权限控制 |

---

## 🏆 技术栈 | Tech Stack

![Java](https://img.shields.io/badge/Java-8+-blue?logo=openjdk)
![Spring](https://img.shields.io/badge/Spring-5.0+-green?logo=spring)
![MyBatis](https://img.shields.io/badge/MyBatis-3.5+-red?logo=mybatis)
![Hadoop](https://img.shields.io/badge/Hadoop-3.0+-yellow?logo=apachehadoop)
![MySQL](https://img.shields.io/badge/MySQL-5.7+-blue?logo=mysql)
![Bootstrap](https://img.shields.io/badge/Bootstrap-4.0+-purple?logo=bootstrap)

---

## 📊 系统架构 | System Architecture

| 层级 | 技术 | 职责 |
|------|------|------|
| 表现层 | SpringMVC + JSP + Bootstrap | 用户界面、请求分发 |
| 业务层 | Spring | 业务逻辑、事务管理 |
| 持久层 | MyBatis | 数据访问、ORM 映射 |
| 存储层 | HDFS + MySQL | 文件存储 (HDFS) + 元数据 (MySQL) |
| 计算层 | Hadoop | 分布式存储、数据本地化 |

---

## 🚀 快速开始 | Quick Start

```bash
# 1. 启动 Hadoop
start-dfs.sh
start-yarn.sh

# 2. 创建 HDFS 目录
hdfs dfs -mkdir -p /cloudisk/files
hdfs dfs -mkdir -p /cloudisk/chunks

# 3. 初始化数据库
mysql -u root -p < sql/init.sql

# 4. 修改配置
# 修改 src/main/resources/jdbc.properties 中的数据库连接
# 修改 src/main/resources/hdfs.properties 中的 HDFS 地址

# 5. 编译打包
mvn clean package -DskipTests

# 6. 部署到 Tomcat
cp target/cloudisk.war $TOMCAT_HOME/webapps/
$TOMCAT_HOME/bin/startup.sh

# 7. 访问
# http://localhost:8080/cloudisk
```

---

## 📂 项目结构 | Project Structure

```
HDFS-Cloud-Disk-SSM/
├── src/main/
│   ├── java/com/cloudisk/
│   │   ├── controller/        # 控制器层
│   │   │   ├── UserController.java
│   │   │   ├── FileController.java
│   │   │   ├── UploadController.java
│   │   │   └── ShareController.java
│   │   ├── service/           # 业务层
│   │   │   ├── UserService.java
│   │   │   ├── FileService.java
│   │   │   ├── UploadService.java
│   │   │   └── HdfsService.java
│   │   ├── mapper/            # 持久层 (MyBatis)
│   │   │   ├── UserMapper.java
│   │   │   ├── FileMapper.java
│   │   │   └── ChunkMapper.java
│   │   ├── pojo/              # 实体类
│   │   │   ├── User.java
│   │   │   ├── File.java
│   │   │   ├── Chunk.java
│   │   │   └── Share.java
│   │   ├── util/              # 工具类
│   │   │   ├── HdfsUtil.java
│   │   │   ├── MD5Util.java
│   │   │   └── FileUtil.java
│   │   └── config/            # 配置类
│   ├── resources/
│   │   ├── spring/            # Spring 配置
│   │   ├── mybatis/           # MyBatis 映射
│   │   ├── jdbc.properties    # 数据库配置
│   │   ├── hdfs.properties    # HDFS 配置
│   │   └── log4j.properties   # 日志配置
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   ├── applicationContext.xml
│       │   └── spring-mvc.xml
│       ├── static/            # 静态资源
│       │   ├── css/
│       │   ├── js/
│       │   └── images/
│       └── pages/             # JSP 页面
│           ├── login.jsp
│           ├── register.jsp
│           ├── index.jsp
│           ├── upload.jsp
│           ├── share.jsp
│           └── file_list.jsp
├── sql/
│   └── init.sql               # 数据库初始化脚本
├── pom.xml                    # Maven 配置
└── README.md
```

---

## 🔬 核心功能 | Core Features

### 大文件分片上传 | Chunked Upload

```
前端 (JavaScript):
  1. 用户选择文件
  2. 计算文件 MD5 (SparkMD5)
  3. 检查秒传: 发送 MD5 到后端, 如已存在则秒传
  4. 文件分片: 将文件切成固定大小的块 (如 5MB)
  5. 并发上传: 同时上传多个分片
  6. 断点续传: 记录已上传分片, 中断后从断点继续
  7. 合并请求: 所有分片上传完成后, 请求后端合并

后端 (SpringMVC):
  1. 接收分片: 保存分片到临时目录或 HDFS
  2. 记录状态: MySQL 记录每个分片的上传状态
  3. 合并文件: 所有分片到齐后, 合并为完整文件写入 HDFS
  4. 清理临时: 合并完成后清理临时分片
```

### 秒传实现 | Instant Upload

```
秒传原理:
  1. 上传前计算文件 MD5
  2. 查询数据库中是否存在相同 MD5 的文件
  3. 如存在, 直接创建文件引用 (不重复存储)
  4. 如不存在, 正常上传

数据库设计:
  file表: id, user_id, filename, md5, size, hdfs_path, upload_time
  同一 MD5 可能被多个用户引用 (软链接)
  
优势:
  - 节省存储空间 (去重)
  - 节省上传带宽 (秒传)
  - 提升用户体验 (大文件瞬间完成)
```

### HDFS 文件操作 | HDFS File Operations

```java
// HDFS 工具类核心方法
public class HdfsUtil {
    // 上传文件到 HDFS
    public static void upload(String localPath, String hdfsPath) throws IOException {
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(hdfsPath), conf);
        fs.copyFromLocalFile(new Path(localPath), new Path(hdfsPath));
        fs.close();
    }
    
    // 从 HDFS 下载文件
    public static void download(String hdfsPath, String localPath) throws IOException {
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(hdfsPath), conf);
        fs.copyToLocalFile(new Path(hdfsPath), new Path(localPath));
        fs.close();
    }
    
    // 合并分片文件
    public static void mergeFiles(List<String> chunkPaths, String targetPath) throws IOException {
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(targetPath), conf);
        FSDataOutputStream out = fs.create(new Path(targetPath));
        for (String chunkPath : chunkPaths) {
            FSDataInputStream in = fs.open(new Path(chunkPath));
            IOUtils.copyBytes(in, out, 4096, false);
            in.close();
        }
        out.close();
        fs.close();
    }
    
    // 删除文件
    public static void delete(String hdfsPath) throws IOException {
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(hdfsPath), conf);
        fs.delete(new Path(hdfsPath), true);
        fs.close();
    }
}
```

### 文件分享 | File Sharing

```
分享机制:
  1. 用户选择文件, 生成分享链接
  2. 可选: 设置提取码、有效期
  3. 生成唯一分享 ID (UUID)
  4. 访问分享链接 → 输入提取码 → 下载/保存到自己云盘

数据库设计:
  share表: id, file_id, user_id, share_code, expire_time, create_time, view_count, download_count

安全控制:
  - 提取码验证 (可选)
  - 有效期检查 (过期自动失效)
  - 访问次数统计
  - 分享者可随时取消分享
```

---

## 📊 数据库设计 | Database Design

### 用户表 (user)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键 |
| username | VARCHAR(50) | 用户名 (唯一) |
| password | VARCHAR(100) | 密码 (MD5 加密) |
| email | VARCHAR(100) | 邮箱 |
| total_storage | BIGINT | 总存储容量 (字节) |
| used_storage | BIGINT | 已用存储容量 (字节) |
| create_time | DATETIME | 注册时间 |

### 文件表 (file)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键 |
| user_id | INT | 所属用户 |
| filename | VARCHAR(255) | 文件名 |
| md5 | VARCHAR(32) | 文件 MD5 (用于秒传/去重) |
| size | BIGINT | 文件大小 (字节) |
| file_type | VARCHAR(50) | 文件类型 (扩展名) |
| hdfs_path | VARCHAR(500) | HDFS 存储路径 |
| parent_id | INT | 父目录 ID (0 为根目录) |
| is_dir | TINYINT | 是否为目录 |
| create_time | DATETIME | 上传时间 |

### 分片表 (chunk)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键 |
| file_md5 | VARCHAR(32) | 文件 MD5 |
| chunk_index | INT | 分片序号 |
| chunk_size | INT | 分片大小 |
| hdfs_path | VARCHAR(500) | 分片 HDFS 路径 |
| upload_time | DATETIME | 上传时间 |

### 分享表 (share)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键 |
| file_id | INT | 分享的文件 |
| user_id | INT | 分享者 |
| share_code | VARCHAR(10) | 提取码 (可选) |
| expire_time | DATETIME | 过期时间 (NULL 为永久) |
| view_count | INT | 浏览次数 |
| download_count | INT | 下载次数 |
| create_time | DATETIME | 创建时间 |

---

## 🎯 应用场景 | Use Cases

- ☁️ **企业云盘**：企业内部文件存储和共享
- 🎓 **教育云盘**：学校教学资料存储和分发
- 🏥 **医疗云盘**：医学影像和病历存储
- 📹 **视频存储**：大视频文件的分布式存储
- 💾 **备份系统**：数据备份和归档
- 🎓 **大数据教学**：Hadoop + Java Web 综合教学项目

---

## 📚 参考文献 | References

- Shvachko, K., et al. "The Hadoop distributed file system." MSST 2010.
- Johnson, R., et al. "Spring Framework Documentation." 2023.
- MyBatis Team. "MyBatis 3 User Guide." 2023.
- 李刚. "轻量级 Java EE 企业应用实战." 电子工业出版社.

---

## 📄 License

MIT License — 自由使用、修改和分发。

---

> 💡 **HDFS + SSM 全栈云存储系统，Star ⭐ 支持开源大数据！**
