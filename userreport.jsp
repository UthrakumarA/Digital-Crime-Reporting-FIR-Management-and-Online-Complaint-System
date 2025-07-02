<%-- 
    Document   : Erasure
    Created on : 4 Mar, 2016, 2:34:21 PM
    Author     : Java
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<html>

	<head>
		<meta charset="utf-8"/>
		<title>Crime Report Submission page</title>

		<meta name="viewport" content="width=device-width, initial-scale=1" />

		<link href="http://fonts.googleapis.com/css?family=Raleway:400,700" rel="stylesheet" />
		<link href="assets/css/style.css" rel="stylesheet" />

	</head>

	<body>

		<a class="back"></a>

		<div id="stage">

			<div id="step1">
				<div class="content">
					<h1>What do you want to do?</h1>
					<a class="button encrypt green">Upload File</a>
					<a class="button decrypt magenta">Download file</a>
				</div>
			</div>

			<div id="step2">

				<div class="content if-encrypt">
					<h1>Choose which file </h1>
					<h2>An encrypted copy of the file will be generated. No data is sent to our server.</h2>
					<a class="button browse blue">Browse</a>

					<input type="file" id="encrypt-input" />
				</div>

				<div class="content if-decrypt">
					<h1>Choose which file </h1>
					<h2>Only files encrypted by this tool are accepted.</h2>
					<a class="button browse blue">Browse</a>

					<input type="file" id="decrypt-input" />
				</div>

			</div>

			<div id="step3">

				<div class="content if-encrypt">
					<h1>Enter a 16 digit number</h1>
					

					<input type="password" />
					<a class="button process red">Upload!</a>
				</div>

				<div class="content if-decrypt">
					<h1>Enter the 16 digit number</h1>
					

					<input type="password" />
					<a class="button process red">Download!</a>
				</div>

			</div>

			<div id="step4">

				<div class="content">
					<h1>Your file is ready!</h1>
					<a class="button download green">Download</a>
				</div>

			</div>
		</div>

		<footer>
           
            <div id="tzine-actions"></div>
            <span class="close"></span>
        </footer>

	</body>

	<!-- Include the AES algorithm of the crypto library -->
	<script src="assets/js/aes.js"></script>

	<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="assets/js/script.js"></script>

</html>
