//= require active_admin/base

// panel toggle
$(function() {
  $('.panel').each(function() {
    $(this).find('h3').first().prepend('<span class="toggler"></span>');
  });

  $(document).on('click', '.panel .toggler', function() {
    $(this).closest('.panel').toggleClass('closed');
  });

  $(window).on('hashchange', function() {
    var $element = $(location.hash);
    if ($element.is('.panel')) $element.removeClass('closed');
  });
});

// trash toggle
$(function() {
  $(document).on('click', '.trash_can .trash_label', function() {
    $(this).closest('.trash_can').toggleClass('closed');
  });
});

// credit policy copy-to-clipboard
$(function() {
  $('.admin_credit_policies .snippet').each(function () {
    var snippet = $(this);
    snippet.on('click', function() {
      var $temp = $("<textarea>");
      $("body").append($temp);
      $temp.val($(this).data('snippet') || $(this).text()).select();
      document.execCommand("copy");
      $temp.remove();
    });
  });
});

// Blankshield
$(function() {
  // Assumes no other listeners prevent propagation.
  $('body').on('click', 'a[target=_blank]', function(event) {
    var href = $(this).attr('href');
    blankshield.open(href);
    event.preventDefault();
  });
});

// Make index rows clickable
$(function() {
  $("table.index_table tbody tr").click(function(event) {
    if (event.target.nodeName == 'A' ||
        event.target.classList.contains('clipboard-btn')) return;
    window.location.pathname += $(event.target)
      .parentsUntil('tbody').last()
      .attr('id')
      .replace(/^.*_/, '/');
  });
});

// Color HMG
$(function() {
  if (document.domain.startsWith("hmg")) {
    $("body").css("border", "blue solid 5px");
  } else if (document.domain == "localhost") {
    $("body").css("border", "green solid 5px");
  }
});

// Set href when user clicks on a tab.
$(function() {
  $('body').on('click', '.ui-tabs-anchor', function(e) {
    location.href = e.currentTarget.href.replace(/^.*#/, '#');
  });
});

// Auto-submit inputs.
$(function() {
  $('input.auto-submit').on('change', function(e) {
    e.currentTarget.form.submit();
  });
});

// Clipboard
$(function() {
  var clipboard = new Clipboard('.clipboard-btn');
});

// Charts
$(function() {
  $('[data-chart]').each(function () {
    var options = $(this).data('chart');
    if (options.smart_format == 'percentage') {
      if (!options.axis) options.axis = {};
      if (!options.axis.y) options.axis.y = {};
      if (!options.axis.y.tick) options.axis.y.tick = {};
      options.axis.y.tick.format = d3.format(',%');
    }
    var c3chart = c3.generate(options);
  });
});
