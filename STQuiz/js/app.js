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

    const selectedExam =
        localStorage.getItem(
            "selectedExam"
        );

    const fileName =
        selectedExam ??
        "ST2025_AM2";

    const response =
        await fetch(
            `data/${fileName}.json`
        );

    if (!response.ok) {
        throw new Error(
            "JSONファイルが読み込めません。"
        );
    }

    quizData =
        await response.json();

}


