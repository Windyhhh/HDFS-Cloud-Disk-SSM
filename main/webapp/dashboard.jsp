<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("/hdfs-cloud-disk/");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能云存储 - 仪表板</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
        }
        .header {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            font-size: 26px;
            font-weight: 700;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .logout-btn {
            background: rgba(255, 255, 255, 0.25);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.5);
            padding: 9px 18px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
        }
        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.35);
        }
        .container {
            display: flex;
            height: calc(100vh - 70px);
        }
        .sidebar {
            width: 260px;
            background: white;
            border-right: 1px solid #e0e0e0;
            padding: 25px;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
        }
        .sidebar h3 {
            color: #11998e;
            margin-bottom: 18px;
            font-size: 16px;
            font-weight: 700;
        }
        .sidebar ul {
            list-style: none;
        }
        .sidebar li {
            margin-bottom: 12px;
        }
        .sidebar a {
            color: #38ef7d;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: block;
            padding: 8px 12px;
            border-radius: 6px;
        }
        .sidebar a:hover {
            background: #f0f4f8;
            color: #11998e;
        }
        .main-content {
            flex: 1;
            padding: 25px;
            overflow-y: auto;
        }
        .breadcrumb {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        .breadcrumb a {
            color: #11998e;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .toolbar {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        .btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(17, 153, 142, 0.3);
        }
        .file-list {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        .file-item {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s;
        }
        .file-item:hover {
            background: #f9fafb;
        }
        .file-name {
            color: #333;
            font-weight: 600;
            flex: 1;
        }
        .file-size {
            color: #999;
            font-size: 13px;
            margin-right: 20px;
        }
        .file-actions {
            display: flex;
            gap: 8px;
        }
        .action-btn {
            padding: 6px 12px;
            background: #f0f4f8;
            color: #11998e;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .action-btn:hover {
            background: #11998e;
            color: white;
        }
        .message {
            padding: 14px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            display: none;
            font-weight: 500;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>💾 智能云存储</h1>
        <div class="user-info">
            <span id="username" style="font-weight: 600;"></span>
            <a href="/hdfs-cloud-disk/user/logout" class="logout-btn">登出</a>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <h3 style="color: #11998e; margin-bottom: 15px;">📂 导航</h3>
            <ul style="list-style: none; margin-top: 20px;">
                <li><a onclick="navigateTo('/')" style="color: #38ef7d; cursor: pointer; text-decoration: none; font-weight: 600;">📁 我的文件</a></li>
                <li style="margin-top: 15px;"><a onclick="navigateTo('/trash')" style="color: #38ef7d; cursor: pointer; text-decoration: none; font-weight: 600;">🗑️ 回收站</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div id="message" class="message"></div>

            <div class="breadcrumb">
                <span>📍 位置:</span>
                <a onclick="navigateTo('/')">根目录</a>
                <span id="breadcrumbPath"></span>
            </div>

            <div class="toolbar">
                <button class="btn" onclick="showUploadDialog()">📤 上传文件</button>
                <button class="btn" onclick="showCreateDirDialog()">📁 新建文件夹</button>
                <button class="btn" onclick="refreshFiles()">🔄 刷新</button>
            </div>

            <div class="file-list" id="fileList">
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <p>暂无文件。开始上传文件或创建文件夹。</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Upload Dialog -->
    <div id="uploadDialog" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.5); z-index:1000; display:flex; justify-content:center; align-items:center;">
        <div style="background:white; padding:30px; border-radius:10px; width:90%; max-width:400px;">
            <h2 style="margin-bottom:20px; color:#11998e;">上传文件</h2>
            <input type="file" id="fileInput" style="width:100%; padding:10px; margin-bottom:15px; border:1px solid #ddd; border-radius:5px;">
            <div style="display:flex; gap:10px;">
                <button onclick="uploadFile()" class="btn" style="flex:1;">上传</button>
                <button onclick="closeUploadDialog()" style="flex:1; padding:10px 20px; background:#ccc; color:#333; border:none; border-radius:5px; cursor:pointer;">取消</button>
            </div>
        </div>
    </div>

    <!-- Create Directory Dialog -->
    <div id="createDirDialog" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.5); z-index:1000; display:flex; justify-content:center; align-items:center;">
        <div style="background:white; padding:30px; border-radius:10px; width:90%; max-width:400px;">
            <h2 style="margin-bottom:20px; color:#11998e;">创建文件夹</h2>
            <input type="text" id="dirNameInput" placeholder="文件夹名称" style="width:100%; padding:10px; margin-bottom:15px; border:1px solid #ddd; border-radius:5px;">
            <div style="display:flex; gap:10px;">
                <button onclick="createDirectory()" class="btn" style="flex:1;">创建</button>
                <button onclick="closeCreateDirDialog()" style="flex:1; padding:10px 20px; background:#ccc; color:#333; border:none; border-radius:5px; cursor:pointer;">取消</button>
            </div>
        </div>
    </div>

    <script>
        let currentPath = '/';
        let userId = null;

        window.onload = function() {
            userId = '<%= session.getAttribute("userId") %>';
            document.getElementById('username').textContent = '<%= session.getAttribute("username") %>';
            loadFiles(currentPath);
        };

        function loadFiles(path) {
            currentPath = path;
            updateBreadcrumb();

            fetch('/hdfs-cloud-disk/file/list?parentPath=' + encodeURIComponent(path))
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayFiles(data.data);
                    } else {
                        showMessage(data.message, 'error');
                    }
                })
                .catch(error => showMessage('加载文件出错: ' + error, 'error'));
        }

        function displayFiles(files) {
            const fileList = document.getElementById('fileList');
            if (!files || files.length === 0) {
                fileList.innerHTML = '<div class="empty-state"><div class="empty-state-icon">📭</div><p>此文件夹中没有文件</p></div>';
                return;
            }

            let html = '';
            files.forEach(file => {
                const icon = file.isDirectory ? '📁' : '📄';
                const size = file.isDirectory ? '-' : formatFileSize(file.fileSize);
                let actions = '<button class="action-btn" onclick="renameFile(' + file.id + ')">重命名</button>' +
                    '<button class="action-btn" onclick="deleteFile(' + file.id + ')">删除</button>';
                if (!file.isDirectory) {
                    actions = '<button class="action-btn" onclick="downloadFile(' + file.id + ')">下载</button>' + actions;
                }
                html += '<div class="file-item">' +
                    '<span class="file-name" onclick="' + (file.isDirectory ? 'navigateTo(\'' + file.filePath + '\')' : '') + '" style="' + (file.isDirectory ? 'cursor:pointer; color:#11998e;' : '') + '">' + icon + ' ' + file.fileName + '</span>' +
                    '<span class="file-size">' + size + '</span>' +
                    '<div class="file-actions">' +
                    actions +
                    '</div>' +
                    '</div>';
            });
            fileList.innerHTML = html;
        }

        function navigateTo(path) {
            loadFiles(path);
        }

        function updateBreadcrumb() {
            const parts = currentPath.split('/').filter(p => p);
            let breadcrumb = '';
            let path = '';
            parts.forEach(part => {
                path += '/' + part;
                breadcrumb += ' / <a onclick="navigateTo(\'' + path + '\')">' + part + '</a>';
            });
            document.getElementById('breadcrumbPath').innerHTML = breadcrumb;
        }

        function showUploadDialog() {
            document.getElementById('uploadDialog').style.display = 'flex';
        }

        function closeUploadDialog() {
            document.getElementById('uploadDialog').style.display = 'none';
        }

        function uploadFile() {
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];
            if (!file) {
                showMessage('请选择一个文件', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('file', file);
            formData.append('parentPath', currentPath);

            fetch('/hdfs-cloud-disk/file/upload', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('文件上传成功', 'success');
                    closeUploadDialog();
                    loadFiles(currentPath);
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => showMessage('上传出错: ' + error, 'error'));
        }

        function showCreateDirDialog() {
            document.getElementById('createDirDialog').style.display = 'flex';
        }

        function closeCreateDirDialog() {
            document.getElementById('createDirDialog').style.display = 'none';
        }

        function createDirectory() {
            const dirName = document.getElementById('dirNameInput').value;
            if (!dirName) {
                showMessage('请输入文件夹名称', 'error');
                return;
            }

            fetch('/hdfs-cloud-disk/file/mkdir', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'dirName=' + encodeURIComponent(dirName) + '&parentPath=' + encodeURIComponent(currentPath)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('文件夹创建成功', 'success');
                    closeCreateDirDialog();
                    loadFiles(currentPath);
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => showMessage('错误: ' + error, 'error'));
        }

        function deleteFile(fileId) {
            if (confirm('确定要删除此文件吗？')) {
                fetch('/hdfs-cloud-disk/file/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'fileId=' + fileId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showMessage('文件删除成功', 'success');
                        loadFiles(currentPath);
                    } else {
                        showMessage(data.message, 'error');
                    }
                })
                .catch(error => showMessage('错误: ' + error, 'error'));
            }
        }

        function renameFile(fileId) {
            const newName = prompt('输入新名称:');
            if (newName) {
                fetch('/hdfs-cloud-disk/file/rename', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'fileId=' + fileId + '&newName=' + encodeURIComponent(newName)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showMessage('文件重命名成功', 'success');
                        loadFiles(currentPath);
                    } else {
                        showMessage(data.message, 'error');
                    }
                })
                .catch(error => showMessage('错误: ' + error, 'error'));
            }
        }

        function downloadFile(fileId) {
            window.location.href = '/hdfs-cloud-disk/file/download?fileId=' + fileId;
        }

        function refreshFiles() {
            loadFiles(currentPath);
        }

        function showMessage(message, type) {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = message;
            messageDiv.className = 'message ' + type;
            messageDiv.style.display = 'block';
            setTimeout(() => {
                messageDiv.style.display = 'none';
            }, 3000);
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 B';
            const k = 1024;
            const sizes = ['B', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        }
    </script>
</body>
</html>

