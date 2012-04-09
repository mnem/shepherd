class SheepEntity
    constructor: ->
        @entity = Crafty.e("2D, DOM, SheepImage, Collision, WiredHitBox")
        @init()

    init: ->
        #@entity.origin "center"
        console.log @entity
        @entity.attr
            x: Crafty.viewport.width / 2
            y: Crafty.viewport.height / 2
        @entity.collision new Crafty.circle @entity._w/2, @entity._h/2, 20
        # @entity.bind('EnterFrame', => @update() )

    update: ->
        colliding_sheep = @entity.hit('SheepImage')
