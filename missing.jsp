<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>MISSING PERSON</title>

    <style type="text/css">
        /* Embedded from default.css */
        body {
           font-family: Arial, sans-serif;
           margin: 0;
           padding: 0;
           background: url('background_images/image4.png') no-repeat center center fixed;
           background-size: cover;
        }

        #header {
           background: rgba(0, 0, 0, 0.6); /* semi-transparent background */
           backdrop-filter: blur(8px);  
            color: white;
            padding: 20px 0;
            text-align: center;
            border-bottom: 4px solid #2980b9;
        }

        #header h1 {
            margin: 0;
            font-size: 36px;
        }

        #header h2 {
            margin: 5px 0 0;
            font-weight: normal;
            font-size: 20px;
            color: #ecf0f1;
        }

        #content {
            padding: 30px;
        }

        #colOne {
            background: whitesmoke;
            backdrop-filter: blur(8px);  
            max-width: 500px;
            margin: 0 auto;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
        }

        td {
            padding: 10px;
            vertical-align: top;
        }

        input[type="text"], input[type="date"] {
            width: 95%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #3498db;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        .style4 {
            font-weight: bold;
            font-size: 16px;
            text-align: right;
        }
    </style>
</head>
<body>

<div id="header">
    <div id="logo">
        <center>
            <h1>MISSING PEOPLE</h1>
            <h2>Registry</h2>
        </center>
    </div>
</div>

<div id="content">
    <div id="colOne">
        <form id="form1" name="form1" method="post" action="Missing">
            <table border="0">
                <tr>
                    <td class="style4"><div align="right">NAME</div></td>
                    <td><input type="text" name="name" id="dis" /></td>
                </tr>
                <tr>
                    <td class="style4"><div align="right">MOBILE NO:</div></td>
                    <td><input type="text" name="mobile" id="da" /></td>
                </tr>
                <tr>
                    <td class="style4"><div align="right">ADDRESS</div></td>
                    <td><input type="text" name="addd" id="ti" /></td>
                </tr>
                <tr>
                    <td class="style4"><div align="right">PIN CODE</div></td>
                    <td><input type="text" name="pin" id="toi" /></td>
                </tr>
                <tr>
                    <td class="style4"><div align="right">DATE</div></td>
                    <td><input type="date" name="da" id="place" /></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" name="button" id="button" value="Submit" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

</body>
</html>
