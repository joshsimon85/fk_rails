const $REMAINING = $('#characters_remaining');
const TOTAL = 150;
const EDITOR = $('#testimonial_highlight').get(0);
const $SUBMITBTN = $('input[type=submit]');
const trixCounter = {
  init: function() {
    this.bindEvents();
    this.calculateCount(EDITOR);
  },
  bindEvents: function() {
    $('trix-editor').on('trix-change', this.calculateCount.bind(this));
  },
  calculateCount: function() {
    const { editor } = EDITOR
    const string = editor.getDocument().toString()
    const characterCount = string.length - 1
    this.changeRemainingCount(characterCount)
  },
  changeRemainingCount: function(count) {
    const charsRemaining = TOTAL - count;
    $REMAINING.text('(' + charsRemaining + ' ' + this.pluralize('Character', charsRemaining) + ' Remaining)');
    this.toggleClass(charsRemaining);
  },
  pluralize: function(string, count) {
    if (count === 1 || count === -1) {
      return string;
    } else {
      return string + "s";
    }
  },
  toggleClass: function(charsRemaining) {
    if (charsRemaining >= 0) {
      $REMAINING.toggleClass('text-success', true);
      $REMAINING.toggleClass('text-danger', false);
      $SUBMITBTN.attr('disabled', false);
    } else {
      $REMAINING.toggleClass('text-success', false);
      $REMAINING.toggleClass('text-danger', true);
      $SUBMITBTN.attr('disabled', true);
    }
  }
};

trixCounter.init();
