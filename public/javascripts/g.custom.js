Raphael.fn.drawGrid = function (x, y, w, h, wv, hv, color) {
    color = color || "#000";
    var path = ["M", Math.round(x) + .5, Math.round(y) + .5, "L", Math.round(x + w) + .5, Math.round(y) + .5, Math.round(x + w) + .5, Math.round(y + h) + .5, Math.round(x) + .5, Math.round(y + h) + .5, Math.round(x) + .5, Math.round(y) + .5],
        rowHeight = h / hv,
        columnWidth = w / wv;
    for (var i = 1; i < hv; i++) {
        path = path.concat(["M", Math.round(x) + .5, Math.round(y + i * rowHeight) + .5, "H", Math.round(x + w) + .5]);
    }
    for (i = 1; i < wv; i++) {
        path = path.concat(["M", Math.round(x + i * columnWidth) + .5, Math.round(y) + .5, "V", Math.round(y + h) + .5]);
    }
    return this.path(path.join(",")).attr({stroke: color});
};

$(document).ready(function() {
  $('.widget_line').each(function() {
    var self = $(this);
    setup_line_chart({height: self.height(), width: self.width(), id: self.attr('id'), widget: self});
  });
});

function setup_line_chart(opts) {
  var r = Raphael(opts.id);
  
  // rewrite default Raphael colors
  Raphael.fn.g.colors = [];
  var yellow = .1333;
  var red = 0;
  var green = .2;
  var blue = .6;
  var purple = .75;
  var orange = .05;
  var hues = [red, blue, green, yellow, purple, orange];
  for (var i = 0; i < 10; i++) {
      if (i < hues.length) {
          Raphael.fn.g.colors.push("hsb(" + hues[i] + ", 1, 1)");
      } else {
          Raphael.fn.g.colors.push("hsb(" + hues[i - hues.length] + ", 1, .5)");
      }
  }
  
  // fonts...
  r.g.txtattr.font = '14px "Helvetica Neue",Helvetica,"Arial Unicode MS",Arial,sans-serif';
  r.g.txtattr.stroke = '#999';
  r.g.txtattr.fill = '#999';
  
  // generate 3 random arrays
  var x = [], y = [], y2 = [], y3 = [];
  for (var i = 0; i < 10; i++) {
      x[i] = i * 10;
      y[i] = (y[i - 1] || 30) + (Math.random() * 15) - 7.5;
      y2[i] = (y2[i - 1] || 15) + (Math.random() * 15) - 7.5;
      y3[i] = (y3[i - 1] || 0) + (Math.random() * 15) - 7.5;
  }
  
  // title
  r.g.text((opts.width / 2) + 10, 10, "title");

  
  // draw a grid
  var x_offset = 15,
      y_offset = 0;
  r.drawGrid(x_offset, y_offset, opts.width - x_offset, opts.height - y_offset, 24, 10, "#333");
  
  // draw the chart
  var chart = r.g.linechart(x_offset, y_offset, opts.width - x_offset, opts.height - y_offset, x, [y, y2], {shade: true, width: 4, smooth: true, symbol: 'o', symbolWidth: 1.5, symbolFill:'#000', axis: "0 0 1 1", stroke:'#fff'});
  chart.lines[0].attr({width: 1});
  chart.axis.attr({stroke: '#fff'});
  // chart.axis.txtattr.color = '#fff';
  
}