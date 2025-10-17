javascript:(function(){
  var url = location.href;
  var cleanedUrl = url.replace(/&.*$/, '');
  window.open(cleanedUrl, '_blank');
})();
