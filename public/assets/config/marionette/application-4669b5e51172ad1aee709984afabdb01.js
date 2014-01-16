(function() {
  (function(Backbone) {
    return _.extend(Backbone.Marionette.Application.prototype, {
      startHistory: function() {
        Backbone.history.start({
          pushState: true
        });
        return $(document).on('click', 'a[data-internal]', function(ev) {
          return ev.preventDefault();
        });
      },
      scrollTop: function() {
        return $('body,html').animate({
          scrollTop: 0
        }, 250);
      },
      setTitle: function(title) {
        return $(document).attr('title', title);
      },
      setMetaDescription: function(content) {
        $("meta[name='description']").remove();
        return $('head').append($('<meta>', {
          content: content,
          name: 'description'
        }));
      },
      setFacebookMeta: function(metaTags) {
        var tags;
        $('meta[property]').remove();
        tags = _.defaults(metaTags, {
          site_name: 'Shoes',
          type: 'game',
          url: location.href
        });
        return _.each(tags, function(value, key) {
          if ((key != null) && (value != null)) {
            return $('head').append($('<meta>', {
              content: value,
              property: "og:" + key
            }));
          }
        });
      }
    });
  })(Backbone);

}).call(this);
