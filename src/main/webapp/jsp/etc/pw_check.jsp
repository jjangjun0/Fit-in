<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    	String userId = (String) session.getAttribute("userId");
    	String inputPw = request.getParameter("input_pw");     // setting.jsp에서 입력받은 비밀번호
    	
    	if (userId == null) {
    		response.sendRedirect("../login_and_signup/log_in.jsp");
            return;
    	}
    	else if (inputPw == null) {
    		response.sendRedirect("setting.jsp");
    		return;
    	}
    	
    	String uId = "root";
        String uPw = "1234";
        String url = "jdbc:mysql://localhost:3306/fit_in";
        
        String real_pw = ""; // 설정한 비밀번호
        
        String sql = "SELECT user_pw FROM user_list WHERE id = ?";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, uId, uPw);
                 PreparedStatement ptmt = con.prepareStatement(sql)) {

                ptmt.setString(1, userId);

                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        real_pw = rs.getString("user_pw");
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
        
        if (!inputPw.equals(real_pw)) {
    %>
            <script>
                alert("설정하신 비밀번호와 다릅니다!");
                window.location.href = "setting.jsp";
            </script>
    <%
    		return;
        }
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>

<style>
	body{margin:0;font-family:'Pretendard','Nanum Gothic',sans-serif;
	background:linear-gradient(135deg,#f0f0f0,#d9d9d9,#c5c5c5);
	min-height:100vh;display:flex;align-items:center;justify-content:center}
	.card{width:430px;background:#fff;border-radius:18px;box-shadow:0 12px 24px rgba(0,0,0,.18);padding:28px}
	h2{margin-top:0;text-align:center;color:#2c3e50}
	input[type="password"]{
		width:100%;padding:12px;border:1px solid #ccc;border-radius:10px;
		font-size:15px;box-sizing:border-box;margin-bottom:15px;
	}
	button{
		width:100%;padding:12px;border:none;border-radius:10px;
		background:red;color:white;font-size:15px;font-weight:700;cursor:pointer;
	}
	button:hover{background:#1f5f8b;}
</style>

</head>
<body>
<div class="card">
	<h2>비밀번호 변경</h2>

	<form action="pw_update.jsp" method="post">
		<input type="password" name="new_pw" placeholder="새 비밀번호 입력" required maxlength="20">
		<button type="submit">변경하기</button>
	</form>

</div>
</body>
</html>