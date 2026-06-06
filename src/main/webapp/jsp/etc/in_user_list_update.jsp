<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    String uId = "root";
    String uPw = "1234";
    String url = "jdbc:mysql://localhost:3306/fit_in";

    String name = "";
    String birth = "";
    String email = "";

    // user_list 조회
    String sql = "SELECT name, birth, email FROM user_list WHERE id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw);
             PreparedStatement ptmt = con.prepareStatement(sql)) {

            ptmt.setString(1, userId);

            try (ResultSet rs = ptmt.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("name");
                    birth = rs.getString("birth");
                    email = rs.getString("email");
                }
            }
        }

    } catch (Exception e) {
        System.out.println("오류 발생: " + e.getMessage());
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>

<style>
    body{
        margin:0;
        font-family:'Pretendard','Nanum Gothic',sans-serif;
        background:linear-gradient(135deg,#f0f0f0,#d9d9d9,#c5c5c5);
        min-height:100vh;display:flex;align-items:center;justify-content:center
    }
    .card{
        width:500px;background:#fff;border-radius:18px;box-shadow:0 12px 24px rgba(0,0,0,.18);
        padding:30px;
    }
    h2{margin-top:0;text-align:center;color:#2c3e50;margin-bottom:22px}
    label{font-weight:600;margin-bottom:6px;display:block}
    input{
        width:100%;padding:12px;border:1px solid #ccc;border-radius:10px;
        font-size:15px;margin-bottom:16px;box-sizing:border-box;
    }
    input:focus{
        border-color:#3498db;box-shadow:0 0 0 3px rgba(52,152,219,.15);
    }
    .btn{
        width:100%;padding:12px;border:none;border-radius:10px;
        background:#27ae60;color:#fff;font-weight:700;font-size:15px;cursor:pointer;
        margin-top:10px;
    }
    .btn:hover{background:#1f5f8b;}
    .btn-cancel{
        background:#7f8c8d;
        margin-top:10px;
    }
    .btn-cancel:hover{
        background:#636e72;
    }
</style>

</head>
<body>

<div class="card">
    <h2>회원정보 수정</h2>

    <form action="in_user_list_update_process.jsp" method="post">
        <label>아이디 (수정 불가)</label>
        <input type="text" value="<%= userId %>" readonly style="background:#f5f5f5;">

        <label>이름</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>생년월일</label>
        <input type="text" name="birth" value="<%= birth %>" required>

        <label>이메일</label>
        <input type="email" name="email" value="<%= email %>" required>

        <button type="submit" class="btn">저장하기</button>
    </form>

    <form action="setting.jsp" method="post">
        <button type="submit" class="btn btn-cancel">취소</button>
    </form>
</div>

</body>
</html>
