article_board = $('#article-board')
new_elements = $("<%= j render(@articles) %>")

article_board.append(new_elements)

article_board.imagesLoaded ->
  article_board.isotope('appended', new_elements)
