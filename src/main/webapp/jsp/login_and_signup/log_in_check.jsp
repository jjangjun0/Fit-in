<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String name = null;

    String uId = "root";
    String uPw = "1234";
    String url = "jdbc:mysql://localhost:3306/fit_in";

    String sql = "SELECT name FROM user_list WHERE id = ? AND user_pw = ?";
    try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		try (Connection con = DriverManager.getConnection(url, uId, uPw);
	             PreparedStatement ptmt = con.prepareStatement(sql)) {
			ptmt.setString(1, id);
			ptmt.setString(2, pw);
			try (ResultSet rs = ptmt.executeQuery()) {
				if (rs.next())
					name = rs.getString("name");
			}
		}
	
	} catch (Exception e) {
		System.out.println("오류 발생" + e.getMessage());
		e.printStackTrace();
	}
    
    if (name == null) {
%>
        <script>
        	alert("아이디나 비밀번호를 다시 확인하십시오.");
            history.back();
        </script>
<%
        return;
    }
    // 아이디와 비밀번호가 맞았다면 session에 저장해야 한다.
    session.setAttribute("userId", id);
	session.setAttribute("userName", name);

/* --------- 설문 진행 여부 확인 -------- */

    Connection con2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;

    boolean needSurvey = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con2 = DriverManager.getConnection(url, uId, uPw);

        String checkSql = "SELECT COUNT(*) FROM user_info WHERE id = ?";
        ps2 = con2.prepareStatement(checkSql);
        ps2.setString(1, id);
        rs2 = ps2.executeQuery();

        if (rs2.next()) {
            int count = rs2.getInt(1);
            if (count == 0) { 
                needSurvey = true;  // 설문 안 했음
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs2 != null) rs2.close(); } catch (Exception e) {}
        try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
        try { if (con2 != null) con2.close(); } catch (Exception e) {}
    }

    if (needSurvey) {
        // 최초 로그인 -> 설문 페이지 이동
        response.sendRedirect("../user_style_survey/survey.jsp");
    } else {
        // 이미 설문함 -> 홈으로 이동
        response.sendRedirect("../home.jsp");
    }
%>
