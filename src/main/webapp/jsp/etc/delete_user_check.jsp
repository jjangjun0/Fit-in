<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 확인
    String userId = (String)session.getAttribute("userId");
    String userName = (String)session.getAttribute("userName");
    if (userId == null || userId.isBlank()) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 폼에서 넘어온 id 
    String id = request.getParameter("id");
    
    // 세션의 userId와 폼의 id가 일치하는지 한 번 더 확인
    if (id == null || !id.equals(userId)) {
    	response.sendRedirect("delete_user.jsp?result=err"); // 이거 중간에 띄어쓰기 하면 안된다.
    	return ;
    }
    //DB연결  및 탈퇴 성공 result에 담아서 보내기 성공시 result=by", 실패시 result=err
	String url = "jdbc:mysql://localhost:3306/fit_in";
    String uid = "root";
    String upw = "1234";
    String sql = "DELETE FROM user_list WHERE id=?";
    boolean ok = false;
    String result = "err";
    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
    	
    	try (Connection con = DriverManager.getConnection(url, uid, upw);
    			PreparedStatement ps = con.prepareStatement(sql)) {
    		ps.setString(1, id);
    		int n = ps.executeUpdate();
    		ok = (n == 1);
    		System.out.println("delete 성공");
    	}
    } catch (Exception e) {
    	ok = false;
    	e.printStackTrace();
    }
    if (ok) {
    	session.invalidate();
    	response.sendRedirect("../login_and_signup/log_in.jsp?result=bye&userId=" + userId);
    }
    else
    	response.sendRedirect("delete_user.jsp?result=err");
%>