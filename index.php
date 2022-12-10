<html>
<head>
	<title>Cisco Panel By Hamed Ap</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<link rel="stylesheet" href="/style.css" type="text/css">
</head>

<body style="background-color:rgba(0,0,0,1.00);color:white">
<h1 style="font-size:25px;text-align:center;color:yellow;">Cisco Panel By Hamed Ap</h1>
<div class="center">
<hr>
<form method="POST" action="/">
<input name="username" type="text" placeholder="Username">
<br><input name="password" type="text" placeholder="Password">
<br><input type="submit" name="useradd" value="Add User" style="background-color: green;">
</form>
<hr>
<form method="POST" action="/">
<input name="delusername" type="text" placeholder="Username">
<input type="submit" name="deluser" value="Remove User" style="background-color:red;">
</form>
<hr>
<h1 style="font-size:25px;text-align:center;color:yellow;">User List : </h1>


<table style="width:100%">

<?php 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);



if (isset($_POST['useradd'])){
exec('bash adduser.sh '.$_POST['username']." ". $_POST['password'], $out);
echo "user added ! ";
}

if (isset($_POST['deluser'])){

$lines = file("/etc/ocserv/passwd", FILE_IGNORE_NEW_LINES);
foreach ( $lines as $line) {
$variable = substr($line, 0, strpos($line, ":"));

if ( $variable == $_POST['delusername']) {
}else{
$newline[] = $line; 

}

}
file_put_contents('/etc/ocserv/passwd', implode(PHP_EOL, $newline));



echo " removed ";
}

$lines = file("/etc/ocserv/passwd", FILE_IGNORE_NEW_LINES);
foreach ( $lines as $line) {
$variable = substr($line, 0, strpos($line, ":"));
echo "<tr>
    <th>".$variable."</th>
  </tr>";
}
?>
</table>
</div>
</body></html>
