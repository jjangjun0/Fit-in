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

    // 1) 파라미터 받기
    String depositStr = request.getParameter("depositAmount");

    if (depositStr == null || depositStr.trim().equals("")) {
        response.sendRedirect("how_much_charge.jsp");
        return;
    }

    // 2) 쉼표 제거 후 int 변환
    int depositMoney = Integer.parseInt(depositStr.replace(",", "").trim());

    // DB 정보
    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    int currentBalance = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {

            // 3) 현재 잔액 조회
            String sqlSelect = "SELECT bank_account FROM user_list WHERE id = ?";
            try (PreparedStatement ptmt = con.prepareStatement(sqlSelect)) {
                ptmt.setString(1, userId);

                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        currentBalance = rs.getInt("bank_account");
                        if (rs.wasNull()) currentBalance = 0;
                    }
                }
            }

            // 4) 새로운 잔액 계산
            int newBalance = currentBalance + depositMoney;

            // 5) DB 업데이트
            String sqlUpdate = "UPDATE user_list SET bank_account = ? WHERE id = ?";
            try (PreparedStatement ptmt2 = con.prepareStatement(sqlUpdate)) {
                ptmt2.setInt(1, newBalance);
                ptmt2.setString(2, userId);
                ptmt2.executeUpdate();
            }

            // 6) 완료 후 리다이렉트 (충전 완료 페이지 등)
            response.sendRedirect("charge_success.jsp?newBalance=" + newBalance);

        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }
%>
