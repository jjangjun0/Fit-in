<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String userId = (String) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    String uId = "root";
    String uPw = "1234";
    String url = "jdbc:mysql://localhost:3306/fit_in";

    // user_list
    String name = "";
    int bank_account = 0;
    boolean isNull = false;

    String sql1 = "SELECT name, bank_account FROM user_list WHERE id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {
            try (PreparedStatement ptmt = con.prepareStatement(sql1)) {
                ptmt.setString(1, userId);

                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        name = rs.getString("name");
                        int temp = rs.getInt("bank_account");
                        if (rs.wasNull())
                            isNull = true;
                        else
                            bank_account = temp;
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잔액 확인</title>

<style>
    body {
        margin: 0;
        font-family: 'Pretendard','Nanum Gothic',sans-serif;
        background: linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .card {
        width: 480px;
        background: #ffffff;
        border-radius: 18px;
        padding: 35px;
        box-shadow: 0 12px 24px rgba(0,0,0,.18);
        text-align: center;
    }

    .title {
        font-size: 22px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 20px;
    }

    .balance-box {
        font-size: 18px;
        font-weight: 600;
        color: #34495e;
        margin-bottom: 30px;
    }

    .balance-large {
        font-size: 26px;
        color: #27ae60;
    }

    .btn-blue, .btn-gray {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        font-size: 15px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        margin-top: 10px;
    }

    .btn-blue {
        background: #3498db;
        color: white;
    }
    .btn-blue:hover {
        background: #217dbb;
    }

    .btn-gray {
        background: #ecf0f1;
        border: 1px solid #bdc3c7;
    }
    .btn-gray:hover {
        background: #dfe6e9;
    }
</style>

</head>
<body>

<div class="card">

    <div class="title">계좌 잔액</div>

    <div class="balance-box">
        <% if (isNull) { %>
            <span style="color:#c0392b;">입금 후 이용 가능합니다.</span>
        <% } else { %>
            <%= name %>님, 현재 잔액은<br>
            <span class="balance-large">
                <%= String.format("%,d", bank_account) %> 원
            </span>
            입니다.
        <% } %>
    </div>

    <!-- 충전 버튼 -->
    <form action="enter_money.jsp" method="post">
        <button class="btn-blue">충전하기</button>
    </form>

    <!-- 메인화면 -->
    <form action="../home.jsp" method="post">
        <button class="btn-gray">메인화면으로</button>
    </form>

</div>

</body>
</html>
