# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  colCnt = 3
  article_board = $('#article-board')

  $(window).bind 'debouncedresize', (event) =>
    article_board.isotope('reLayout')

  article_board.imagesLoaded ->
    article_board.isotope(
      itemSelector: '.article-card'
      resizable: false
    )
    article_board.css('visibility', 'visible').hide().fadeIn('slow')
