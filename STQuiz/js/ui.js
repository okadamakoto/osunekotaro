/*
========================================
結果エリア非表示
========================================
*/

function hideResult() {

    document.getElementById(
        "resultArea"
    ).style.display = "none";
}

/*
========================================
結果表示
========================================
*/

function showResult(
    question,
    userAnswer,
    isCorrect
) {

    const resultArea =
        document.getElementById(
            "resultArea"
        );

    /*
    ------------------------------
    正誤判定
    ------------------------------
    */

    const judge =
        document.getElementById(
            "judge"
        );

    if (isCorrect) {

        judge.textContent =
            "〇 正解";

        judge.className =
            "correct";

    } else {

        judge.textContent =
            `× 不正解（あなたの回答：${userAnswer}）`;

        judge.className =
            "incorrect";
    }

    /*
    ------------------------------
    正解
    ------------------------------
    */

    document.getElementById(
        "correctAnswer"
    ).textContent =
        `${question.answer}　${question.answerText}`;

    /*
    ------------------------------
    解説
    ------------------------------
    */

    document.getElementById(
        "explanation"
    ).innerHTML =
        formatText(
            question.explanation
        );

    /*
    ------------------------------
    誤答解説
    ------------------------------
    */

    renderWrongChoices(
        question
    );

    /*
    ------------------------------
    カテゴリ
    ------------------------------
    */

    document.getElementById(
        "category"
    ).textContent =
        question.category ?? "";

    /*
    ------------------------------
    キーワード
    ------------------------------
    */

    renderKeywords(
        question.keywords
    );

    /*
    ------------------------------
    シラバス
    ------------------------------
    */

    renderSyllabus(
        question.syllabus
    );

    /*
    ------------------------------
    暗記ポイント
    ------------------------------
    */

    document.getElementById(
        "memorize"
    ).textContent =
        question.memorize ?? "";

    /*
    ------------------------------
    表示
    ------------------------------
    */

    resultArea.style.display =
        "block";

    resultArea.scrollIntoView({
        behavior: "smooth"
    });
}

/*
========================================
誤答解説表示
========================================
*/

function renderWrongChoices(
    question
) {

    let area =
        document.getElementById(
            "wrongChoices"
        );

    if (!area) {

        area =
            document.createElement(
                "div"
            );

        area.id =
            "wrongChoices";

        document.getElementById(
            "explanation"
        ).insertAdjacentElement(
            "afterend",
            area
        );
    }

    const wrongChoices =
        question.wrongChoices;

    if (!wrongChoices) {

        area.innerHTML = "";

        return;
    }

    let html =
        "<hr>" +
        "<h4>誤答選択肢の解説</h4>";

    Object.keys(
        wrongChoices
    ).forEach(choice => {

        html += `
            <p>
                <strong>${choice}</strong><br>
                ${wrongChoices[choice]}
            </p>
        `;
    });

    area.innerHTML = html;
}

/*
========================================
キーワード表示
========================================
*/

function renderKeywords(
    keywords
) {

    const target =
        document.getElementById(
            "keywords"
        );

    target.innerHTML = "";

    if (
        !keywords ||
        keywords.length === 0
    ) {
        return;
    }

    keywords.forEach(
        keyword => {

            const span =
                document.createElement(
                    "span"
                );

            span.className =
                "keyword-tag";

            span.textContent =
                keyword;

            target.appendChild(
                span
            );
        }
    );
}

/*
========================================
シラバス表示
========================================
*/

function renderSyllabus(
    syllabusList
) {

    const target =
        document.getElementById(
            "syllabus"
        );

    target.innerHTML = "";

    if (
        !syllabusList ||
        syllabusList.length === 0
    ) {
        return;
    }

    syllabusList.forEach(
        syllabus => {

            const span =
                document.createElement(
                    "span"
                );

            span.className =
                "syllabus-tag";

            span.textContent =
                syllabus;

            target.appendChild(
                span
            );
        }
    );
}

/*
========================================
スコア表示
========================================
*/

function updateScoreDisplay(
    score,
    total
) {

    const scoreArea =
        document.getElementById(
            "scoreArea"
        );

    const rate =
        total === 0
            ? 0
            : Math.round(
                score /
                total *
                100
            );

    scoreArea.innerHTML = `
        正解数：${score} / ${total}
        （${rate}%）
    `;
}

/*
========================================
改行対応
========================================
*/

function formatText(
    text
) {

    if (!text) {
        return "";
    }

    return text.replace(
        /\n/g,
        "<br>"
    );
}
