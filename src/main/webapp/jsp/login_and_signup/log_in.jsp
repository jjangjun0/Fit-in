<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    	String result = request.getParameter("result");
    	String userId = request.getParameter("userId");
   		if ("bye".equals(result)) { %>	
   		  <script>
   			alert(userId + "아이디에 대한 탈퇴가 완료되었습니다.");
   		  </script>
     <% } %>
   
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
	body{margin:0;font-family:'Pretendard','Nanum Gothic',sans-serif;
	background:linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
  	min-height:100vh;display:flex;align-items:center;justify-content:center}
	.card{width:480px;background:#fff;border-radius:18px;box-shadow:0 12px 24px rgba(0,0,0,.18);padding:28px}
	fieldset {
		width: 400px;
		border: 1px solid;
		border-radius: 8px;
		margin: 20px auto; /* 가로 가운데 배치 */
		padding: 20px;
	}
	
	/* 입력창 공통 스타일 */
	input[type="text"],
	input[type="password"] {
		display: block;
  		width: 100%;
		height: 40px;
		line-height: 40px; /* 글자 세로로 가운데 배치 */
		font-size: 15px;
		border: 1px solid #ccc;
		padding: 0 8px;
		box-sizing: border-box;
	}
	#user_id {
		border-bottom: none;
		border-radius: 4px 4px 0 0;
	}
	#user_pw {
		margin-top: -1px;
		margin-bottom: 14px;
		border-radius: 0 0 4px 4px;
	}
	
	#stay_login { margin-bottom: 14px;}
	label[for="stay_login"] {font-size: 14px;}
	.login-btn {width: 100%;}
	.links{margin-top:12px;text-align:center}
	.links a{color:#2980b9;text-decoration:none}
	.input {text-align: center;}
</style>
</head>
<body>
	<div class="card">
		<h2 style="text-align: center;">당신의 Fit을 찾아주는</h2>
		<!-- 웹 이미지 -->
		<div style="text-align: center;">
			<img src="../../images/Fit_in_img.png" width="400" height="300" title="cat1" alt="사진없음" style="text-align: center;"/>
		</div>

		<!-- 사용자 아이디, 비밀번호 입력 받기 -->
		<form action="log_in_check.jsp" method="post">
			<fieldset class="input">
				<div>
					<input type="text" id="user_id" name="id" placeholder="  아이디" maxlength="32" required/>
				</div>
				<div>
					<input type="password" id="user_pw" name="pw" placeholder="  비밀번호" maxlength="32" required/>
				</div>
			
				<button type="submit" class="login-btn">로그인</button>
			</fieldset>
		</form>
	
		<!-- 회원가입 페이지 이동 문구 -->
		<div class="links">
    	  <a href="sign_up.jsp">회원가입 화면으로 →</a>
    	</div>
    </div>
</body>
</html>