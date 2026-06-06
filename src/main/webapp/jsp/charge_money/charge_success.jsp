<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");

    if (userId == null || userId.trim().equals("")) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    String newBalanceStr = request.getParameter("newBalance");
    int newBalance = 0;

    if (newBalanceStr != null && !newBalanceStr.trim().equals("")) {
        newBalance = Integer.parseInt(newBalanceStr);
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입금 완료</title>

<style>
    body {
        margin: 0;
        font-family: 'Pretendard','Nanum Gothic',sans-serif;
        background: linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .card {
        width: 450px;
        background: #fff;
        border-radius: 18px;
        box-shadow: 0 12px 24px rgba(0,0,0,.18);
        padding: 40px;
        text-align: center;
    }

    .success-title {
        font-size: 22px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 20px;
    }

    .checkmark {
        font-size: 60px;
        color: #27ae60;
        margin-bottom: 15px;
    }

    .balance-box {
        font-size: 18px;
        font-weight: 600;
        color: #34495e;
        margin-top: 10px;
        margin-bottom: 30px;
    }

    .home-btn, .charge-btn {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        border: none;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        margin-bottom: 12px;
    }

    .home-btn {
        background: #3498db;
        color: white;
    }
    .home-btn:hover {
        background: #217dbb;
    }

    .charge-btn {
        background: #ecf0f1;
        border: 1px solid #bdc3c7;
    }
    .charge-btn:hover {
        background: #dfe6e9;
    }

</style>

</head>

<body>

<div class="card">

    <div class="checkmark">✔</div>

    <div class="success-title">입금이 완료되었습니다!</div>

    <div class="balance-box">
        새로운 잔액은<br>
        <span style="font-size: 24px; color: #27ae60;">
            <%= String.format("%,d", newBalance) %> 원
        </span>
        <br>입니다.
    </div>

    <form action="../home.jsp" method="post">
        <button class="home-btn">메인 화면으로</button>
    </form>

    <form action="enter_money.jsp" method="post">
        <button class="charge-btn">추가 입금하기</button>
    </form>

</div>

</body>
</html>
