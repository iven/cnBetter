# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  page = 1
  loading = false
  article_board = $('#article-board')

  need_loading = ->
    return $(window).scrollTop() > $(document).height() - $(window).height() - 200

  $(window).bind 'debouncedresize', (event) =>
    article_board.isotope 'reLayout'

  article_board.imagesLoaded ->
    article_board.isotope
      itemSelector: '.article-card'
      resizable: false
    article_board.css('visibility', 'visible').hide().fadeIn('slow')

  $(window).scroll ->
    if need_loading() and not loading
      loading = true
      $('#loading-layer').show()
      page++
      $.ajax
        url: '/?page=' + page
        type: 'get'
        dataType: 'script'
        context: this
        complete: ->
          $('#loading-layer').fadeOut(1000)
          loading = false
