<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/fit_in";
    String uId = "root";
    String uPw = "1234";

    class Item {
        int number;
        String name;
        String kind;
        int price;
    }

    // 전체 리스트
    List<Item> wishList = new ArrayList<>();

    // 카테고리별 리스트
    List<Item> tops = new ArrayList<>();
    List<Item> bottoms = new ArrayList<>();
    List<Item> shoes = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {

            // 찜 목록 가져오기
            String sql =
                "SELECT product_number, name, kind, price " +
                "FROM clothes_list WHERE ischeck = 1";

            try (PreparedStatement ptmt = con.prepareStatement(sql);
                 ResultSet rs = ptmt.executeQuery()) {

                while (rs.next()) {
                    Item item = new Item();
                    item.number = rs.getInt("product_number");
                    item.name = rs.getString("name");
                    item.kind = rs.getString("kind");
                    item.price = rs.getInt("price");

                    // 숫자로 구분 (1000 / 2000 / 3000)
                    int num = item.number;

                    if (num >= 1000 && num < 2000) tops.add(item);
                    else if (num >= 2000 && num < 3000) bottoms.add(item);
                    else if (num >= 3000 && num < 4000) shoes.add(item);
                }
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    // 카테고리별로 섞기
    Collections.shuffle(tops);
    Collections.shuffle(bottoms);
    Collections.shuffle(shoes);

    // 최종 순서 = 상의 → 하의 → 신발
    wishList.addAll(tops);
    wishList.addAll(bottoms);
    wishList.addAll(shoes);
%>

<%!
    // 가격 포맷 함수
    String formatPrice(int price) {
        return String.format("%,d", price);
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>

<style>
    body {
    margin: 0;
    font-family: 'Pretendard','Nanum Gothic', sans-serif;
    background: #f2f2f2;
    padding: 0;
	}
    
    /* 홈과 동일한 검정색 상단바 + Fit in 로고 */
	.simple-navbar {
    	width: 100%;
    	height: 75px;
    	background: #3a3a3a;   /* 홈과 동일한 검정색 */
    	display: flex;
    	align-items: center;
    	padding: 0 20px;
    	box-sizing: border-box;
	}

	/* 로고 텍스트 */
	.simple-navbar .logo {
    	font-size: 24px;
    	font-weight: 700;
    	color: white;
    	font-family: 'Pretendard','Nanum Gothic', sans-serif;
	}

    .container {
    	width: 900px;
    	background: #fff;
    	padding: 30px;
    	border-radius: 15px;
    	box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    	margin: 40px auto;
	}

    h2 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 26px;
        font-weight: 700;
        color: #2c3e50;
    }

    .grid {
        display: flex;
        flex-wrap: wrap;
        gap: 25px;
        justify-content: center;
    }

    .card {
        width: 220px;
        background: #fafafa;
        padding: 15px;
        border-radius: 16px;
        text-align: center;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        position: relative;
        transition: 0.3s;
    }

    .card img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        border-radius: 12px;
    }

    .x-btn {
    	position: absolute;
    	top: 12px;
    	right: 12px;
    	font-size: 25px;
    	cursor: pointer;
    	color: black;      /* 기본색: 검정 */
    	transition: 0.2s;
	}

	.x-btn:hover {
	    color: red;        /* 호버하면 빨간색 */
	}

    .name {
        margin-top: 12px;
        font-size: 17px;
        font-weight: 600;
        color: #333;
    }

    .price {
        margin-top: 5px;
        font-size: 15px;
        color: #666;
    }

    .buy-btn {
        margin-top: 12px;
        padding: 10px 16px;
        border-radius: 10px;
        background: #27ae60;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 15px;
        font-weight: 600;
        width: 100%;
    }

    .buy-btn:hover {
        background: #1e874b;
    }

    .empty {
        text-align: center;
        font-size: 20px;
        color: #777;
        margin-top: 50px;
        font-weight: 600;
    }

    .back-btn {
        display: block;
        margin: 40px auto 0;
        padding: 12px 28px;
        font-size: 17px;
        border: none;
        border-radius: 10px;
        background: #3498db;
        color: white;
        cursor: pointer;
        font-weight: 600;
    }

    .back-btn:hover {
        background: #217dbb;
    }
</style>

</head>
<body>
	<div class="simple-navbar">
    	<div class="logo">Fit in</div>
	</div>

<div class="container">
    <h2>찜한 목록</h2>

    <% if (wishList.size() == 0) { %>

        <div class="empty">찜한 상품이 없습니다 ㅠㅅㅠ</div>

    <% } else { %>

        <div class="grid">

        <% 
            for (Item it : wishList) {
                String folder = "";
                if ("top".equals(it.kind)) folder = "top";
                else if ("bottom".equals(it.kind)) folder = "bottom";
                else if ("shoes".equals(it.kind)) folder = "shoes";

                String imgPath = "../../images/" + folder + "/p" + it.number + ".webp";
        %>

            <div class="card" id="card-<%= it.number %>">

                <!-- 2. 찜 해제 버튼 -->
                <div class="x-btn"
                     onclick="toggleWish(<%= it.number %>)"
                     id="heart-<%= it.number %>">🗙</div>

                <img src="<%= imgPath %>">

                <div class="name"><%= it.name %></div>
                <div class="price"><%= formatPrice(it.price) %>원</div>

                <!-- 1. 바로 구매하기 버튼 -->
                <form action="../clothes_buy/buy_process.jsp" method="post">

    				<input type="hidden" name="top" value="none">
    				<input type="hidden" name="bottom" value="none">
    				<input type="hidden" name="shoes" value="none">

    				<% if ("top".equals(it.kind)) { %>
        				<input type="hidden" name="top" value="p<%= it.number %>">
    				<% } else if ("bottom".equals(it.kind)) { %>
        				<input type="hidden" name="bottom" value="p<%= it.number %>">
    				<% } else if ("shoes".equals(it.kind)) { %>
        				<input type="hidden" name="shoes" value="p<%= it.number %>">
    				<% } %>

    				<!-- 총 가격 전달 -->
    				<input type="hidden" name="totalPrice" value="<%= it.price %>">

    				<button class="buy-btn" type="submit">구매하기</button>
				</form>

            </div>

        <% } %>

        </div>

    <% } %>

    <form action="../home.jsp" method="post">
        <button class="back-btn">메인 화면으로</button>
    </form>

</div>

<!-- ========================= -->
<!--  AJAX: 찜 해제 기능       -->
<!-- ========================= -->
<script>
function toggleWish(pnum) {

    fetch("../clothes_buy/wish_toggle.jsp?number=" + pnum)
        .then(response => response.text())
        .then(result => {

            // DB에서 해제 후 → 화면에서 카드 제거
            const card = document.getElementById("card-" + pnum);
            if (card) {
                card.style.opacity = "0";

                setTimeout(() => {
                    card.remove();
                }, 300);
            }
        });
}
</script>

</body>
</html>
