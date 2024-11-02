<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Phone Lookup - AUCA Library Management</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #3498db;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-weight: bold;
            color: #555;
        }

        input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1em;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        button {
            padding: 10px;
            border: none;
            border-radius: 4px;
            background-color: #3498db;
            color: #fff;
            font-weight: bold;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .result, .error {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
            font-size: 1em;
            text-align: center;
        }

        .result {
            background-color: #eafaf1;
            color: #2c7a3a;
            border: 1px solid #2c7a3a;
        }

        .error {
            background-color: #fdecea;
            color: #e74c3c;
            border: 1px solid #e74c3c;
        }

        .info-text {
            font-size: 0.85em;
            color: #777;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Phone Lookup</h2>

    <!-- Phone Lookup Form -->
    <form action="PhoneLookupServlet" method="get">
        <label for="phoneNumber">Enter Phone Number:</label>
        <input type="text" id="phoneNumber" name="phoneNumber" required pattern="[0-9]{10}" placeholder="e.g., 0781234567" 
               title="Please enter a 10-digit phone number, e.g., 0781234567">
        <button type="submit">Lookup</button>
    </form>

    <div class="info-text">Enter a valid 10-digit phone number to look up the province associated with it.</div>

    <!-- Display Lookup Result -->
    <%
        String province = request.getParameter("province");
        String error = request.getParameter("error");
        if (province != null) {
    %>
        <div class="result">
            <p>Province: <strong><%= province %></strong></p>
        </div>
    <%
        } else if (error != null) {
    %>
        <div class="error">
            <p><%= error %></p>
        </div>
    <%
        }
    %>
</div>
</body>
</html>
