<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
  body{margin:0;font-family:'Pretendard','Nanum Gothic',sans-serif;
  background:linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
  min-height:100vh;display:flex;align-items:center;justify-content:center}
  .card{width:480px;background:#fff;border-radius:18px;box-shadow:0 12px 24px rgba(0,0,0,.18);padding:28px}
  h1{margin:0 0 16px;color:#2c3e50;font-size:22px}
  .field{margin-bottom:12px}
  label{display:block;margin-bottom:6px;color:#34495e;font-size:13px}
  input{width:100%;padding:11px 12px;border:1px solid #dfe6e9;border-radius:10px;font-size:14px;outline:none}
  input:focus{border-color:#3498db;box-shadow:0 0 0 3px rgba(52,152,219,.15)}
  .btn{width:100%;padding:12px;border:0;border-radius:10px;background:#27ae60;color:#fff;font-weight:700;font-size:15px;cursor:pointer;margin-top:10px}
  .btn:hover{background:#2980b9}
  .links{margin-top:12px;text-align:center}
  .links a{color:#2980b9;text-decoration:none}
</style>
</head>
<body>
  <div class="card">
    <h1>회원가입</h1>
    <form action="sign_up_check.jsp" method="post" accept-charset="UTF-8" autocomplete="off">
      <div class="field">
        <label for="id">아이디</label>
        <input type="text" id="id" name="id" maxlength="20" placeholder="예) hong123" required>
      </div>
      <div class="field">
        <label for="pw">비밀번호</label>
        <input type="password" id="pw" name="user_pw" maxlength="20" placeholder="숫자/문자 조합 권장" required>
      </div>
      <div class="field">
        <label for="name">이름</label>
        <input type="text" id="name" name="name" required maxlength="30" placeholder="예) 홍길동" required>
      </div>
      <div class="field">
        <label for="birth">생년월일 8자리</label>
        <input type="text" id="birth" name="birth" required maxlength="50" placeholder="예) 2003-01-01" required>
      </div>
      <div class="field">
        <label for="email">이메일</label>
        <input type="email" id="email" name="email" required maxlength="50" placeholder="예) hong@naver.com" required>
      </div>
      <button class="btn" type="submit">가입하기</button>
    </form>
    <div class="links">
      <a href="log_in.jsp">← 로그인 화면으로</a>
    </div>
  </div>
</body>
</html>