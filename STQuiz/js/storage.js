/*
========================================
LocalStorage キー
========================================
*/

const STORAGE_KEY = "STQuizHistory";

/*
========================================
初期化
========================================
*/

function initializeStorage() {

    const history =
        localStorage.getItem(STORAGE_KEY);

    if (!history) {

        localStorage.setItem(
            STORAGE_KEY,
            JSON.stringify({})
        );
    }
}

/*
========================================
履歴取得
========================================
*/

function getHistory() {

    const history =
        localStorage.getItem(STORAGE_KEY);

    if (!history) {
        return {};
    }

    return JSON.parse(history);
}

/*
========================================
履歴保存
========================================
*/

function saveHistory(history) {

    localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify(history)
    );
}

/*
========================================
回答結果保存
========================================
*/

function saveAnswerResult(
    questionId,
    isCorrect
) {

    const history =
        getHistory();

    if (!history[questionId]) {

        history[questionId] = {

            questionId: questionId,

            attemptCount: 0,

            correctCount: 0,

            incorrectCount: 0,

            lastCorrect: false,

            lastAnsweredAt: null
        };
    }

    history[questionId].attemptCount++;

    if (isCorrect) {

        history[questionId].correctCount++;
    }
    else {

        history[questionId].incorrectCount++;
    }

    history[questionId].lastCorrect =
        isCorrect;

    history[questionId].lastAnsweredAt =
        new Date().toISOString();

    saveHistory(history);
}

/*
========================================
問題履歴取得
========================================
*/

function getQuestionHistory(
    questionId
) {

    const history =
        getHistory();

    return (
        history[questionId] ??
        null
    );
}

/*
========================================
正答率取得
========================================
*/

function getAccuracyRate(
    questionId
) {

    const item =
        getQuestionHistory(
            questionId
        );

    if (!item) {
        return 0;
    }

    if (
        item.attemptCount === 0
    ) {
        return 0;
    }

    return Math.round(
        item.correctCount /
        item.attemptCount *
        100
    );
}

/*
========================================
不正解問題取得
========================================
*/

function getIncorrectQuestions() {

    const history =
        getHistory();

    const result = [];

    Object.values(history)
        .forEach(item => {

            if (
                item.lastCorrect === false
            ) {

                result.push(
                    item.questionId
                );
            }
        });

    return result;
}

/*
========================================
総学習回数取得
========================================
*/

function getTotalAttempts() {

    const history =
        getHistory();

    let total = 0;

    Object.values(history)
        .forEach(item => {

            total +=
                item.attemptCount;
        });

    return total;
}

/*
========================================
全体正答率取得
========================================
*/

function getOverallAccuracy() {

    const history =
        getHistory();

    let totalCorrect = 0;
    let totalAttempt = 0;

    Object.values(history)
        .forEach(item => {

            totalCorrect +=
                item.correctCount;

            totalAttempt +=
                item.attemptCount;
        });

    if (
        totalAttempt === 0
    ) {
        return 0;
    }

    return Math.round(
        totalCorrect /
        totalAttempt *
        100
    );
}

/*
========================================
履歴削除
========================================
*/

function clearHistory() {

    if (
        confirm(
            "学習履歴を削除しますか？"
        )
    ) {

        localStorage.removeItem(
            STORAGE_KEY
        );

        initializeStorage();

        alert(
            "学習履歴を削除しました。"
        );
    }
}
