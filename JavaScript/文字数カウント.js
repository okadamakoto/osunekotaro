javascript:(function(){
  navigator.clipboard.readText().then(function(text){
    alert("�N���b�v�{�[�h�̕�����: " + text.length + "\n\n���e:\n" + text);
  }).catch(function(err){
    alert("�N���b�v�{�[�h�̓ǂݎ��Ɏ��s���܂���: " + err);
  });
})();

