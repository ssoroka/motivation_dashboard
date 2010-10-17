function log(text) {
  if (window.console) {
    console.log(text);
  }
}

// wrap me up in a common date object or extend date or something.
function month_name(num) {
  switch(num){
    case 0: return 'Jan';
    case 1: return 'Feb';
    case 2: return 'Mar';
    case 3: return 'Apr';
    case 4: return 'May';
    case 5: return 'Jun';
    case 6: return 'Jul';
    case 7: return 'Aug';
    case 8: return 'Sep';
    case 9: return 'Oct';
    case 10:return 'Nov';
    case 11:return 'Dec';
  }
}

function short_date(date) {
  return month_name(date.getMonth()) + ' ' + date.getDate() + ', ' + date.getHours() + ':' + date.getMinutes();
}

function host() {
  return _(window.location.href.match(/^https?\:\/\/([\w\.]+)(?:\:\d+)?\//)).last();
}