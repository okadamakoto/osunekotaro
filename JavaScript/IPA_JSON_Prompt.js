javascript:(async()=>{const p=await fetch('https://okadamakoto.github.io/osunekotaro/IPA_Prompt.txt').then(r=>r.text());const c=await navigator.clipboard.readText();await navigator.clipboard.writeText(p+'\n\n'+c);alert('JSON生成プロンプトを付加してクリップボードへコピーしました');})();

