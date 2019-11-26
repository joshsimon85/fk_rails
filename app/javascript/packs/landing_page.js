$(function() {
  const $NAVBAR = $('#landing_nav');
  const $NAVBARALT = $('#navbarNavAltMarkup');
  const $SIGNOUTBTN = $('#sign-out-button');
  const $TOGGLER = $('.navbar-toggler');

  const navbar = {
    changeSignOutState: function(e) {
      if ($TOGGLER.attr('aria-expanded') === 'true') {
        $SIGNOUTBTN.finish().delay(500).fadeToggle('slow');
      } else {
        $SIGNOUTBTN.finish().hide();
      }
    },
    changeBtnState: function() {
      if ($(window).width() >= 992) {
        $SIGNOUTBTN.finish().show();
      } else if ($(window).width() < 992 && ($TOGGLER.attr('aria-expanded') !== 'true')) {
        $SIGNOUTBTN.finish().show();
      } else {
        $SIGNOUTBTN.finish().hide();
      }
    },
    changeNavBarState: function() {
      if ($(window).scrollTop() > 55) {
        $NAVBAR.addClass('sticky-top');
      } else {
        $NAVBAR.removeClass('sticky-top');
      }
    },
    bindEvents: function() {
      $TOGGLER.on('click', this.changeSignOutState.bind(this));
      $(window).on('resize', this.changeBtnState.bind(this));
      $(window).on('scroll', this.changeNavBarState.bind(this));
    },
    init: function() {
      this.bindEvents();
    }
  };

  const $CHEVRON = $('#callout i');

  const animations = {
    animateChevron: function() {
      let self = this;
      $CHEVRON.delay(600).animate({
        'padding-bottom': '+=50px'
      }, 500, function() {
        $CHEVRON.delay(1).animate({
          'padding-bottom': '-=50px'
        }, 500, function() {
          $CHEVRON.delay(1).animate({
            'padding-bottom': '+=25px'
          }, 500, function() {
            $CHEVRON.delay(1).animate({
              'padding-bottom': '-=25px'
            }, 500, function() {
              self.animateChevron();
            });
          });
        });
      });
    },
    bindEvents: function() {
      this.animateChevron();
    },
    init: function() {
      this.bindEvents();
    }

  };

  animations.init();
  navbar.init();
});
