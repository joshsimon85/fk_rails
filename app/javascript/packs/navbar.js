$(function() {
  const $NAVBAR = $('#nav');
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
        $NAVBAR.addClass('fixed-top enlarged');
        $SIGNOUTBTN.addClass('lowered');
        $('body').css('margin-top', '60px');
      } else {
        $NAVBAR.removeClass('fixed-top enlarged');
        $SIGNOUTBTN.removeClass('lowered');
        $('body').removeAttr('style');
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

  navbar.init();
});
