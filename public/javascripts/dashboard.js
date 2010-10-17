$(document).ready(function() {
  process_widgets();
  $('.widgets').masonry({animate: true, itemSelector: '.widget', columnWidth:340});
  if ($('.widget').size() < 3) {
    add_new_widget_widget();
  }
  
  $('#modify_dashboard_toggle').click(function(){
    $('.delete_widget').toggle();
  })
  
});

function process_widgets() {
  if (window.widgets){
    formatted_widgets = pre_process_widgets();
    _(widgets).each(function(w) {
      // if widget already exists, update it
      if (_($('#widget_' + w.id)).any()) {
        update_widget(w);
      } else {
        // otherwise create widget
        create_widget(w);
      }
    });
  } else {
    log("no widgets. :-S");
  }
}

function create_widget(widget) {
  tmpl = widget_templates[widget.widget_type];
  log(tmpl);
  if (tmpl) {
    var html = $(Mustache.to_html(tmpl, widget));
    html.hide();
    $('#dashboard .widgets').append(html);
    $('#widget_' + widget.id).fadeIn(1000).append(generate_destroy_link(widget.id));
  }else{
    log('Template Missing');
  }
}

function update_widget(widget) {
  log('implement me');
}

function add_new_widget_widget() {
  tmpl = widget_templates['add_new_widget'];
  if (tmpl) {
    var html = $(Mustache.to_html(tmpl, {id: 0, widget_type: 'add_new_widget', widget_size: 1}));
    html.hide();
    $('#dashboard .widgets').append(html);
    $('.widgets').masonry();
    $('#widget_0').fadeIn(1000);
  }
}

function pre_process_widgets() {
  return _(widgets).map(function(widget) {
    if (widget.config.report_type == 'unread_messages_table') {
      switch(widget.widget_type){
        case 'table':
          rows = _(widget.data.rows).map(function(row_hash) {
            var row = row_hash.row;
            var date = new Date(row.shift());
            row.unshift(short_date(date));
            return row;
          })
          widget.rows = rows;
          return widget;
        default:
          return widget;
      }
    } else {
      return widget;
    }
  });
}

function generate_destroy_link(widget_id){
  return "<a href='/widgets/" + widget_id + "' style='display: none;' data-method='delete' class='delete_widget'>X</a>";
}
