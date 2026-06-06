<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>FitIn 설문조사</title>
<style>
  * { box-sizing: border-box; }

  body{
    margin:0;
    font-family:'Pretendard','Nanum Gothic',sans-serif;
    background:linear-gradient(135deg,#f0f4ff,#fdfbfb);
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
  }

  .survey-card{
    width:960px;
    max-width:100%;
    background:#fff;
    border-radius:18px;
    box-shadow:0 12px 24px rgba(0,0,0,.12);
    padding:28px 32px 32px;
  }

  h1{
    margin:0 0 4px;
    font-size:24px;
    color:#2c3e50;
  }

  .subtitle{
    margin:0 0 20px;
    font-size:13px;
    color:#7f8c8d;
  }

  .info-row{
    display:flex;
    gap:16px;
    margin-bottom:20px;
  }

  .info-field{
    flex:1;
  }

  label{
    display:block;
    margin-bottom:6px;
    font-size:13px;
    color:#34495e;
  }

  input[type="number"]{
    width:100%;
    padding:9px 10px;
    border:1px solid #dfe6e9;
    border-radius:8px;
    font-size:14px;
    outline:none;
  }

  input[type="number"]:focus{
    border-color:#3498db;
    box-shadow:0 0 0 2px rgba(52,152,219,.18);
  }

  .section{
    border-top:1px solid #ecf0f1;
    padding-top:18px;
    margin-top:16px;
  }

  .section:first-of-type{
    border-top:none;
    padding-top:0;
    margin-top:0;
  }

  .section-title{
    font-size:16px;
    font-weight:600;
    margin-bottom:4px;
    color:#2c3e50;
  }

  .section-desc{
    font-size:12px;
    color:#95a5a6;
    margin-bottom:10px;
  }

  .priority-wrap{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
  }

  .priority-col{
    flex:1;
    min-width:200px;
    border:1px solid #ecf0f1;
    border-radius:10px;
    padding:10px 12px;
  }

  .priority-label{
    font-size:13px;
    font-weight:600;
    margin-bottom:6px;
    color:#2980b9;
  }

  .option{
    display:flex;
    align-items:center;
    gap:6px;
    margin-bottom:6px;
    font-size:13px;
    cursor:pointer;
  }

  .option input{
    margin:0;
  }

  .option span{
    display:inline-block;
  }

  .option small{
    color:#7f8c8d;
    font-size:11px;
    margin-left:4px;
  }

  .btn-row{
    margin-top:22px;
    text-align:right;
  }

  .btn{
    min-width:130px;
    padding:10px 14px;
    border-radius:10px;
    border:0;
    background:#3498db;
    color:#fff;
    font-weight:600;
    font-size:14px;
    cursor:pointer;
  }

  .btn:hover{
    background:#2980b9;
  }

  .helper{
    font-size:11px;
    color:#bdc3c7;
    margin-top:4px;
  }

  @media (max-width:768px){
    .info-row{flex-direction:column;}
  }
</style>

<script>
  // sectionName: style, fit, mood, shoes
  function checkPriority(sectionName){
    const first = document.querySelector('input[name="'+sectionName+'_first"]:checked');
    const second = document.querySelector('input[name="'+sectionName+'_second"]:checked');

    if(first && second && first.value === second.value){
      alert("1순위와 2순위는 서로 다른 항목을 선택해야 합니다.");
      second.checked = false;
    }
  }
</script>
</head>
<body>
<div class="survey-card">
  <h1>FitIn 설문조사</h1>
  <p class="subtitle">사용자님의 옷 선호도를 기반으로 맞춤 코디를 추천하기 위한 설문입니다. (최초 1회 필수, 이후 마이페이지에서 수정 가능)</p>

  <form action="survey_check.jsp" method="post">
    <!-- 키 / 몸무게 -->
    <div class="info-row">
      <div class="info-field">
        <label for="height">키 (cm)</label>
        <input type="number" id="height" name="height" min="100" max="230" required placeholder="예: 170">
      </div>
      <div class="info-field">
        <label for="weight">몸무게 (kg)</label>
        <input type="number" id="weight" name="weight" min="30" max="200" required placeholder="예: 60">
      </div>
    </div>

    <!-- A. 전반적 스타일 -->
    <div class="section">
      <div class="section-title">A. 전반적 스타일 선호도</div>
      <div class="section-desc">가장 선호하는 전반적인 스타일을 선택해주세요. (1순위 1개 필수, 2순위 선택)</div>

      <div class="priority-wrap">
        <div class="priority-col">
          <div class="priority-label">1순위 (필수)</div>

          <label class="option">
            <input type="radio" name="style_first" value="Casual" required
                   onchange="checkPriority('style')">
            <span>캐주얼<small>Casual</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_first" value="Street"
                   onchange="checkPriority('style')">
            <span>스트리트<small>Street</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_first" value="Formal"
                   onchange="checkPriority('style')">
            <span>포멀<small>Formal</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_first" value="Minimal"
                   onchange="checkPriority('style')">
            <span>미니멀<small>Minimal</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_first" value="Sporty"
                   onchange="checkPriority('style')">
            <span>스포티<small>Sporty</small></span>
          </label>
        </div>

        <div class="priority-col">
          <div class="priority-label">2순위 (선택)</div>

          <label class="option">
            <input type="radio" name="style_second" value="Casual"
                   onchange="checkPriority('style')">
            <span>캐주얼<small>Casual</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_second" value="Street"
                   onchange="checkPriority('style')">
            <span>스트리트<small>Street</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_second" value="Formal"
                   onchange="checkPriority('style')">
            <span>포멀<small>Formal</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_second" value="Minimal"
                   onchange="checkPriority('style')">
            <span>미니멀<small>Minimal</small></span>
          </label>

          <label class="option">
            <input type="radio" name="style_second" value="Sporty"
                   onchange="checkPriority('style')">
            <span>스포티<small>Sporty</small></span>
          </label>
        </div>
      </div>
      <div class="helper">※ 추후 추천 알고리즘에서 1순위는 +5점, 2순위는 +3점으로 가중치가 적용됩니다.</div>
    </div>

    <!-- B. 핏 선호도 -->
    <div class="section">
      <div class="section-title">B. 핏(Fit) 선호도</div>
      <div class="section-desc">옷의 실루엣/핏에 대해 선호하는 정도를 선택해주세요.</div>

      <div class="priority-wrap">
        <div class="priority-col">
          <div class="priority-label">1순위 (필수)</div>

          <label class="option">
            <input type="radio" name="fit_first" value="Over" required
                   onchange="checkPriority('fit')">
            <span>오버핏<small>Over</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_first" value="SemiOver"
                   onchange="checkPriority('fit')">
            <span>세미오버핏<small>SemiOver</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_first" value="Regular"
                   onchange="checkPriority('fit')">
            <span>레귤러핏<small>Regular</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_first" value="Slim"
                   onchange="checkPriority('fit')">
            <span>슬림핏<small>Slim</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_first" value="Skinny"
                   onchange="checkPriority('fit')">
            <span>스키니핏<small>Skinny</small></span>
          </label>
        </div>

        <div class="priority-col">
          <div class="priority-label">2순위 (선택)</div>

          <label class="option">
            <input type="radio" name="fit_second" value="Over"
                   onchange="checkPriority('fit')">
            <span>오버핏<small>Over</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_second" value="SemiOver"
                   onchange="checkPriority('fit')">
            <span>세미오버핏<small>SemiOver</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_second" value="Regular"
                   onchange="checkPriority('fit')">
            <span>레귤러핏<small>Regular</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_second" value="Slim"
                   onchange="checkPriority('fit')">
            <span>슬림핏<small>Slim</small></span>
          </label>

          <label class="option">
            <input type="radio" name="fit_second" value="Skinny"
                   onchange="checkPriority('fit')">
            <span>스키니핏<small>Skinny</small></span>
          </label>
        </div>
      </div>
    </div>

    <!-- C. 색감/무드 선호도 -->
    <div class="section">
      <div class="section-title">C. 색감/무드 선호도</div>
      <div class="section-desc">평소 자주 입는 색감과 전체적인 무드에 대해 선택해주세요.</div>

      <div class="priority-wrap">
        <div class="priority-col">
          <div class="priority-label">1순위 (필수)</div>

          <label class="option">
            <input type="radio" name="mood_first" value="Monotone" required
                   onchange="checkPriority('mood')">
            <span>모노톤<small>Monotone</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_first" value="Vivid"
                   onchange="checkPriority('mood')">
            <span>비비드<small>Vivid</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_first" value="Pastel"
                   onchange="checkPriority('mood')">
            <span>파스텔<small>Pastel</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_first" value="Basic"
                   onchange="checkPriority('mood')">
            <span>베이직<small>Basic</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_first" value="Pattern"
                   onchange="checkPriority('mood')">
            <span>패턴<small>Pattern</small></span>
          </label>
        </div>

        <div class="priority-col">
          <div class="priority-label">2순위 (선택)</div>

          <label class="option">
            <input type="radio" name="mood_second" value="Monotone"
                   onchange="checkPriority('mood')">
            <span>모노톤<small>Monotone</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_second" value="Vivid"
                   onchange="checkPriority('mood')">
            <span>비비드<small>Vivid</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_second" value="Pastel"
                   onchange="checkPriority('mood')">
            <span>파스텔<small>Pastel</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_second" value="Basic"
                   onchange="checkPriority('mood')">
            <span>베이직<small>Basic</small></span>
          </label>

          <label class="option">
            <input type="radio" name="mood_second" value="Pattern"
                   onchange="checkPriority('mood')">
            <span>패턴<small>Pattern</small></span>
          </label>
        </div>
      </div>
    </div>

    <!-- D. 신발 선호도 -->
    <div class="section">
      <div class="section-title">D. 신발 선호도</div>
      <div class="section-desc">평소 가장 자주 신는 신발 종류를 선택해주세요.</div>

      <div class="priority-wrap">
        <div class="priority-col">
          <div class="priority-label">1순위 (필수)</div>

          <label class="option">
            <input type="radio" name="shoes_first" value="Running" required
                   onchange="checkPriority('shoes')">
            <span>러닝화<small>Running</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_first" value="Hightop"
                   onchange="checkPriority('shoes')">
            <span>하이탑워커<small>Hightop</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_first" value="SlipOn"
                   onchange="checkPriority('shoes')">
            <span>슬립온<small>SlipOn</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_first" value="Boots"
                   onchange="checkPriority('shoes')">
            <span>부츠<small>Boots</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_first" value="Sandal"
                   onchange="checkPriority('shoes')">
            <span>샌들<small>Sandal</small></span>
          </label>
        </div>

        <div class="priority-col">
          <div class="priority-label">2순위 (선택)</div>

          <label class="option">
            <input type="radio" name="shoes_second" value="Running"
                   onchange="checkPriority('shoes')">
            <span>러닝화<small>Running</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_second" value="Hightop"
                   onchange="checkPriority('shoes')">
            <span>하이탑워커<small>Hightop</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_second" value="SlipOn"
                   onchange="checkPriority('shoes')">
            <span>슬립온<small>SlipOn</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_second" value="Boots"
                   onchange="checkPriority('shoes')">
            <span>부츠<small>Boots</small></span>
          </label>

          <label class="option">
            <input type="radio" name="shoes_second" value="Sandal"
                   onchange="checkPriority('shoes')">
            <span>샌들<small>Sandal</small></span>
          </label>
        </div>
      </div>
    </div>

    <div class="btn-row">
      <button type="submit" class="btn">설문 제출</button>
    </div>
  </form>
</div>
</body>
</html>
