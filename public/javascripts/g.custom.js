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

function raphael_setup() {
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
  Raphael.fn.g.txtattr.font = '14px "Helvetica Neue",Helvetica,"Arial Unicode MS",Arial,sans-serif';
  Raphael.fn.g.txtattr.stroke = '#999';
  Raphael.fn.g.txtattr.fill = '#999';
}

$(document).ready(function() {
  raphael_setup();
  $('.widget_line').each(function() {
    var self = $(this);
    setup_line_chart({height: self.height(), width: self.width(), id: self.attr('id'), widget: self});
  });
});

// {
//   "widget_size":2,
//   "widget_type":"line",
//   "data":{
//     "label":"Visitors for www.xydo.com",
//     "line_labels":[
//       "Visitors Last Month","Visitors This Month"
//     ],
//     "lines":[
//       [21,19,20,11,8,15,20,35,24,21,24,21,29,23,17,16,17,15,11,27,12,13,16,19,11,10,18,18,17,16],
//       [20,15,13,21,21,19,13,10,10,16,21,14,19,16,14,10,1]
//     ],
//     "x_type":"days",
//     "y_label":"Visitors"
//   },
//   "widget_type_id":3,
//   "position":null,
//   "config":{"report_type":"visitors"},
//   "id":11
// }
var o = null;
function setup_line_chart(opts) {
  var r = Raphael(opts.id);
  
  var widget = _(widgets).detect(function(widget) {
    return widget.id == parseInt(opts.widget.attr('data-id'));
  });
  var data = widget.data;
  if (!data) {
    log('No data found for ' + opts.id);
    return;
  }
  
  // // generate 3 random arrays
  // var x = [], y = [], y2 = [], y3 = [];
  // for (var i = 0; i < 10; i++) {
  //     x[i] = i * 10;
  //     y[i] = (y[i - 1] || 30) + (Math.random() * 15) - 7.5;
  //     y2[i] = (y2[i - 1] || 15) + (Math.random() * 15) - 7.5;
  //     y3[i] = (y3[i - 1] || 0) + (Math.random() * 15) - 7.5;
  // }
  
  // decide on x array values
  var max = _(data.lines).chain().flatten().max().value();
  var x = []
  for (i=0; i <= 30; i++) {
    _(x).push(i);
  }
  
  var x_offset = 15,
      y_offset = 10,
      x_gutter = 25,
      y_gutter = 30;

  // title
  var title = data.label || "My Line Chart";
  r.g.txtattr.font = '20px "Helvetica Neue",Helvetica,"Arial Unicode MS",Arial,sans-serif';
  r.g.text((opts.width / 2) + 1.3 * title.length, 8, title)
  r.g.txtattr.font = '14px "Helvetica Neue",Helvetica,"Arial Unicode MS",Arial,sans-serif';

  // x axis label
  var x_label = data.x_type || "x axis";
  switch(data.x_type) {
    case 'days':
      x_label = 'Day of Month'; break;
  }
  r.g.text((opts.width / 2) + 1.3 * title.length, opts.height - (x_gutter / 2), x_label);

  // y axis label
  var y_label = data.y_label || "y axis";
  r.g.text((y_gutter / 2), (opts.height / 2), y_label).rotate(90, true);

  // draw a grid
  var x_grid_offset = 10,
      y_grid_offset = 10;
  r.drawGrid(x_offset + x_gutter + x_grid_offset, //x 
    y_offset + y_grid_offset, //y
    opts.width - x_offset - x_gutter - x_grid_offset * 2, // w
    opts.height - y_offset - y_gutter - y_grid_offset * 2, //h 
    _(data.lines).chain().map(function(arr) {return arr.length}).max().value(), // wv? # of horizontal elements
    12, // hv? # of vertical elements
    "#444");
  
  // draw the chart
  var chart = r.g.linechart(x_offset + x_gutter, y_offset, opts.width - x_offset - x_gutter, opts.height - y_offset - y_gutter, x, data.lines, 
    {shade: true, width: 4, smooth: true, symbol: 'o', symbolWidth: 1.5, symbolFill:'#000', axis: "0 0 1 1", stroke:'#fff'});
    
  chart.lines[0].attr({width: 1});
  chart.axis.attr({stroke: '#fff'});
}