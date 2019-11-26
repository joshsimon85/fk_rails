$(function() {
  const $NAVBAR = $('#landing-nav');
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
      if ($(window).scrollTop() > 500) {
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
  const $CTAP = $('.cta > p');

  const animations = {
    attachFade: function() {
      $CTAP.delay(300).fadeIn(1200);
    },
    animateChevron: function() {
      let self = this;
      $CHEVRON.delay(600).animate({
        'padding-top': '-=45px'
      }, 500, function() {
        $CHEVRON.delay(1).animate({
          'padding-top': '+=45px'
        }, 500, function() {
          $CHEVRON.delay(1).animate({
            'padding-top': '-=20px'
          }, 500, function() {
            $CHEVRON.delay(1).animate({
              'padding-top': '+=20px'
            }, 500, function() {
              self.animateChevron();
            });
          });
        });
      });
    },
    bindEvents: function() {
      this.animateChevron();
      this.attachFade();
    },
    init: function() {
      this.bindEvents();
    }

  };

  animations.init();
  navbar.init();
});
