const $backdrop = $('.backdrop');
const $lightBoxContainer = $('#lightbox-image')

const lightbox = {
  showModal:function(e) {
    let $thumbnail = $(e.currentTarget);
    let $fullSizeFigure = $thumbnail.next('.full-size-image');
    let caption = $fullSizeFigure.find('figcaption').text();
    let $fullSizeImage = $fullSizeFigure.find('img');
    let source = $fullSizeImage.attr('src');

    $lightBoxContainer.find('img').prop('src', source);
    $lightBoxContainer.find('figcaption').text(caption);
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
