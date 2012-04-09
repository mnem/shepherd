class FieldEntity
    constructor: ->
        @entity = Crafty.e('TiledLevel').tiledLevel('levels/field.json')
        @init()

    init: -> @
