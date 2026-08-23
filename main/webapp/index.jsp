<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能云存储 - 登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            padding: 45px;
        }
        h1 {
            text-align: center;
            color: #11998e;
            margin-bottom: 35px;
            font-size: 32px;
            font-weight: 700;
        }
        .form-group {
            margin-bottom: 22px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"],
        input[type="tel"] {
            width: 100%;
            padding: 13px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus {
            outline: none;
            border-color: #11998e;
            box-shadow: 0 0 0 3px rgba(17, 153, 142, 0.1);
        }
        button {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
        }
        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(17, 153, 142, 0.3);
        }
        .toggle-link {
            text-align: center;
            margin-top: 22px;
            color: #666;
            font-size: 14px;
        }
        .toggle-link a {
            color: #11998e;
            text-decoration: none;
            cursor: pointer;
            font-weight: 700;
        }
        .toggle-link a:hover {
            text-decoration: underline;
        }
        .form-section {
            display: none;
        }
        .form-section.active {
            display: block;
        }
        .message {
            padding: 14px;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>💾 智能云存储</h1>

        <div id="message" class="message"></div>

        <!-- Login Form -->
        <div id="loginForm" class="form-section active">
            <form onsubmit="handleLogin(event)">
                <div class="form-group">
                    <label for="loginUsername">用户名</label>
                    <input type="text" id="loginUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="loginPassword">密码</label>
                    <input type="password" id="loginPassword" name="password" required>
                </div>
                <button type="submit">登录</button>
            </form>
            <div class="toggle-link">
                没有账户？ <a onclick="toggleForms()">创建账户</a>
            </div>
        </div>

        <!-- Register Form -->
        <div id="registerForm" class="form-section">
            <form onsubmit="handleRegister(event)">
                <div class="form-group">
                    <label for="regUsername">用户名</label>
                    <input type="text" id="regUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="regPassword">密码</label>
                    <input type="password" id="regPassword" name="password" required>
                </div>
                <div class="form-group">
                    <label for="regEmail">邮箱</label>
                    <input type="email" id="regEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="regPhone">电话</label>
                    <input type="tel" id="regPhone" name="phone">
                </div>
                <button type="submit">创建账户</button>
            </form>
            <div class="toggle-link">
                已有账户？ <a onclick="toggleForms()">登录</a>
            </div>
        </div>
    </div>

    <script>
        function toggleForms() {
            document.getElementById('loginForm').classList.toggle('active');
            document.getElementById('registerForm').classList.toggle('active');
            document.getElementById('message').style.display = 'none';
        }

        function showMessage(message, type) {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = message;
            messageDiv.className = 'message ' + type;
            messageDiv.style.display = 'block';
        }

        function handleLogin(event) {
            event.preventDefault();
            const username = document.getElementById('loginUsername').value;
            const password = document.getElementById('loginPassword').value;

            fetch('/hdfs-cloud-disk/user/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('登录成功！', 'success');
                    setTimeout(() => {
                        window.location.href = '/hdfs-cloud-disk/dashboard.jsp';
                    }, 1000);
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => {
                showMessage('错误: ' + error, 'error');
            });
        }

        function handleRegister(event) {
            event.preventDefault();
            const username = document.getElementById('regUsername').value;
            const password = document.getElementById('regPassword').value;
            const email = document.getElementById('regEmail').value;
            const phone = document.getElementById('regPhone').value;

            fetch('/hdfs-cloud-disk/user/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password) + 
                      '&email=' + encodeURIComponent(email) + '&phone=' + encodeURIComponent(phone)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('注册成功！请登录。', 'success');
                    setTimeout(() => {
                        toggleForms();
                        document.getElementById('loginUsername').value = username;
                        document.getElementById('loginPassword').value = password;
                    }, 1000);
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => {
                showMessage('错误: ' + error, 'error');
            });
        }
    </script>
</body>
</html>

