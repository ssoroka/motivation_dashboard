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

Date.prototype.setISO8601 = function (string) {
    var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
        "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
        "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
    var d = string.match(new RegExp(regexp));

    var offset = 0;
    var date = new Date(d[1], 0, 1);

    if (d[3]) { date.setMonth(d[3] - 1); }
    if (d[5]) { date.setDate(d[5]); }
    if (d[7]) { date.setHours(d[7]); }
    if (d[8]) { date.setMinutes(d[8]); }
    if (d[10]) { date.setSeconds(d[10]); }
    if (d[12]) { date.setMilliseconds(Number("0." + d[12]) * 1000); }
    if (d[14]) {
        offset = (Number(d[16]) * 60) + Number(d[17]);
        offset *= ((d[15] == '-') ? 1 : -1);
    }

    offset -= date.getTimezoneOffset();
    time = (Number(date) + (offset * 60 * 1000));
    this.setTime(Number(time));
}

function parse_date(date_str) {
  var date = new Date();
  date.setISO8601(date_str);
  return date;
}

function prepend_zeros(min) {
  var m = ('' + min)
  if (m.length < 2) {
    m = '0' + m
  }
  return m;
}

function short_date(date) {
  return month_name(date.getMonth()) + ' ' + date.getDate() + ', ' + date.getHours() + ':' + prepend_zeros(date.getMinutes());
}

function host() {
  return _(window.location.href.match(/^https?\:\/\/([\w\.]+)(?:\:\d+)?\//)).last();
}