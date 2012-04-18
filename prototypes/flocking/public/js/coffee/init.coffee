define ->
    init: ->
        Crafty.init()
        Crafty.canvas.init()
        Crafty.load ["images/sprite.png", "images/bg.png"], ->
            # splice the spritemap
            Crafty.sprite(64, "images/sprite.png",
                ship: [0,0],
                big: [1,0],
                medium: [2,0],
                small: [3,0])

            # start the main scene when loaded
            Crafty.scene("main")
