<div align="center">

# ☁️ HDFS-Cloud-Disk-SSM

### A cloud-disk system on SSM + HDFS distributed storage.

User management, file upload/download, file management and permission control with multi-user isolation.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-8-007396?logo=java&logoColor=white)](https://www.java.com/)
[![SSM](https://img.shields.io/badge/SSM-Spring%20MVC-6DB33F?logo=spring&logoColor=white)](https://spring.io/)
[![HDFS](https://img.shields.io/badge/HDFS-3-66CCFF?logo=apachehadoop&logoColor=white)](https://hadoop.apache.org/)

</div>

---

**HDFS-Cloud-Disk-SSM** is a cloud-disk (network drive) system built on the **SSM** framework (Spring + SpringMVC + MyBatis) and **HDFS** distributed storage. It provides user management, file upload / download, file management and permission control with multi-user data isolation.

> [!NOTE]
> 中文项目：基于 SSM 框架 + HDFS 分布式存储的云盘系统——用户管理、文件上传下载、权限控制、多用户数据隔离。

---

## Features

- **SSM enterprise stack** — clean, maintainable, extensible architecture.
- **HDFS storage** — high reliability, scalability and throughput.
- **Full file operations** — upload / download / manage / share.
- **Permission control** — role-based access + multi-user isolation.
- **Full-stack** — ready to deploy.

---

## Quickstart

```bash
git clone https://github.com/Windyhhh/HDFS-Cloud-Disk-SSM.git
cd HDFS-Cloud-Disk-SSM

# configure HDFS + MySQL in application config
mvn clean package
# deploy the WAR to Tomcat
```

---

## Project Structure

```
HDFS-Cloud-Disk-SSM/
├── src/main/java/          # controllers, services, mappers
├── src/main/resources/     # mybatis, spring config
├── src/main/webapp/        # frontend
└── pom.xml
```

---

## License

MIT — free to use, modify and distribute.
