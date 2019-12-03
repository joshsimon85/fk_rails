const $backdrop = $('.backdrop');
const $lightBoxContainer = $('#lightbox-image')

const lightbox = {
  showModal:function(e) {
    let $thumbnail = $(e.currentTarget);
    let $fullSizeImage = $thumbnail.next('.full-size-image').find('img');
    let source = $fullSizeImage.attr('src');
    // deal with caption
    $lightBoxContainer.find('img').prop('src', source);
    $backdrop.show();
    $lightBoxContainer.show();
  },
  closeModal: function(e) {
    e.preventDefault();
    $backdrop.hide();
    $lightBoxContainer.hide();
  },
  bindEvents: function() {
    $('.thumbnail').on('click', this.showModal.bind(this));
    ($lightBoxContainer, $backdrop).on('click', this.closeModal.bind(this));
  },
  init: function() {
    this.bindEvents();
  }
};

lightbox.init();
