class this.RelationEditorRelationsRepo
  constructor: ->
    @relations = []

  load_for: (word1, word2) ->
    @clear()
    @load_relations(word1, word2)

  relation_for: (synset1, synset2) ->
    relation = @select_for(synset1, synset2)
    relation ||= @select_for(synset2, synset1, true)

  update_relation: (synset1, synset2, relation, reverse) ->
    @remove_relation(synset1, synset2)

    if reverse
      first = synset2
      second = synset1
    else
      first = synset1
      second = synset2

    @relations.push({
      synset1_id: first,
      synset2_id: second,
      relation_type: relation
    })

  #private

  remove_relation: (synset1, synset2) ->
    synset1 = synset1.toString()
    synset2 = synset2.toString()

    @relations = @relations.filter (relation) ->
      relation1_id = relation.synset1_id.toString()
      relation2_id = relation.synset2_id.toString()

      return !(
        (relation1_id == synset1 && relation2_id == synset2) ||
        (relation1_id == synset2 && relation2_id == synset1)
      )

  clear: ->
    @relations = []

  load_relations: (word1, word2) ->
    $.get 'relations_editor/relations.json',
      word1: word1,
      word2: word2,
      (data) =>
        @relations = data

  select_for: (synset1, synset2, reverse = false) ->
    relations = @relations.filter (relation) ->
      return relation.synset1_id.toString() == synset1 &&
        relation.synset2_id.toString() == synset2

    relation = relations[0]
    return unless relation
    @decorate_relation(relation, reverse)

  decorate_relation: (relation, reverse) ->
    synset1: relation.synset1_id
    synset2: relation.synset2_id
    relation_type: relation.relation_type
    reverse: reverse

