$(document).ready(function() {
  process_widgets();
  $('.widgets').masonry({animate: true, itemSelector: '.widget'});
  if ($('.widget').size() < 3) {
    add_new_widget_widget();
  }
});

function process_widgets() {
  _(widgets).each(function(w) {
    // if widget already exists, update it
    if (_($('#widget_' + w.id)).any()) {
      update_widget(w);
    } else {
      // otherwise create widget
      create_widget(w);
    }
  });
}

function create_widget(widget) {
  tmpl = widget_templates[widget.widget_type];
  if (tmpl) {
    var html = $(Mustache.to_html(tmpl, widget));
    html.hide();
    $('#dashboard .widgets').append(html);
    $('#widget_' + widget.id).fadeIn(1000);
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