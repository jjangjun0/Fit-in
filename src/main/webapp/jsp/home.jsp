<%@page import="java.util.Collections"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.fitin.clothes.Flag"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    	String userId = (String) session.getAttribute("userId");
    	String userName = (String) session.getAttribute("userName");
    	
    	System.out.println("[home.jsp] -> userName: " + userName);
    	if (userId == null || userName == null) {
    		response.sendRedirect("login_and_signup/log_in.jsp");
            return;
    	}
    	int TOP = 1000, BOTTOM = 2000, SHOES = 3000; // Labeling
    	int top_num = 50, bottom_num = 51, shoes_num = 40; // 옷 종류별 개수 
    	String extension = "webp";		// 이미지 확장자
    	
    	boolean SEE_DEBUGING = false;		// 과정 보기 //
    	
    			/* user_info의 prefer_tag를 통한 옷의 점수 계산 */
    	// 1-1. userId에 대한 user_info 에서의 prefer_tag를 읽어온다.
        String uId = "root";
        String uPw = "1234";
        String url = "jdbc:mysql://localhost:3306/fit_in";
        
        String sql = "SELECT prefer_tag FROM user_info WHERE id = ?";
        String preferTag = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, uId, uPw);
                 PreparedStatement ptmt = con.prepareStatement(sql)) {

                ptmt.setString(1, userId);
                
                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        preferTag = rs.getString("prefer_tag");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    	
    	// 1-2. prefer_tag에 대해 토큰화한다.
    	List<String> tag_list = new ArrayList<>();
    	
    	if (preferTag == null) {
    		response.sendRedirect("../login_and_signup/log_in.jsp");
            return;
    	}
    	String[] tokens = preferTag.split(",");
        for (String token : tokens) {
        	tag_list.add(token.trim());
        }
        if (SEE_DEBUGING) System.out.println("[test.jsp] -> preferTag: " + tag_list);
    	
    	// 1-3. prefer_tag에 해당한다면 Flag를 킨다.
    	Flag flag = new Flag();
    	boolean order[] = { true, true, true, true };
    	for (String tag : tag_list) {
    		if (tag.equals("Casual"))        { if (order[0]) {flag.setA1(5); order[0] = false;} else {flag.setA1(3);} }
    		else if (tag.equals("Street"))   { if (order[0]) {flag.setA2(5); order[0] = false;} else {flag.setA2(3);} }
    		else if (tag.equals("Formal"))   { if (order[0]) {flag.setA3(5); order[0] = false;} else {flag.setA3(3);} }
    		else if (tag.equals("Minimal"))  { if (order[0]) {flag.setA4(5); order[0] = false;} else {flag.setA4(3);} }
    		else if (tag.equals("Sporty"))   { if (order[0]) {flag.setA5(5); order[0] = false;} else {flag.setA5(3);} }

    		if (tag.equals("Over"))          { if (order[1]) {flag.setB1(5); order[1] = false;} else {flag.setB1(3);} }
    		else if (tag.equals("SemiOver")) { if (order[1]) {flag.setB2(5); order[1] = false;} else {flag.setB2(3);} }
    		else if (tag.equals("Regular"))  { if (order[1]) {flag.setB3(5); order[1] = false;} else {flag.setB3(3);} }
    		else if (tag.equals("Slim"))     { if (order[1]) {flag.setB4(5); order[1] = false;} else {flag.setB4(3);} }
    		else if (tag.equals("Skinny"))   { if (order[1]) {flag.setB5(5); order[1] = false;} else {flag.setB5(3);} }

    		if (tag.equals("Monotone"))      { if (order[2]) {flag.setC1(5); order[2] = false;} else {flag.setC1(3);} }
    		else if (tag.equals("Vivid"))    { if (order[2]) {flag.setC2(5); order[2] = false;} else {flag.setC2(3);} }
    		else if (tag.equals("Pastel"))   { if (order[2]) {flag.setC3(5); order[2] = false;} else {flag.setC3(3);} }
    		else if (tag.equals("Basic"))    { if (order[2]) {flag.setC4(5); order[2] = false;} else {flag.setC4(3);} }
    		else if (tag.equals("Pattern"))  { if (order[2]) {flag.setC5(5); order[2] = false;} else {flag.setC5(3);} }

    		if (tag.equals("Running"))       { if (order[3]) {flag.setD1(5); order[3] = false;} else {flag.setD1(3);} }
    		else if (tag.equals("Hightop"))  { if (order[3]) {flag.setD2(5); order[3] = false;} else {flag.setD2(3);} }
    		else if (tag.equals("SlipOn"))   { if (order[3]) {flag.setD3(5); order[3] = false;} else {flag.setD3(3);} }
    		else if (tag.equals("Boots"))    { if (order[3]) {flag.setD4(5); order[3] = false;} else {flag.setD4(3);} }
    		else if (tag.equals("Sandal"))   { if (order[3]) {flag.setD5(5); order[3] = false;} else {flag.setD5(3);} }
    	}
    	
    	if (SEE_DEBUGING) {
    		System.out.println("===== FLAG VALUES =====");
    		System.out.println("A1=" + flag.getA1() + ", A2=" + flag.getA2() + ", A3=" + flag.getA3() + ", A4=" + flag.getA4() + ", A5=" + flag.getA5());
    		System.out.println("B1=" + flag.getB1() + ", B2=" + flag.getB2() + ", B3=" + flag.getB3() + ", B4=" + flag.getB4() + ", B5=" + flag.getB5());
    		System.out.println("C1=" + flag.getC1() + ", C2=" + flag.getC2() + ", C3=" + flag.getC3() + ", C4=" + flag.getC4() + ", C5=" + flag.getC5());
    		System.out.println("D1=" + flag.getD1() + ", D2=" + flag.getD2() + ", D3=" + flag.getD3() + ", D4=" + flag.getD4() + ", D5=" + flag.getD5());
    		System.out.println("=======================");	
    	}

    	
    	int score = 0;
    	
    	String sql2 = "SELECT tag FROM clothes_list WHERE product_number = ?";
    	String updateSql = "UPDATE clothes_list SET score = ? WHERE product_number = ?";
    	String tag2 = null;
    	
    	for (int i = 1; i <= top_num; i++) {
    		tag2 = null;
    		// 1-4. product_number에 따른 clothes_tag를 읽어온다.
    		try {
            	Class.forName("com.mysql.cj.jdbc.Driver");

            	try (Connection con = DriverManager.getConnection(url, uId, uPw);
                 	PreparedStatement ptmt = con.prepareStatement(sql2)) {

                	ptmt.setString(1, Integer.toString(TOP + i));	// 1000 + i의 tag를 가져옴
                
                	try (ResultSet rs = ptmt.executeQuery()) {
                    	if (rs.next()) {
                    		tag2 = rs.getString("tag");
                	    }
            	    }
        	    }
        	} catch (Exception e) {
        	    e.printStackTrace();
        	}
    		
    		if (tag2 == null)	// tag2.split()함수에서의 null pointer Exception 방지
    			continue;
    		
    		List<String> tag_list2 = new ArrayList<>();
    		String[] tokens2 = tag2.split(",");
    	    for (String token : tokens2) {
    	    	tag_list2.add(token.trim());
    	    }
    		
    	 	// 1-5. 가중치에 따른 점수 계산
    	    score = 0; // 점수 초기화
    	    for (String temp : tag_list2) {
    	        // ---------------- A 그룹 ----------------
    	        if (temp.equals("Casual"))        { score += flag.getA1(); }
    	        else if (temp.equals("Street"))   { score += flag.getA2(); }
    	        else if (temp.equals("Formal"))   { score += flag.getA3(); }
    	        else if (temp.equals("Minimal"))  { score += flag.getA4(); }
    	        else if (temp.equals("Sporty"))   { score += flag.getA5(); }

    	        // ---------------- B 그룹 ----------------
    	        if (temp.equals("Over"))          { score += flag.getB1(); }
    	        else if (temp.equals("SemiOver")) { score += flag.getB2(); }
    	        else if (temp.equals("Regular"))  { score += flag.getB3(); }
    	        else if (temp.equals("Slim"))     { score += flag.getB4(); }
    	        else if (temp.equals("Skinny"))   { score += flag.getB5(); }

    	        // ---------------- C 그룹 ----------------
    	        if (temp.equals("Monotone"))      { score += flag.getC1(); }
    	        else if (temp.equals("Vivid"))    { score += flag.getC2(); }
    	        else if (temp.equals("Pastel"))   { score += flag.getC3(); }
    	        else if (temp.equals("Basic"))    { score += flag.getC4(); }
    	        else if (temp.equals("Pattern"))  { score += flag.getC5(); }

    	        // ---------------- D 그룹 ----------------
    	        if (temp.equals("Running"))       { score += flag.getD1(); }
    	        else if (temp.equals("Hightop"))  { score += flag.getD2(); }
    	        else if (temp.equals("SlipOn"))   { score += flag.getD3(); }
    	        else if (temp.equals("Boots"))    { score += flag.getD4(); }
    	        else if (temp.equals("Sandal"))   { score += flag.getD5(); }
    	    }
    	    if (SEE_DEBUGING) System.out.println(i + TOP + " 0> " + tag_list2 + ", score: " + score);
    	    
    	    // 1-6. 옷 점수 update
    	    if (score == 0)
    	    	continue;

    		try {
        		Class.forName("com.mysql.cj.jdbc.Driver");

        		try (Connection con = DriverManager.getConnection(url, uId, uPw);
             			PreparedStatement ptmt = con.prepareStatement(updateSql)) {

            		ptmt.setInt(1, score);                   // 계산한 점수
            		ptmt.setInt(2, TOP + i);                 // product_number (예: 1001,1002,...)

            		int n = ptmt.executeUpdate();
            		if (n == 1) {
            		    // System.out.println("[UPDATE 성공] " + (TOP + i) + " => score=" + score);
            		}
            		else {
             		   // System.out.println("[UPDATE 실패] " + (TOP + i));
            		}
        		}
    		} catch (Exception e) {
    	    	e.printStackTrace();
    		}
    	}
    	
    			/* 옷 점수에 대해 내림차순으로 읽어온다. */
	    // 2-1. score에 대해서 내림차순 정렬하며 읽어온다.
	    List<Map<String, Integer>> topList    = new ArrayList<>();
	    List<Map<String, Integer>> bottomList = new ArrayList<>();
	    List<Map<String, Integer>> shoesList  = new ArrayList<>();
	
	    // 현재 월로 계절 계산
	    java.util.Calendar cal = java.util.Calendar.getInstance();
	    int month = cal.get(java.util.Calendar.MONTH) + 1;  // 0~11 → +1

	    String currentSeason = "";
	    if (month >= 3 && month <= 5)      currentSeason = "spring";
	    else if (month >= 6 && month <= 8) currentSeason = "summer";
	    else if (month >= 9 && month <= 11) currentSeason = "fall";
	    else                               currentSeason = "winter";

	    if (SEE_DEBUGING) System.out.println("[현재 계절] = " + currentSeason);

	    String sqlSort = "SELECT product_number, score, weather FROM clothes_list ORDER BY score DESC";

    	try {
	        Class.forName("com.mysql.cj.jdbc.Driver");

	        try (Connection con = DriverManager.getConnection(url, uId, uPw);
	             PreparedStatement ptmt = con.prepareStatement(sqlSort);
	             ResultSet rs = ptmt.executeQuery()) {

	            while (rs.next()) {
	                int pnum = rs.getInt("product_number");
	                int sc   = rs.getInt("score");
	                String weather = rs.getString("weather");

	                /* 테스트를 해보는 dummy 코드*/
	                // currentSeason = "summer";
	                // currentSeason = "fall";
	                currentSeason = "winter";
	                
	             	// 2-2. 읽어올 때, 계절에 맞는 옷을 선별한다.
	                if (!weather.equals(currentSeason)) {
	                    continue;
	                }

	                Map<String, Integer> data = new HashMap<>();
	                data.put("product_number", pnum);
	                data.put("score", sc);

	                // 2-3. 상의 / 하의 / 신발 구분해서 각 리스트에 추가
	                if (pnum >= 1000 && pnum < 2000) {
	                    topList.add(data);
	                } else if (pnum >= 2000 && pnum < 3000) {
	                    bottomList.add(data);
	                } else if (pnum >= 3000 && pnum < 4000) {
	                    shoesList.add(data);
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    if (SEE_DEBUGING) {
	        System.out.println("[topList]    = " + topList);
	        System.out.println("[bottomList] = " + bottomList);
	        System.out.println("[shoesList]  = " + shoesList);
	    }
	%>
<%!
	//점수가 같은 그룹끼리만 랜덤 셔플하는 함수
	void shuffleByScore(List<Map<String, Integer>> list) {
    	int n = list.size();
    	int idx = 0;

    	while (idx < n) {
        	int currentScore = list.get(idx).get("score");
        	int end = idx + 1;
        	while (end < n && list.get(end).get("score") == currentScore) {
        	    end++;
        	}
        	// idx ~ end-1: 같은 score 그룹
        	List<Map<String, Integer>> sameGroup = list.subList(idx, end);
        	Collections.shuffle(sameGroup);
        	idx = end;
    	}
	}
%>
	<%
    	// 2-4. 각 3개의 리스트에 대해서 점수가 같은 것끼리는 랜덤하게 섞는다.
    	shuffleByScore(topList);
    	shuffleByScore(bottomList);
    	shuffleByScore(shoesList);

    	if (SEE_DEBUGING) {
        	System.out.println("[셔플 후 topList]    = " + topList);
        	System.out.println("[셔플 후 bottomList] = " + bottomList);
        	System.out.println("[셔플 후 shoesList]  = " + shoesList);
    	}	
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 화면</title>
<style>
	body {
		margin: 0;
		font-family: 'Pretendard','Nanum Gothic', sans-serif;
	}
	.navbar {
		display: flex;
		align-items: center;
		justify-content: space-between;
		background: #3a3a3a;
		padding: 12px 20px;
		box-sizing: border-box;
		color: white;
	}
	/* 왼쪽 : 로고 + 검색창(생략) */
	.left-group {
		display: flex;
		align-items: center;
		gap: 20px;
		flex-grow: 1;   /* 오른쪽 메뉴와의 공간 확보 */
	}
	.logo {
		font-size: 24px;
		font-weight: 700;
		white-space: nowrap;
	}
	/* 검색창 */
	.search-box {
		width: 600px;          /* 검색창 고정폭 */
		max-width: 50vw;       /* 화면에 따라 자연스러운 축소 */
		position: relative;
	}
	.search-box input {
		width: 100%;
		padding: 10px 40px 10px 15px;
		background: #6c6c6c;
		border-radius: 20px;
		border: none;
		outline: none;
		color: #fff;
		font-size: 14px;
	}
	.right-menu {
    	display: flex;
    	flex-direction: row;  /* ★ 강제로 가로 정렬 */
    	align-items: center;
    	gap: 30px;            /* 요소 사이 여백 */
    	white-space: nowrap;
	}
	.right-menu div {
	    font-size: 17px;
	    cursor: pointer;
	}
	.right-menu a {
    	color: white;
    	text-decoration: none;
	}
	.right-menu a:hover {
		text-decoration: underline; /* 선택: 마우스 올리면 밑줄 */
	}
	
	/* 여기서부터는 사진들 나열하는 css */
	h2 {
        margin-bottom: 30px;
    }
    .category {
        margin-bottom: 40px;
        text-align: center;
    }
    .category h3 {
        margin-bottom: 10px;
    }
    /* 가로 스크롤 영역 + 중앙 스냅 */
	.horizontal-list {
    	display: flex;
    	overflow-x: auto;
    	gap: 15px;
    	padding: 10px 0;

    	width: calc(5 * 150px + 4 * 15px + 36px);  /* 카드 5개(150px) + 간격 4개(15px) */
    	margin: 0 auto;                    /* 가운데 정렬 */

    	scrollbar-width: none;         /* Firefox */
    	scroll-snap-type: x mandatory; /* 가로 방향 스냅 */
    	scroll-padding-inline: 50%;    /* 중앙 기준으로 스냅 */
	}
    .horizontal-list::-webkit-scrollbar {
        display: none;                 /* Chrome, Safari */
    }
    .item {
        flex-shrink: 0;
        text-align: center;
        cursor: pointer;
        position: relative;
        padding: 4px;
        overflow: visible;

        scroll-snap-align: center;     /* 각 아이템이 중앙에 맞게 */
    }
    .item input[type="radio"] {
        position: absolute;
        opacity: 0;  /* 라디오 숨기기 */
    }
    .item-img, .ban-img {
    width: 150px;		/* 이에 맞는 horizontal-list의 width를 바꾼다. */
    height: 150px;
    border-radius: 10px;
    background: #eee;
    object-fit: cover;
    object-position: center;
	}
    /* 선택된 항목 테두리 강조 */
    .item input[type="radio"]:checked + img {
        outline: 4px solid #ff5050;
    }
    .submit-btn {
        padding: 10px 20px;
        font-size: 16px;
        border: none;
        border-radius: 8px;
        background: #333;
        color: #fff;
        cursor: pointer;
    }
    .submit-btn:hover {
        background: #555;
    }
    .finish-wrap {
    	width: 100%;
    	display: flex;
    	justify-content: center;
    	margin-top: 30px;
	}
</style>
</head>
<body>
	<div class="navbar">
		<!-- 왼쪽 그룹: 로고 + 검색창 -->
		<div class="left-group">
			<div class="logo">Fit in</div>
		</div>
		<!-- 중앙 그룹: user 이름 출력 -->
		<p>
			<%= userName %> 님, 환영합니다!
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</p>
		<!-- 오른쪽 그룹: 찜 / 설정 -->
		<div class="right-menu">
    		<div class="wishlist">
        		<a href="bookmark/see_marking.jsp">찜 ⭐</a>    <!-- 즐겨찾기 -->
    		</div>
    		<div class="settings">
        		<a href="charge_money/how_much_charge.jsp">충전 💵</a>    <!-- 돈 충전 -->
    		</div>
    		<div class="settings">
        		<a href="etc/setting.jsp">설정 🛠</a>    <!-- 설정 {회원탈퇴, ... } -->
    		</div>
		</div>
	</div>
	
	<!-- 사진들 나열 -->
	<form action="clothes_buy/clothes_details.jsp" method="post">
    <!-- ============ 상의 ============ -->
<div class="category">
    <h3>상의</h3>
    <div class="horizontal-list">

        <!-- 선택 안함(첫 번째 라디오 버튼) -->
        <label class="item">
            <input type="radio" name="top" value="none" checked>
            <img src="../images/ban_mark.png" class="ban-img">
        </label>

        <% 
            for (Map<String, Integer> item : topList) {
                int num = item.get("product_number");      // 예: 1001
                String product_number = "p" + num;
                String imgPath = "../images/top/" + product_number + "." + extension;
        %>
            <label class="item">
                <input type="radio" name="top" value="<%= product_number %>">
                <img src="<%= imgPath %>" class="item-img">
            </label>
        <% 
            } 
        %>

    </div>
</div>
    <!-- ============ 하의 ============ -->
<div class="category">
    <h3>하의</h3>
    <div class="horizontal-list">

        <!-- 선택 안함 -->
        <label class="item">
            <input type="radio" name="bottom" value="none" checked>
            <img src="../images/ban_mark.png" class="ban-img">
        </label>

        <% 
            for (Map<String, Integer> item : bottomList) {
                int num = item.get("product_number");
                String product_number = "p" + num;
                String imgPath = "../images/bottom/" + product_number + "." + extension;
        %>
            <label class="item">
                <input type="radio" name="bottom" value="<%= product_number %>">
                <img src="<%= imgPath %>" class="item-img">
            </label>
        <% 
            } 
        %>

    </div>
</div>
    <!-- ============ 신발 ============ -->
<div class="category">
    <h3>신발</h3>
    <div class="horizontal-list">

        <!-- 선택 안함 -->
        <label class="item">
            <input type="radio" name="shoes" value="none" checked>
            <img src="../images/ban_mark.png" class="ban-img">
        </label>

        <% 
            for (Map<String, Integer> item : shoesList) {
                int num = item.get("product_number");
                String product_number = "p" + num;
                String imgPath = "../images/shoes/" + product_number + "." + extension;
        %>
            <label class="item">
                <input type="radio" name="shoes" value="<%= product_number %>">
                <img src="<%= imgPath %>" class="item-img">
            </label>
        <% 
            } 
        %>

    </div>
</div>

    <div class="finish-wrap">
    	<button type="submit" class="submit-btn">선택 완료</button>
	</div>
</form>

	<!-- 선택된 카드가 항상 중앙에 오도록 하는 스크립트 -->
	<script>
		document.addEventListener('DOMContentLoaded', function () {
    		const radios = document.querySelectorAll('.item input[type="radio"]');
    		radios.forEach(function (radio) {
    	    	radio.addEventListener('change', function (e) {
	            	const label = e.target.closest('.item');

        	    	// 선택된 아이템을 가로 중앙으로 스크롤
    	        	label.scrollIntoView({
	                	behavior: 'smooth',
            	    	block: 'nearest',
        	        	inline: 'center'
        	    	});
    	    	});
	    	});
		});
	</script>
</body>
</html>