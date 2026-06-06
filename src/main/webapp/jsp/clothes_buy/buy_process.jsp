<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    String userId = (String)session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 선택된 상품
    String top = request.getParameter("top");
    String bottom = request.getParameter("bottom");
    String shoes = request.getParameter("shoes");

    // 총 가격
    int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));

    // DB 접속 정보
    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    int currentBalance = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {

            /* 1) 현재 잔액 조회 */
            String sqlSelect = "SELECT bank_account FROM user_list WHERE id = ?";
            try (PreparedStatement pstmt = con.prepareStatement(sqlSelect)) {
                pstmt.setString(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        currentBalance = rs.getInt("bank_account");
                    }
                }
            }

            /* 2) 잔액 부족 체크 */
            if (currentBalance < totalPrice) {
%>
                <script>
                    alert("잔액이 부족합니다! 충전 후 다시 시도해주세요.");
                    history.back();
                </script>
<%
                return;
            }

            /* 3) 잔액 차감 */
            int newBalance = currentBalance - totalPrice;

            String sqlUpdate = "UPDATE user_list SET bank_account = ? WHERE id = ?";
            try (PreparedStatement pstmt2 = con.prepareStatement(sqlUpdate)) {
                pstmt2.setInt(1, newBalance);
                pstmt2.setString(2, userId);
                pstmt2.executeUpdate();
            }

            // 선택 상품 목록
            String buyTop = (!"none".equals(top)) ? top : "";
            String buyBottom = (!"none".equals(bottom)) ? bottom : "";
            String buyShoes = (!"none".equals(shoes)) ? shoes : "";

            // 구매 성공 페이지로 넘기기
            response.sendRedirect(
            	    "buy_success.jsp?top=" + buyTop +
            	    "&bottom=" + buyBottom +
            	    "&shoes=" + buyShoes +
            	    "&totalPrice=" + totalPrice +
            	    "&finalBalance=" + newBalance
            	);
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }
%>
