javascript:(function(){
  navigator.clipboard.readText().then(function(text){
    alert("クリップボードの文字数: " + text.length + "\n\n内容:\n" + text);
  }).catch(function(err){
    alert("クリップボードの読み取りに失敗しました: " + err);
  });
})();

