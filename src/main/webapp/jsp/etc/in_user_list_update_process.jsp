<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 수정된 정보 받아오기
    String newName = request.getParameter("name");
    String newBirth = request.getParameter("birth");
    String newEmail = request.getParameter("email");

    // 필수값 체크
    if (newName == null || newBirth == null || newEmail == null) {
%>
        <script>
            alert("잘못된 접근입니다.");
            history.back();
        </script>
<%
        return;
    }

    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    int result = 0;

    String sql = "UPDATE user_list SET name = ?, birth = ?, email = ? WHERE id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw);
             PreparedStatement ptmt = con.prepareStatement(sql)) {

            ptmt.setString(1, newName);
            ptmt.setString(2, newBirth);
            ptmt.setString(3, newEmail);
            ptmt.setString(4, userId);

            result = ptmt.executeUpdate();
        }

    } catch (Exception e) {
        System.out.println("오류 발생: " + e.getMessage());
        e.printStackTrace();
    }

    if (result > 0) {
%>
        <script>
            alert("회원정보가 성공적으로 수정되었습니다!");
            window.location.href = "setting.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("회원정보 수정에 실패했습니다. 다시 시도해주세요.");
            history.back();
        </script>
<%
    }
%>
