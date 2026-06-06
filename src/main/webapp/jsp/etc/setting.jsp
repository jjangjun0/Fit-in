<%@ page import="java.sql.*" %>
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
    String birth = "";
    String email = "";

    // user_info
    String height = "";
    String weight = "";
    String prefer = "";

    String sql1 = "SELECT name, birth, email FROM user_list WHERE id = ?";
    String sql2 = "SELECT height_cm, weight_kg, prefer_tag FROM user_info WHERE id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(url, uId, uPw)) {

            // user_list 조회
            try (PreparedStatement ptmt = con.prepareStatement(sql1)) {
                ptmt.setString(1, userId);

                try (ResultSet rs = ptmt.executeQuery()) {
                    if (rs.next()) {
                        name = rs.getString("name");
                        birth = rs.getString("birth");
                        email = rs.getString("email");
                    }
                }
            }

            // user_info 조회
            try (PreparedStatement ptmt2 = con.prepareStatement(sql2)) {
                ptmt2.setString(1, userId);

                try (ResultSet rs2 = ptmt2.executeQuery()) {
                    if (rs2.next()) {
                        height = rs2.getString("height_cm");
                        weight = rs2.getString("weight_kg");
                        prefer = rs2.getString("prefer_tag");

                        if (prefer == null || prefer.trim().equals(""))
                            prefer = "등록된 선호 태그 없음";
                    } else {
                        height = "-";
                        weight = "-";
                        prefer = "설문조사를 진행하지 않았습니다.";
                    }
                }
            }
        }

    } catch (Exception e) {
        System.out.println("오류 발생: " + e.getMessage());
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설정</title>

<style>
    body {
        margin:0;
        font-family:'Pretendard','Nanum Gothic',sans-serif;
        background:linear-gradient(135deg, #f0f0f0, #d9d9d9, #c5c5c5);
        min-height:100vh;
        display:flex;
        align-items:center;
        justify-content:center;
    }
    .card{
        width: 500px;
        background:#fff;
        border-radius:18px;
        box-shadow:0 12px 24px rgba(0,0,0,.18);
        padding:30px 35px;
    }
    .home-btn {
    	background:#3498db;
    	color:white;
    	font-size:13px;
    	padding:6px 12px;
    	border:none;
    	border-radius:6px;
    	cursor:pointer;
	}
	.home-btn:hover {
    	background:#217dbb;
	}
    .section-title{
        font-size:18px;
        font-weight:700;
        margin-bottom:12px;
        color:#2c3e50;
    }
    .info-list .row{
        margin-bottom:8px;
        font-size:15px;
    }
    .label{
        font-weight:600;
        margin-right:4px;
    }
    .divider{
        height:1px;
        background:#dcdde1;
        margin:25px 0;
    }
    .btn-gray{
        background:#ecf0f1;
        border:1px solid #bdc3c7;
        padding:10px 14px;
        border-radius:7px;
        cursor:pointer;
        font-size:14px;
        font-weight:600;
        width:100%;
        text-align:center;
    }
    .btn-gray:hover{
        background:#dfe6e9;
    }
    .logout-btn{
        background:#d63031;
        color:white;
        font-size:13px;
        padding:6px 12px;
        border:none;
        border-radius:6px;
        cursor:pointer;
    }
    .logout-btn:hover{
        background:#b22222;
    }
    .btn-three{
        display:flex;
        gap:10px;
        margin-top:15px;
    }
</style>
</head>
<body>

<div class="card">
	<!-- 상단 네비 버튼 -->
<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
    
    <!-- 메인화면으로 -->
    <form action="../home.jsp" method="post" style="display:inline;">
        <button class="home-btn">메인화면으로</button>
    </form>

    <!-- 로그아웃 -->
    <form action="../login_and_signup/log_out.jsp" method="post" style="display:inline;">
        <button class="logout-btn">로그아웃</button>
    </form>
</div>

	<div class="divider"></div>

	<!-- 사용자 정보 -->
	<div class="section-title">사용자 정보</div>

	<div class="info-list">
		<div class="row"><span class="label">아이디 :</span> <span><%= userId %></span></div>
		<div class="row"><span class="label">이름 :</span> <span><%= name %></span></div>
		<div class="row"><span class="label">생년월일 :</span> <span><%= birth %></span></div>
		<div class="row"><span class="label">이메일 :</span> <span><%= email %></span></div>
	</div>

	<!-- 버튼 3개 (비번 변경 / 회원정보 수정 / 탈퇴) -->
	<div class="btn-three">

		<!-- 비밀번호 변경 -->
		<form id="pwForm" action="pw_check.jsp" method="post" style="flex:1;">
			<input type="hidden" name="input_pw" id="input_pw">
			<button type="button" onclick="pwCheck()" class="btn-gray">비밀번호 변경</button>
		</form>

		<!-- 회원정보 수정 -->
		<form action="in_user_list_update.jsp" method="post" style="flex:1;">
			<button type="submit" class="btn-gray">회원정보 수정</button>
		</form>

		<!-- 회원탈퇴 -->
		<form action="../etc/delete_user.jsp" method="post" style="flex:1;">
			<button type="submit" class="btn-gray">회원탈퇴</button>
		</form>

	</div>
	
	<div class="divider"></div>

	<!-- 설문조사 결과 -->
	<div class="section-title">설문조사 결과</div>

	<div class="info-list">
		<div class="row"><span class="label">키 :</span> <span><%= height %> cm</span></div>
		<div class="row"><span class="label">몸무게 :</span> <span><%= weight %> kg</span></div>
		<div class="row"><span class="label">선호태그 :</span> <span><%= prefer %></span></div>
	</div>

	<!-- 설문조사 다시하기 -->
	<div style="text-align:center; margin-top:25px;">
		<form action="../user_style_survey/survey.jsp" method="post">
			<button type="submit" class="btn-gray">설문조사 다시하기</button>
		</form>
	</div>
</div>

	<script>
		function pwCheck() {
    		let pw = prompt("현재 비밀번호를 입력하세요:");
    		if (pw === null)
    			return;
    		document.getElementById("input_pw").value = pw;
    		document.getElementById("pwForm").submit();
		}
	</script>

</body>
</html>
