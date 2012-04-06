class PlayerEntity
    constructor: (@asteroidCount = 0, @lastCount = 0) ->
        @entity = Crafty.e("2D, Canvas, ship, Controls, Collision, MoveTo")
            .moveTo(10)
            .attr(
                move:
                    left: 1,
                    right: 2,
                    up: 4,
                    down: 8,
                    direction:0,
                xspeed: 0,
                yspeed: 0,
                decay: 0.9,
                x: Crafty.viewport.width / 2,
                y: Crafty.viewport.height / 2,
                score: 0)
            .origin("center")
            .bind("KeyDown", (e) ->
                #on keydown, set the move booleans
                if e.keyCode == Crafty.keys.RIGHT_ARROW
                    this.move.direction |= this.move.right
                else if e.keyCode == Crafty.keys.LEFT_ARROW
                    this.move.direction |= this.move.left
                else if e.keyCode == Crafty.keys.UP_ARROW
                    this.move.direction |= this.move.up
                else if e.keyCode == Crafty.keys.DOWN_ARROW
                    this.move.direction |= this.move.down
                else if e.keyCode == Crafty.keys.SPACE
                    #create a bullet entity
                    Crafty.e("2D, DOM, Color, bullet")
                        .attr(
                            x: this._x,
                            y: this._y,
                            w: 2,
                            h: 5,
                            rotation: this._rotation,
                            xspeed: 20 * Math.sin(this._rotation / 57.3),
                            yspeed: 20 * Math.cos(this._rotation / 57.3))
                        .color("rgb(255, 0, 0)")
                        .bind("EnterFrame", ->
                            this.x += this.xspeed
                            this.y -= this.yspeed

                            #destroy if it goes out of bounds
                            if this._x > Crafty.viewport.width || this._x < 0 || this._y > Crafty.viewport.height || this._y < 0
                                this.destroy())
            )
            .bind("KeyUp", (e) ->
                #on key up, set the move booleans to false
                if e.keyCode == Crafty.keys.RIGHT_ARROW
                    this.move.direction &= ~this.move.right
                else if e.keyCode == Crafty.keys.LEFT_ARROW
                    this.move.direction &= ~this.move.left
                else if e.keyCode == Crafty.keys.UP_ARROW
                    this.move.direction &= ~this.move.up
                else if e.keyCode == Crafty.keys.DOWN_ARROW
                    this.move.direction &= ~this.move.down
            )
            .bind("EnterFrame", ->
                #acceleration and movement vector
                vx = 10
                vy = 10
                #if the move up is true, increment the y/xspeeds
                if this.move.direction & this.move.up
                    this.yspeed = -vy
                if this.move.direction & this.move.down
                    this.yspeed = vy
                if this.move.direction & this.move.right
                    this.xspeed = vx
                if this.move.direction & this.move.left
                    this.xspeed = -vx

                if this.move.up && !this.move.left && !this.move.right
                    #if released, slow down the ship
                    this.xspeed *= this.decay
                    this.yspeed *= this.decay

                #move the ship by the x and y speeds or movement vector
                this.x += this.xspeed
                this.y += this.yspeed
                this.xspeed = 0
                this.yspeed = 0
                #if ship goes out of bounds, put him back
                if this._x > Crafty.viewport.width
                    this.x = -64
                if this._x < -64
                    this.x =  Crafty.viewport.width
                if this._y > Crafty.viewport.height
                    this.y = -64
                if this._y < -64
                    this.y = Crafty.viewport.height

                # if all asteroids are gone, start again with more
                if @asteroidCount <= 0
                    @initRocks(@lastCount, @lastCount * 2)
            )

    #function to fill the screen with asteroids by a random amount
    initRocks: (lower, upper) ->
        rocks = Crafty.math.randomInt(lower, upper)
        @asteroidCount = rocks
        @lastCount = rocks

        for i in [0..rocks]
            Crafty.e("2D, DOM, small, Collision, asteroid")

