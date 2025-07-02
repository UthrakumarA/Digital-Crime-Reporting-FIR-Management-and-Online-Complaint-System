<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
    <style>
      body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .otp-container {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:disabled {
            background-color: #aaa;
            cursor: not-allowed;
        }

        .error-message {
            margin-top: 15px;
            color: red;
        }

        .timer {
            margin-top: 10px;
            font-weight: bold;
            color: #555;
        }

        #resendBtn {
            display: none;
            margin-top: 15px;
            background-color: #28a745;
        }

        #resendBtn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="otp-container">
        <h2>Enter OTP</h2>
        <form action="OTPVerifyServlet" method="post">
            <input type="text" name="otp" id="otpInput" required />
            <button type="submit" id="submitBtn">Verify</button>
        </form>

        <!-- Timer display -->
        <div class="timer" id="timerDisplay">OTP expires in: 00:60</div>

        <button type="button" id="resendBtn" onclick="resendOTP()">Resend OTP</button>
    </div>

    <script>
        let timeLeft = 60; // in seconds

        let timer = setInterval(function () {
            if (timeLeft <= 0) {
                clearInterval(timer);
                document.getElementById("timerDisplay").innerHTML = "OTP Expired!";
                document.getElementById("otpInput").disabled = true;
                document.getElementById("submitBtn").disabled = true;
                document.getElementById("resendBtn").style.display = "inline-block";
            } else {
                let display = "OTP expires in: 00:" + (timeLeft < 10 ? "0" : "") + timeLeft;
                document.getElementById("timerDisplay").innerHTML = display;
            }
            timeLeft -= 1;
        }, 1000);

        function resendOTP() {
            // You can send a request to regenerate OTP using AJAX or redirect
            window.location.href = "ResendOTPServlet"; // Update this with your actual servlet
        }
    </script>
</body>
</html>