<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 세션 체크
    String userId = (String)session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 새 비밀번호를 제출한 경우인지 확인
    String newPw = request.getParameter("new_pw");

    String uId = "root";
    String uPw = "1234";
    String url = "jdbc:mysql://localhost:3306/fit_in";
    
    String sql = "UPDATE user_list SET user_pw = ? WHERE id = ?";
    int result = 0;

    // 비밀번호 UPDATE 수행
    if (newPw != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, uId, uPw);
                 PreparedStatement ptmt = con.prepareStatement(sql)) {

                ptmt.setString(1, newPw);
                ptmt.setString(2, userId);

                result = ptmt.executeUpdate();
            }
        } catch (Exception e) {
        	System.out.println("오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    if (result > 0) {
%>
        <script>
            alert("비밀번호가 성공적으로 변경되었습니다!");
            window.location.href = "setting.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
            window.location.href = "password_check.jsp";
        </script>
<%
    }
%>