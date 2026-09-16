/*
========================================
問題データ
========================================
*/

let questions = [];
let currentQuestionIndex = 0;
let score = 0;

/*
========================================
初期化
========================================
*/

function initializeQuiz(data) {

    questions = data.questions;

    currentQuestionIndex = 0;
    score = 0;

    bindEvents();

    showQuestion();
}

/*
========================================
イベント登録
========================================
*/

function bindEvents() {

    const answerBtn =
        document.getElementById("answerBtn");

    const nextBtn =
        document.getElementById("nextBtn");

    answerBtn.addEventListener(
        "click",
        checkAnswer
    );

    nextBtn.addEventListener(
        "click",
        nextQuestion
    );
}

/*
========================================
問題表示
========================================
*/

function showQuestion() {

    const question =
        questions[currentQuestionIndex];

    hideResult();

    document.getElementById(
        "questionNo"
    ).textContent =
        `問${question.no}`;

    document.getElementById(
        "questionText"
    ).textContent =
        question.question;

    displayQuestionImage(question);

    displaySource(question);
    
    setChoices(question);

    clearSelectedAnswer();

    disableNextButton();

}

/*
========================================
画像表示
========================================
*/

function displayQuestionImage(question) {

    const imageArea =
        document.querySelector(".image-area");

    imageArea.innerHTML = "";

    if (!question.image) {
        return;
    }

    const img =
        document.createElement("img");

    img.src = question.image;

    img.alt =
        `問${question.no}`;

    imageArea.appendChild(img);
}

/*
========================================
選択肢設定
========================================
*/

function setChoices(question) {

    document.getElementById(
        "choiceA"
    ).textContent =
        "ア　" + question.choices["ア"];

    document.getElementById(
        "choiceI"
    ).textContent =
        "イ　" + question.choices["イ"];

    document.getElementById(
        "choiceU"
    ).textContent =
        "ウ　" + question.choices["ウ"];

    document.getElementById(
        "choiceE"
    ).textContent =
        "エ　" + question.choices["エ"];
}

/*
========================================
回答判定
========================================
*/

function checkAnswer() {

    const selected =
        document.querySelector(
            'input[name="answer"]:checked'
        );

    if (!selected) {

        alert(
            "回答を選択してください。"
        );

        return;
    }

    const question =
        questions[currentQuestionIndex];

    const userAnswer =
        selected.value;

    const isCorrect =
        userAnswer === question.answer;

    if (isCorrect) {
        score++;
    }

    saveAnswerResult(
        question.id,
        isCorrect
    );

    showResult(
        question,
        userAnswer,
        isCorrect
    );

    updateScoreDisplay(
        score,
        questions.length
    );

    enableNextButton();
}

/*
========================================
次の問題
========================================
*/

function nextQuestion() {

    currentQuestionIndex++;

    if (
        currentQuestionIndex >=
        questions.length
    ) {

        finishQuiz();

        return;
    }

    showQuestion();
}

/*
========================================
終了処理
========================================
*/

function finishQuiz() {

    const main =
        document.querySelector("main");

    main.innerHTML = `
        <section class="question-area">
            <h2>学習終了</h2>

            <p>
                正解数：
                ${score}
                /
                ${questions.length}
            </p>

            <p>
                正答率：
                ${Math.round(
                    score /
                    questions.length *
                    100
                )}
                %
            </p>
        </section>
    `;
}

/*
========================================
選択状態クリア
========================================
*/

function clearSelectedAnswer() {

    const radios =
        document.querySelectorAll(
            'input[name="answer"]'
        );

    radios.forEach(
        radio => {
            radio.checked = false;
        }
    );
}

/*
========================================
ボタン制御
========================================
*/

function enableNextButton() {

    document.getElementById(
        "nextBtn"
    ).style.display =
        "inline-block";
}

function disableNextButton() {

    document.getElementById(
        "nextBtn"
    ).style.display =
        "none";
}

function displaySource(question) {

    const sourceArea =
        document.getElementById(
            "sourceArea"
        );

    let html =
        `出典：${question.source}`;

    if (question.modified) {

        html +=
            "<br>※本サイトでは学習目的のため一部表現を改変しています。";
    }

    sourceArea.innerHTML = html;
}
