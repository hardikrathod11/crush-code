<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
       /* General Styles */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f5f9fc;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    color: #333;
}

/* Container Styles */
.login-container {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    padding: 40px;
    width: 100%;
    max-width: 400px;
    text-align: center;
}

.login-container h1 {
    color: #2a5db0;
    margin-bottom: 30px;
    font-weight: 600;
}

/* Form Styles */
.form-group {
    margin-bottom: 20px;
    text-align: left;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #555;
}

.form-group input {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
    transition: border-color 0.3s;
    box-sizing: border-box;
}

.form-group input:focus {
    border-color: #2a5db0;
    outline: none;
    box-shadow: 0 0 0 2px rgba(42, 93, 176, 0.2);
}

/* Button Styles */
button {
    background-color: #2a5db0;
    color: white;
    border: none;
    padding: 12px 20px;
    border-radius: 4px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    width: 100%;
    transition: background-color 0.3s;
    margin-top: 10px;
}

button:hover {
    background-color: #1e4a8e;
}

/* Link Styles */
p {
    margin-top: 20px;
    color: #666;
}

a {
    color: #2a5db0;
    text-decoration: none;
    font-weight: 500;
}

a:hover {
    text-decoration: underline;
}

/* Responsive Design */
@media (max-width: 480px) {
    .login-container {
        padding: 30px 20px;
        margin: 0 15px;
    }
}
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Create Account</h1>
        <form action="SignupServlet" method="post">
            <div class="form-group">
                <label for="name">Full Name:</label>
                <input type="text" id="name" name="name" required placeholder="Enter your full name">
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required placeholder="Enter your email">
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required placeholder="Create a password">
            </div>
            <button type="submit">Sign Up</button>
            <p>Already have an account? <a href="login.jsp">Login</a></p>
        </form>
    </div>
</body>
</html>