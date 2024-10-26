<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to AUCA Library Management System</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        /* Additional styles specific to index.jsp */
        .hero {
            background: url('https://source.unsplash.com/1600x900/?library,books') no-repeat center center/cover;
            height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
            text-align: center;
            padding: 0 20px;
        }
        .hero h1 {
            font-size: 3em;
            margin-bottom: 10px;
        }
        .hero p {
            font-size: 1.5em;
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.2em;
            text-decoration: none;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .features {
            display: flex;
            justify-content: space-around;
            margin-top: 40px;
            padding: 20px;
            text-align: center;
        }
        .feature-card {
            width: 30%;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
        }
        .feature-card h3 {
            color: #4CAF50;
            margin-bottom: 15px;
        }
        .footer {
            text-align: center;
            background-color: #333;
            color: white;
            padding: 15px 0;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<div class="hero">
    <div>
        <h1>Welcome to the AUCA Library Management System</h1>
        <p>Your portal to explore, manage, and learn with ease</p>
        <a href="login.jsp" class="btn-primary">Get Started</a>
    </div>
</div>

<div class="container">
    <section class="features">
        <div class="feature-card">
            <h3>Browse Books</h3>
            <p>Discover our extensive collection of books available for borrowing, categorized for easy access.</p>
            <button onclick="navigateTo('jsp/browseBooks.jsp')" class="btn-primary">Browse Now</button>
        </div>

        <div class="feature-card">
            <h3>Membership Benefits</h3>
            <p>Choose from our Gold, Silver, or Striver memberships and enjoy special borrowing privileges.</p>
            <button onclick="navigateTo('login.jsp')" class="btn-primary">Join Us</button>
        </div>

        <div class="feature-card">
            <h3>Librarian Dashboard</h3>
            <p>Manage books, approve memberships, and organize the library efficiently with dedicated tools.</p>
            <button onclick="navigateTo('jsp/librarianInterface.jsp')" class="btn-primary">Manage Library</button>
        </div>
    </section>
</div>

<div class="footer">
    <p>&copy; 2024 AUCA Library Management System | <a href="login.jsp" style="color: #4CAF50;">Login</a> | <a href="contact.jsp" style="color: #4CAF50;">Contact Us</a></p>
</div>

<script src="js/scripts.js"></script>
</body>
</html>
