class this.RelationsEditorRenderer
  constructor: (@editor) ->
    @template = $('#relations-list-item-tpl').text()
    @container = $('#relations-list')
    @blank_template = $('#relations-list-blank-tpl').text()
    @bind_events()

  on_remove: (@on_remove_callback) ->

  render: ->
    html = @editor.repo.relations.map (relation) =>
      @render_relation(relation)

    html = @blank_template unless html.length
    @container.html(html)

  # private

  bind_events: ->
    @container.on 'click', '.remove-relation > a', (e) =>
      e.preventDefault();
      parent = $(e.currentTarget).closest('.relations-list-item')

      synset1_id = parent.data('synset1')
      synset2_id = parent.data('synset2')

      @on_remove_callback(synset1_id, synset2_id)

  render_relation: (relation) ->
    data = @render_data(relation)
    relation_title = @relation_title(relation.relation_type, data.reverse)

    Mustache.render @template,
      synset1: data.synset1,
      synset2: data.synset2,
      relation_title: relation_title

  render_data: (relation) ->
    synset1 = @editor.synsetControls[0].get(relation.synset1_id)

    if synset1
      synset2 = @editor.synsetControls[1].get(relation.synset2_id)
      reverse = false
    else
      synset1 = @editor.synsetControls[1].get(relation.synset1_id)
      synset2 = @editor.synsetControls[0].get(relation.synset2_id)
      reverse = true

    synset1: synset1
    synset2: synset2
    reverse: reverse

  relation_title: (type, reverse) ->
    buttons = $("#relation-buttons > a[data-type=#{type}]")

    return buttons.text() unless buttons.length > 1

    if reverse
      buttons = buttons.filter("[data-reverse]")
    else
      buttons = buttons.filter(":not([data-reverse])")

    buttons.text()
