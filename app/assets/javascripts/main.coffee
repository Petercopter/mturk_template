$ ->
  # MAKE SURE THIS WORKS WITH TOUCH

  maintain_column_sync = (category) ->
    $('.artist', "[data-category='#{category}']").each (index) ->
      $('.artist-number', this).text(index + 1)
      $('.form-control', this).each ->
        $(this).attr(name: $(this).attr('name').slice(0, -1) + (index + 1))

  $('.artists')
    .on 'focus', '.artist-name', (event) ->
      artist = $(this).closest('.artist')
      $(this).autocomplete
        minLength: 2
        source: (request, response) ->
          $.getJSON '//metamuse.org/api/search.json?type=name&term=' + encodeURIComponent(request.term), (results) ->
            response results
        select: (event, ui) ->
          $('.artist-id', artist).val ui.item.id
          $('.artist-wiki', artist).val ui.item.wiki
        focus: (event, ui) ->
          $('.artist-id', artist).val ui.item.id
          $('.artist-wiki', artist).val ui.item.wiki

    .on 'keyup', '.artist-name', ->
      if $(this).val() == ''
        artist = $(this).closest('.artist')
        $('.artist-id', artist).val('').trigger('change')

    .on 'change', ':input', ->
      artists = $(this).closest('.artists')
      if $('.artist-name', artists).val() != '' && $('.artist-wiki', artists).val() != ''
        $('.glyphicon-ok', artists).removeClass('hidden')
        $('.song-title', $(this).closest('.panel-body')).removeAttr('disabled')
      else
        $('.glyphicon-ok', artists).addClass('hidden')
        $('.song-title', $(this).closest('.panel-body')).attr('disabled', true)

    .on 'click', '.add-artist', ->
      category = $(this).closest('.artists').data('category')
      new_artist = $('.hidden .artist').clone()
      new_artist.find('.form-control').each ->
        $(this).attr(name: category + $(this).attr('name'))
      new_artist.appendTo($(this).closest('.artists'))
      maintain_column_sync(category)
      false

    .on 'click', '.remove-artist', ->
      category = $(this).closest('.artists').data('category')
      $(this).closest('.artist').remove()
      maintain_column_sync(category)
      false

  $('.song')
    .on 'keyup', ':input', ->
      song = $(this).closest('.song')
      if $('.song-title', song).val() != '' && $('.song-genre', song).val() != '' && $('.song-album-title', song).val() != '' && $('.song-release-year', song).val() != ''
        $('.glyphicon-ok', song).removeClass('hidden')
      else
        $('.glyphicon-ok', song).addClass('hidden')

    .on 'keyup', '#cover-song-title', (event) ->
      search_str = $.trim($(this).val().toLowerCase())
      artists = $('.artist-name', $(this).closest('.panel-body')).map( (i, v) ->
        $(this).val()
      ).toArray().join(' ')

      if search_str.length > 3
        $.getJSON '//metamuse.org/api/search.json?type=song&term=' + encodeURIComponent(artists + ' ' + search_str), (results) ->
          matches = $.grep results, (result) ->
            result.label.toLowerCase() == search_str
          if matches.length == 0
            $('.cover-ok').removeClass('hidden')
            $('.cover-exists-warning').addClass('hidden')
          else
            $('.cover-ok').addClass('hidden')
            $('.cover-exists-warning').removeClass('hidden')

    .on 'change', '#cover-song-title', ->
      $('#original-song-title').val($(this).val()) if $('#original-song-title').val() == ''

    .on 'focus', '#original-song-title', (event) ->
      song = $(this).closest('.song')
      artists = $('.artist-name', $(this).closest('.panel-body')).map( (i, v) ->
        $(this).val()
      ).toArray().join(' ')

      $(this).autocomplete
        minLength: 2
        source: (request, response) ->
          $.getJSON '//metamuse.org/api/search.json?type=song&term=' + encodeURIComponent(artists + ' ' + request.term), (results) ->
            response results
        select: (event, ui) ->
          $('.song-id', song).val ui.item.id
          $('.song-genre-id', song).val ui.item.genre_id
          $('.song-release-year', song).val ui.item.release_year
        focus: (event, ui) ->
          $('.song-id', song).val ui.item.id
          $('.song-genre-id', song).val ui.item.genre_id
          $('.song-release-year', song).val ui.item.release_year
