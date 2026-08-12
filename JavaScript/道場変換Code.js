javascript:(async()=>{
try{

    // 1. 選択テキストを取得
    let t = (
        window.getSelection
            ? window.getSelection().toString()
            : document.selection
                ? document.selection.createRange().text
                : ""
    ).trim();

    // 2. 選択テキストが無い場合はクリップボード取得
    if(!t){
        try{
            t = (await navigator.clipboard.readText()).trim();
        }catch{}
    }

    if(!t){
        return alert("テキストが取得できません");
    }

    // 全角数字→半角数字
    t = t.replace(
        /[０-９]/g,
        s => String.fromCharCode(s.charCodeAt(0) - 65248)
    );

    // 例：令和6年春期 問1
    const m = t.match(
        /(令和|平成)(元|\d+)年(春期|秋期)\s*問(\d+)/
    );

    if(!m){
        return alert("認識できません: " + t);
    }

    const y =
        m[2] === "元"
            ? "01"
            : String(parseInt(m[2],10)).padStart(2,"0");

    const s =
        m[3] === "春期"
            ? "haru"
            : "aki";

    const q = parseInt(m[4],10);

    window.open(
        `https://www.ap-siken.com/kakomon/${y}_${s}/q${q}.html`,
        "_blank"
    );

}catch(e){
    alert(e);
}
})();
