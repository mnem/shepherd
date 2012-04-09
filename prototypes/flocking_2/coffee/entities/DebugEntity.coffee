class DebugEntity
    constructor: ->
        @entity = Crafty.e("DOM, debug.Framerate, Text")
        @init()

    init: ->
        @entity.bind('EnterFrame', => @update() )
        @entity.width = 200
        @entity.css(color: "#fff")

    update: ->
        @entity.text("fps:&nbsp;#{Math.round(@entity.avg_fps)}&nbsp;min:&nbsp;#{Math.round(@entity.min_fps)}&nbsp;max:&nbsp;#{Math.round(@entity.max_fps)}")
