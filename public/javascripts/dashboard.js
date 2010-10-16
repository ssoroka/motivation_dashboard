$(document).ready(function() {
  process_widgets();
});

function process_widgets() {
  _(widgets).each(function(w) {
    log(w.id);
    
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
  log('implement me')
}

