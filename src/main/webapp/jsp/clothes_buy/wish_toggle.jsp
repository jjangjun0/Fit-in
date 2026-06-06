<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 1) 두 방식 모두 허용: ?product=p1101 또는 ?number=1101
    String product = request.getParameter("product");
    String numberParam = request.getParameter("number");
    
    System.out.println("product: " + product + ", number: " + numberParam);

    int pnum = -1;

    // CASE 1: product = "p1101" 형태로 들어온 경우
    if (product != null && !product.equals("")) {
        pnum = Integer.parseInt(product.substring(1)); // p1101 → 1101
    }

    // CASE 2: number = "1101" 형태로 들어온 경우
    else if (numberParam != null && !numberParam.equals("")) {
        pnum = Integer.parseInt(numberParam); // 그냥 바로 숫자
    }

    if (pnum == -1) {
        out.print("error");
        return;
    }

    // DB
    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    int newStatus = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {

            // 2) 현재 ischeck 가져오기
            String selectSql = "SELECT ischeck FROM clothes_list WHERE product_number = ?";
            try (PreparedStatement ptmt = con.prepareStatement(selectSql)) {
                ptmt.setInt(1, pnum);
                ResultSet rs = ptmt.executeQuery();

                if (rs.next()) {
                    int current = rs.getInt("ischeck");
                    newStatus = (current == 1 ? 0 : 1);  // 토글
                }
            }

            // 3) DB 업데이트
            String updateSql = "UPDATE clothes_list SET ischeck = ? WHERE product_number = ?";
            try (PreparedStatement ptmt2 = con.prepareStatement(updateSql)) {
                ptmt2.setInt(1, newStatus);
                ptmt2.setInt(2, pnum);
                ptmt2.executeUpdate();
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
        return;
    }

    // 4) 로그 출력 (콘솔)
    if (product != null) {
        System.out.print(product + "가 ");
    } else {
        System.out.print("p" + pnum + "가 ");
    }

    if (newStatus == 1)
        System.out.println("찜 목록에 추가되었습니다!");
    else
        System.out.println("찜 목록에서 해제되었습니다..");

    // 5) AJAX 응답
    out.print(newStatus);
%>
