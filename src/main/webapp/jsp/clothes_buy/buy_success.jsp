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

    // 구매 처리 후 전달된 값
    String totalStr = request.getParameter("totalPrice");
    String finalStr = request.getParameter("finalBalance");

    int totalPrice = Integer.parseInt(totalStr);
    int finalBalance = Integer.parseInt(finalStr);
%>

<%! 
    /* 가격을 1,000 단위로 포맷해주는 함수 */
    String formatPrice(int price) {
        return String.format("%,d", price);
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 완료</title>

<style>
    body {
        margin: 0;
        font-family: 'Pretendard','Nanum Gothic', sans-serif;
        background: linear-gradient(135deg, #f0f0f0, #e4e4e4);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .wrap {
        width: 450px;
        background: #fff;
        padding: 35px;
        border-radius: 18px;
        box-shadow: 0 12px 24px rgba(0,0,0,0.15);
        text-align: center;
    }

    .title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 25px;
        color: #2c3e50;
    }

    .text {
        font-size: 18px;
        color: #555;
        margin-bottom: 10px;
    }

    .price {
        font-size: 26px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #27ae60;
    }

    .balance {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 30px;
        color: #333;
    }

    .btn {
        padding: 12px 25px;
        font-size: 17px;
        background: #3498db;
        color: white;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
    }

    .btn:hover {
        background: #217dbb;
    }
</style>
</head>

<body>

<div class="wrap">

    <div class="title">구매가 완료되었습니다! 🎉</div>

    <div class="text">결제 금액</div>
    <div class="price"><%= formatPrice(totalPrice) %>원</div>

    <div class="balance">남은 잔액 : <%= formatPrice(finalBalance) %>원</div>

    <form action="../home.jsp" method="post">
        <button class="btn">메인 화면으로</button>
    </form>

</div>

</body>
</html>
