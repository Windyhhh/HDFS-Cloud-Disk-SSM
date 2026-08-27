<div align="center">

# ☁️ HDFS-Cloud-Disk-SSM

### A distributed cloud disk on HDFS, built with SSM.

Spring + SpringMVC + MyBatis (SSM) cloud disk on HDFS — user management, file upload/download, JSP views.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-8+-007396?logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Spring](https://img.shields.io/badge/SSM-Spring_%2B_MVC_%2B_MyBatis-6DB33F?logo=spring&logoColor=white)](https://spring.io/)
[![HDFS](https://img.shields.io/badge/HDFS-3-66CCFF?logo=apachehadoop&logoColor=black)](https://hadoop.apache.org/)

</div>

---

**HDFS-Cloud-Disk-SSM** is a distributed cloud disk backed by **HDFS**, built with the **SSM** stack (Spring + SpringMVC + MyBatis). It provides user management and file upload/download through JSP views.

> [!NOTE]
> 中文项目：SSM（Spring + SpringMVC + MyBatis）+ HDFS 分布式云盘系统——用户管理、文件上传下载、JSP 看板。

---

## Quickstart

```bash
git clone https://github.com/Windyhhh/HDFS-Cloud-Disk-SSM.git
cd HDFS-Cloud-Disk-SSM

# Configure HDFS & DB in resources
#   resources/hdfs.properties, db.properties, init.sql

mvn clean package
# Deploy the WAR to Tomcat
```

See `快速启动指南.md` for details.

---

## Features

- **HDFS storage** — distributed file backend via `HdfsService`.
- **SSM stack** — controller / service / mapper layered architecture.
- **User & file flows** — auth, dashboard, upload / download.

---

## Project Structure

```
HDFS-Cloud-Disk-SSM/
├── main/java/com/hdfs/cloud/
│   ├── controller/       # FileController, UserController
│   ├── service/          # FileService, HdfsService, UserService
│   ├── mapper/           # FileInfoMapper, UserMapper
│   └── entity/           # FileInfo, User
├── main/resources/       # spring-mvc.xml, mybatis-config.xml, hdfs.properties, init.sql
├── main/webapp/          # dashboard.jsp, index.jsp
└── pom.xml
```

---

## License

MIT — free to use, modify and distribute.
