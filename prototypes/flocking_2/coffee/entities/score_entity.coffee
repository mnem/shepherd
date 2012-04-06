class ScoreEntity
    constructor: ->
        @entity =  Crafty.e("2D, DOM, Text")
            .text("Score: 0")
            .attr(
                x: Crafty.viewport.width - 300,
                y: Crafty.viewport.height - 50,
                w: 200,
                h: 50)
            .css(color: "#fff")
