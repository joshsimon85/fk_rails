$(function () {
  const $overlay = $('.overlay');
  const $modal = $('.image-modal');
  const $img = $('#image');

  const imageModal = {
    handleClick: function(e) {
      e.preventDefault();
      $img.attr('src', $(e.target).attr('src'));
      $overlay.toggleClass('d-none');
      $modal.toggleClass('d-none');
    },
    closeModal: function(e) {
      e.preventDefault();
      $modal.toggleClass('d-none');
      $overlay.toggleClass('d-none');
    },
    bindEvents: function() {
      $('.thumb').on('click', this.handleClick.bind(this));
      $('#modal-close').on('click',this.closeModal.bind(this));
      $overlay.on('click',this.closeModal.bind(this));
    },
    init: function() {
      this.bindEvents();
    }
  }

  imageModal.init();
})
