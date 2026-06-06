<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입금 페이지</title>

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
        background: #fff;
        border-radius: 18px;
        box-shadow: 0 12px 24px rgba(0,0,0,.18);
        padding: 35px;
    }

    /* 상단 네비 */
    .top-nav {
        display: flex;
        justify-content: flex-start;
        align-items: center;
        margin-bottom: 25px;
    }

    .home-btn {
        background: #3498db;
        color: white;
        font-size: 13px;
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }
    .home-btn:hover {
        background: #217dbb;
    }

    .divider {
        height: 1px;
        background: #dcdde1;
        margin: 20px 0;
    }

    /* 본문 타이틀 */
    .title {
        font-size: 20px;
        font-weight: 700;
        margin-bottom: 15px;
        color: #2c3e50;
        text-align: center;
    }

    /* Custom Number Input UI (text input + arrows) */
    .money-wrapper {
        display: flex;
        align-items: center;
        border: 1px solid #bdc3c7;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 15px;
    }

    #moneyInput {
        flex: 1;
        padding: 12px;
        font-size: 15px;
        border: none;
        outline: none;
        box-sizing: border-box;
    }

    .arrows {
        width: 35px;
        background: #ecf0f1;
        display: flex;
        flex-direction: column;
        text-align: center;
        justify-content: center;
        cursor: pointer;
        user-select: none;
    }

    .arrow-up, .arrow-down {
        padding: 5px 0;
        font-size: 13px;
    }

    .arrow-up:hover, .arrow-down:hover {
        background: #dfe6e9;
    }

    /* 제출 버튼 */
    .submit-btn {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        border: none;
        background: #27ae60;
        color: white;
        font-size: 15px;
        cursor: pointer;
        margin-top: 5px;
        font-weight: 600;
    }
    .submit-btn:hover {
        background: #1e874b;
    }
</style>
</head>

<body>

<div class="card">

    <!-- 상단 네비 -->
    <div class="top-nav">
        <form action="how_much_charge.jsp" method="post">
            <button class="home-btn">뒤로가기</button>
        </form>
    </div>

    <div class="divider"></div>

    <!-- 본문 -->
    <div class="title">얼마를 입금하시겠습니까?</div>

    <form action="update_bank.jsp" method="post">
        
        <!-- Custom Money Input -->
        <div class="money-wrapper">
            <input type="text" id="moneyInput" name="depositAmount" placeholder="예: 50,000" autocomplete="off" required>
            
            <div class="arrows">
                <div class="arrow-up">▲</div>
                <div class="arrow-down">▼</div>
            </div>
        </div>

        <button type="submit" class="submit-btn">입금하기</button>
    </form>

</div>

<script>
    const input = document.getElementById("moneyInput");

    // 입력 시 쉼표 자동 추가
    input.addEventListener("input", function() {
        let raw = input.value.replace(/,/g, "");
        if (!isNaN(raw) && raw !== "") {
            input.value = Number(raw).toLocaleString();
        } else {
            input.value = "";
        }
    });

    // 증가 / 감소 버튼 기능
    document.querySelector(".arrow-up").onclick = function() {
        let value = input.value.replace(/,/g, "") || "0";
        input.value = (Number(value) + 1000).toLocaleString();
    };

    document.querySelector(".arrow-down").onclick = function() {
        let value = input.value.replace(/,/g, "") || "0";
        let newVal = Math.max(Number(value) - 1000, 0);
        input.value = newVal.toLocaleString();
    };
</script>

</body>
</html>
