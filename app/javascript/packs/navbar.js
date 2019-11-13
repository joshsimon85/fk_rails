$(function() {
  const $NAVBAR = $('#nav');
  const $NAVBARALT = $('#navbarNavAltMarkup');
  const $SIGNOUTBTN = $('#sign-out-button');
  const $TOGGLER = $('.navbar-toggler');

  const navbar = {
    changeSignOutState: function(e) {
      if ($NAVBARALT.hasClass('show')) {
        $SIGNOUTBTN.finish().delay(500).fadeToggle('slow');
      } else {
        $SIGNOUTBTN.finish().hide();
      }
    },
    bindEvents: function() {
      $TOGGLER.on('click', this.changeSignOutState.bind(this));
    },
    init: function() {
      this.bindEvents();
    }
  };

  navbar.init();
});
