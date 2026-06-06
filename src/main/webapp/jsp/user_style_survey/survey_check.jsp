<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 로그인 사용자 id 가져오기
    String id = (String) session.getAttribute("userId");

    if (id == null) {
        // 로그인 안 된 상태라면 로그인 페이지로 보내기
        response.sendRedirect("../login_and_signup/log_in.jsp");
        return;
    }

    // 2. 설문 폼에서 넘어온 값 받기
    String heightStr = request.getParameter("height");   // 키
    String weightStr = request.getParameter("weight");   // 몸무게

    String styleFirst  = request.getParameter("style_first");
    String styleSecond = request.getParameter("style_second");

    String fitFirst    = request.getParameter("fit_first");
    String fitSecond   = request.getParameter("fit_second");

    String moodFirst   = request.getParameter("mood_first");
    String moodSecond  = request.getParameter("mood_second");

    String shoesFirst  = request.getParameter("shoes_first");
    String shoesSecond = request.getParameter("shoes_second");

    // 3. 숫자 파싱
    double height = 0.0;
    double weight = 0.0;
    boolean inputError = false;
    String msg = null;

    try {
        height = Double.parseDouble(heightStr);
        weight = Double.parseDouble(weightStr);
    } catch (Exception e) {
        inputError = true;
        msg = "키와 몸무게를 숫자로 정확히 입력해주세요.";
    }

    // 4. 태그 문자열 만들기 (중복 제거 + 순서 보존)
    Set<String> tagSet = new LinkedHashSet<String>();

    if (styleFirst != null && !styleFirst.trim().isEmpty())   tagSet.add(styleFirst.trim());
    if (styleSecond != null && !styleSecond.trim().isEmpty()) tagSet.add(styleSecond.trim());

    if (fitFirst != null && !fitFirst.trim().isEmpty())       tagSet.add(fitFirst.trim());
    if (fitSecond != null && !fitSecond.trim().isEmpty())     tagSet.add(fitSecond.trim());

    if (moodFirst != null && !moodFirst.trim().isEmpty())     tagSet.add(moodFirst.trim());
    if (moodSecond != null && !moodSecond.trim().isEmpty())   tagSet.add(moodSecond.trim());

    if (shoesFirst != null && !shoesFirst.trim().isEmpty())   tagSet.add(shoesFirst.trim());
    if (shoesSecond != null && !shoesSecond.trim().isEmpty()) tagSet.add(shoesSecond.trim());

    StringBuilder sb = new StringBuilder();
    for (String t : tagSet) {
        if (sb.length() > 0) sb.append(",");
        sb.append(t);
    }
    String preferTag = sb.toString();   // 예: "Casual,Minimal,Over,SemiOver,Monotone,Basic,Running,Sandal"

    if (!inputError && preferTag.length() == 0) {
        inputError = true;
        msg = "최소 한 개 이상의 선호 태그를 선택해주세요.";
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>설문 처리 결과</title>
<style>
  body{
    margin:0;
    font-family:'Pretendard','Nanum Gothic',sans-serif;
    background:linear-gradient(135deg,#f0f4ff,#fdfbfb);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
  }
  .card{
    background:#fff;
    padding:28px 32px;
    border-radius:18px;
    box-shadow:0 10px 22px rgba(0,0,0,.12);
    width:420px;
    max-width:100%;
    text-align:center;
  }
  h1{
    margin:0 0 10px;
    font-size:22px;
    color:#2c3e50;
  }
  p{
    margin:6px 0;
    font-size:14px;
    color:#555;
  }
  .error{
    color:#e74c3c;
    font-weight:600;
  }
  .btn{
    margin-top:18px;
    display:inline-block;
    padding:9px 16px;
    border-radius:10px;
    background:#3498db;
    color:#fff;
    text-decoration:none;
    font-size:14px;
    font-weight:600;
  }
  .btn:hover{
    background:#2980b9;
  }
</style>
</head>
<body>
<div class="card">
<%
    if (inputError) {
%>
    <h1 class="error">설문 저장 실패</h1>
    <p class="error"><%= msg %></p>
    <p>이전 페이지로 돌아가 다시 입력해주세요.</p>
    <a href="survey.jsp" class="btn">설문 다시 하기</a>
<%
    } else {
        // 5. DB 연결 및 INSERT / UPDATE
        Connection con = null;
        PreparedStatement psmt = null;

        String url = "jdbc:mysql://localhost:3306/fit_in?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String uId = "root";
        String uPw = "1234";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, uId, uPw);

            // user_info에 새로 저장하거나, 이미 있으면 업데이트
            String sql =
                "INSERT INTO user_info (id, height_cm, weight_kg, prefer_tag) " +
                "VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE " +
                "height_cm = VALUES(height_cm), " +
                "weight_kg = VALUES(weight_kg), " +
                "prefer_tag = VALUES(prefer_tag)";

            psmt = con.prepareStatement(sql);
            psmt.setString(1, id);
            psmt.setDouble(2, height);
            psmt.setDouble(3, weight);
            psmt.setString(4, preferTag);

            int result = psmt.executeUpdate();

            if (result > 0) {
%>
                <h1>설문이 저장되었습니다</h1>
                <p><strong><%= id %></strong> 님의 선호 정보를 업데이트 했습니다.</p>
                <p>이제 메인 페이지에서 맞춤 코디 추천을 받아보실 수 있습니다.</p>
                <a href="../home.jsp" class="btn">메인 페이지로 이동</a>
<%
            } else {
%>
                <h1 class="error">설문 저장 실패</h1>
                <p class="error">데이터베이스 업데이트에 실패했습니다.</p>
                <a href="survey.jsp" class="btn">설문 다시 하기</a>
<%
            }

        } catch (Exception e) {
            e.printStackTrace();
%>
            <h1 class="error">오류가 발생했습니다</h1>
            <p class="error"><%= e.getMessage() %></p>
            <a href="survey.jsp" class="btn">설문 다시 하기</a>
<%
        } finally {
            try { if (psmt != null) psmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
%>
</div>
</body>
</html>
