<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%!
    NumberFormat formatter = NumberFormat.getNumberInstance(Locale.KOREA);

    public String formatPrice(int price) {
        return formatter.format(price);
    }

    class Item {
        String number, name, img, kind;
        int price;
        int ischecked;
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    String top = request.getParameter("top");
    String bottom = request.getParameter("bottom");
    String shoes = request.getParameter("shoes");
    // 모두 선택 안했을 때 예외 처리
    if ("none".equals(top) && "none".equals(bottom) && "none".equals(shoes)) {
%>
    	<script>
        	alert("최소 하나의 상품을 선택해야 합니다!");
        	window.location.href = "../home.jsp";   // 메인 화면으로 이동
    	</script>
<%
        return; // JSP 실행 중단
    }

    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    Item topItem = null, bottomItem = null, shoesItem = null;

    String sql = "SELECT product_number, name, price, kind, ischeck FROM clothes_list WHERE product_number = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw);
             PreparedStatement ptmt = con.prepareStatement(sql)) {

            // 상의
            if (!"none".equals(top)) {
                ptmt.setInt(1, Integer.parseInt(top.substring(1)));
                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        topItem = new Item();
                        topItem.number = top;
                        topItem.name = rs.getString("name");
                        topItem.price = rs.getInt("price");
                        topItem.ischecked = rs.getInt("ischeck");
                        topItem.img = "../../images/top/" + top + ".webp";
                    }
                }
            }

            // 하의
            if (!"none".equals(bottom)) {
                ptmt.setInt(1, Integer.parseInt(bottom.substring(1)));
                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        bottomItem = new Item();
                        bottomItem.number = bottom;
                        bottomItem.name = rs.getString("name");
                        bottomItem.price = rs.getInt("price");
                        bottomItem.ischecked = rs.getInt("ischeck");
                        bottomItem.img = "../../images/bottom/" + bottom + ".webp";
                    }
                }
            }

            // 신발
            if (!"none".equals(shoes)) {
                ptmt.setInt(1, Integer.parseInt(shoes.substring(1)));
                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        shoesItem = new Item();
                        shoesItem.number = shoes;
                        shoesItem.name = rs.getString("name");
                        shoesItem.price = rs.getInt("price");
                        shoesItem.ischecked = rs.getInt("ischeck");
                        shoesItem.img = "../../images/shoes/" + shoes + ".webp";
                    }
                }
            }

        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    int totalPrice = 0;
    if (topItem != null) totalPrice += topItem.price;
    if (bottomItem != null) totalPrice += bottomItem.price;
    if (shoesItem != null) totalPrice += shoesItem.price;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>선택한 옷 상세</title>

<style>
    body {
        margin: 0;
        font-family: 'Pretendard','Nanum Gothic',sans-serif;
        background: #f2f2f2;
        display: flex;
        justify-content: center;
        padding: 40px;
    }

    .container {
        width: 900px;
        background: #fff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.10);
    }

    h2 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 24px;
        font-weight: 700;
        color: #2c3e50;
    }

    .item-box {
        display: flex;
        justify-content: space-between;
        margin-bottom: 40px;
        gap: 20px;
    }

    .card {
        width: 30%;
        background: #fafafa;
        padding: 15px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    }

    .card img {
        width: 100%;
        height: 180px;
        border-radius: 10px;
        object-fit: cover;
    }

    .name { margin-top: 12px; font-size: 16px; font-weight: 600; color: #333; }
    .price { font-size: 15px; color: #666; margin-top: 5px; }
    .none-item { margin-top: 70px; font-size: 20px; color: #777; font-weight: 600; }

    .wish-btn {
        margin-top: 12px;
        cursor: pointer;
        font-size: 22px;
        background: none;
        border: none;
    }

    .wish-btn:hover {
        transform: scale(1.2);
    }

    .result-box { text-align: center; margin-top: 40px; }
    .total { font-size: 24px; font-weight: 700; margin-bottom: 20px; color: #2c3e50; }

    .btn {
        padding: 12px 28px;
        font-size: 17px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        margin: 10px;
        font-weight: 600;
    }

    .buy-btn { background: #27ae60; color: white; }
    .buy-btn:hover { background: #1e874b; }
    .back-btn { background: #bdc3c7; color: #333; }
    .back-btn:hover { background: #a7b1b5; }
</style>

<script>
// ⭐ 찜 버튼 AJAX 호출
function toggleWish(productNumber, btnElement) {

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "wish_toggle.jsp", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {

            // ★ 토글 UI 변경
            if (btnElement.innerText === "☆") {
                btnElement.innerText = "★";
                btnElement.style.color = "#f39c12";
            } else {
                btnElement.innerText = "☆";
                btnElement.style.color = "#555";
            }
        }
    };

    xhr.send("product=" + productNumber);
}
</script>

</head>
<body>

<div class="container">

    <h2>선택한 코디</h2>

    <div class="item-box">

        <!-- 상의 -->
        <div class="card">
            <% if (topItem != null) { %>
                <img src="<%= topItem.img %>">
                <div class="name"><%= topItem.name %></div>
                <div class="price"><%= formatPrice(topItem.price) %>원</div>

                <!-- 찜 버튼 -->
                <button class="wish-btn"
                        onclick="toggleWish('<%= topItem.number %>', this)"
                        style="color:<%= topItem.ischecked == 1 ? "#f39c12" : "#555" %>">
                    <%= topItem.ischecked == 1 ? "★" : "☆" %>
                </button>

            <% } else { %>
                <div class="none-item">선택 안 함</div>
            <% } %>
        </div>

        <!-- 하의 -->
        <div class="card">
            <% if (bottomItem != null) { %>
                <img src="<%= bottomItem.img %>">
                <div class="name"><%= bottomItem.name %></div>
                <div class="price"><%= formatPrice(bottomItem.price) %>원</div>

                <button class="wish-btn"
                        onclick="toggleWish('<%= bottomItem.number %>', this)"
                        style="color:<%= bottomItem.ischecked == 1 ? "#f39c12" : "#555" %>">
                    <%= bottomItem.ischecked == 1 ? "★" : "☆" %>
                </button>

            <% } else { %>
                <div class="none-item">선택 안 함</div>
            <% } %>
        </div>

        <!-- 신발 -->
        <div class="card">
            <% if (shoesItem != null) { %>
                <img src="<%= shoesItem.img %>">
                <div class="name"><%= shoesItem.name %></div>
                <div class="price"><%= formatPrice(shoesItem.price) %>원</div>

                <button class="wish-btn"
                        onclick="toggleWish('<%= shoesItem.number %>', this)"
                        style="color:<%= shoesItem.ischecked == 1 ? "#f39c12" : "#555" %>">
                    <%= shoesItem.ischecked == 1 ? "★" : "☆" %>
                </button>

            <% } else { %>
                <div class="none-item">선택 안 함</div>
            <% } %>
        </div>

    </div>

    <div class="result-box">
        <div class="total">총 금액 : <%= formatPrice(totalPrice) %> 원</div>

        <form action="buy_process.jsp" method="post">
            <input type="hidden" name="top" value="<%= top %>">
            <input type="hidden" name="bottom" value="<%= bottom %>">
            <input type="hidden" name="shoes" value="<%= shoes %>">
            <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
            <button class="btn buy-btn" type="submit">구매하기</button>
        </form>

        <form action="../home.jsp" method="post">
            <button class="btn back-btn">뒤로가기</button>
        </form>
    </div>

</div>

</body>
</html>
