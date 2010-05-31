<head>
<meta name='layout' content='main' />
<title>Login</title>
</head>

<body>
	<div id='login'>
		<div class='inner'>
			<g:if test='${flash.message}'>
			<div class='login_message'>${flash.message}</div>
			</g:if>
			<div class='fheader'>Please login..</div>
			<form action='${postUrl}' method='POST' id='loginForm' class='cssform'>
				<p>
					<label for='j_username'>Username</label>
					<input style='width:140px;' type='text' class='text_' name='j_username' id='j_username' value='${request.remoteUser}' />
				</p>
				<p>
					<label for='j_password'>Password</label>
					<input type='password' class='text_' name='j_password' id='j_password' />
				</p>
				<p>
					<label for='remember_me'>Remember me</label>
					<input type='checkbox' class='chk' name='_spring_security_remember_me' id='remember_me'
					<g:if test='${hasCookie}'>checked='checked'</g:if> />
				</p>
				<p>
					<input type='submit' value='Login' />
				</p>
			</form>
		</div>
	</div>
<script type='text/javascript'>
<!--
(function(){
	document.forms['loginForm'].elements['j_username'].focus();
})();
// -->
</script>
</body>
