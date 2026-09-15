/*
========================================
グローバル変数
========================================
*/

let quizData = null;

/*
========================================
初期処理
========================================
*/

document.addEventListener("DOMContentLoaded", initialize);

/*
========================================
初期化
========================================
*/

async function initialize() {

    try {

        await loadQuizData();

        initializeStorage();

        initializeQuiz(quizData);

    }
    catch (error) {

        console.error(error);

        alert("問題データの読込みに失敗しました。");
    }
}

/*
========================================
JSON読込み
========================================
*/

async function loadQuizData() {

    const response = await fetch("data/ST2025_AM2.json");

    if (!response.ok) {
        throw new Error(
            "JSONファイルが読み込めません。"
        );
    }

    quizData = await response.json();

    console.log(
        "問題データ読込完了",
        quizData
    );
}