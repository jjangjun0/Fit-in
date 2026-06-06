<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인한 사용자만 접근 가능
    String userId = (String)session.getAttribute("userId");
    String userName = (String)session.getAttribute("userName");
    System.out.println("[delete_user]현재 session -> userId: " + userId + ", userName: " + userName);
    
    if (userId == null || userId.isBlank()) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 에러가 있을 경우 result=err 로 들어올 수 있음
	String result = request.getParameter("result");
	if ("err".equals(result)) { %>
		
	<script>
		alert("탈퇴 중 오류가 발생했습니다.");
	</script>
<% } %>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<style>
  body{margin:0;font-family:'Pretendard','Nanum Gothic',sans-serif;
	background:linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
  	min-height:100vh;display:flex;align-items:center;justify-content:center}
  .card{width:420px;background:#fff;border-radius:16px;box-shadow:0 10px 22px rgba(0,0,0,.15);padding:26px;text-align:center}
  h1{margin:0 0 10px;color:#c0392b}
  .warn{color:#c0392b;margin-bottom:14px}
  form{display:flex;gap:10px;justify-content:center}
  .btn{background:#e74c3c;color:#fff;border:none;padding:10px 16px;border-radius:8px;cursor:pointer}
  .btn:hover{background:#c0392b}
  a.link{display:inline-block;padding:10px 16px;border-radius:8px;background:#bdc3c7;color:#2c3e50;text-decoration:none}
  a.link:hover{background:#95a5a6}
</style>
</head>
<body>

<%-- 삭제 실패했을 때만 간단 알림 --%>


<div class="card">
  <h1>회원 탈퇴</h1>
  <p class="warn">
    정말로 <b><%= (userName != null ? userName : userId) %></b> 님의 계정을 탈퇴하시겠습니까?<br>
    탈퇴 후에는 계정을 다시 복구할 수 없습니다.
  </p>

  <form action="delete_user_check.jsp" method="post">
    <input type="hidden" name="id" value="<%= userId %>">
    <button class="btn" type="submit">탈퇴하기</button>
    <a class="link" href="setting.jsp">취소</a>
  </form>
</div>
</body>
</html>