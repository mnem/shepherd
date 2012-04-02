Crafty.scene "main", ->
    Crafty.background "url('images/bg.png')"

    # score display
    score = Crafty.e("2D, DOM, Text")
        .text("Score: 0")
        .attr(
            x: Crafty.viewport.width - 300,
            y: Crafty.viewport.height - 50,
            w: 200,
            h: 50)
        .css(color: "#fff")

    # player entity
    player = Crafty.e("2D, Canvas, ship, Controls, Collision")
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
        ).bind("KeyUp", (e) ->
            #on key up, set the move booleans to false
            if e.keyCode == Crafty.keys.RIGHT_ARROW
                this.move.direction &= ~this.move.right
            else if e.keyCode == Crafty.keys.LEFT_ARROW
                this.move.direction &= ~this.move.left
            else if e.keyCode == Crafty.keys.UP_ARROW
                this.move.direction &= ~this.move.up
            else if e.keyCode == Crafty.keys.DOWN_ARROW
                this.move.direction &= ~this.move.down
        ).bind("EnterFrame", ->
            #acceleration and movement vector
            vx = Math.sin(this._rotation * Math.PI / 180) * 0.3
            vy = Math.cos(this._rotation * Math.PI / 180) * 0.3
            vx = 1.5
            vy = 1.5
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
            if asteroidCount <= 0
                initRocks(lastCount, lastCount * 2)
        )

    # keep a count of asteroids
    asteroidCount = 0
    lastCount = 0

    #Asteroid component
    Crafty.c("asteroid",
        init: ->
            this.origin("center")
            this.attr(
                x: Crafty.math.randomInt(Crafty.viewport.width/2 - 100, Crafty.viewport.width/2 + 100), #give it random positions, rotation and speed
                y: Crafty.math.randomInt(Crafty.viewport.height/2 - 100, Crafty.viewport.height/2 + 100),
                xspeed: Crafty.math.randomInt(1, 5),
                yspeed: Crafty.math.randomInt(1, 5),
                rspeed: Crafty.math.randomInt(-5, 5),
                movementLengthFrames: 0
            ).bind("EnterFrame", ->
                #this.x += this.xspeed
                #this.y += this.yspeed
                #this.rotation += this.rspeed

                sheep = Crafty("asteroid")
                xds = 0
                yds = 0
                tooClose = false
                for i in [0..sheep.length - 1]
                    mm = Crafty(sheep[i])
                    #console.log("yeh")
                    #console.log( this, mm)
                    if(mm[0] == this[0])
                        #console.log ("the same "+i)
                        continue

                    #var distance = Crafty.math.distance(this.x, mm.x, this.y, mm.y)
                    dx = this.x - mm.x
                    dy = this.y - mm.y
                    distance = Math.sqrt(dx * dx + dy * dy)
                    #console.log("distance "+distance)
                    if(distance < 50)
                        #console.log("too close")
                        vx = this.x - mm.x
                        vy = this.y - mm.y
                        #normalising the vector
                        vx = vx / distance
                        vy = vy / distance
                        xds += vx
                        yds += vy
                        tooClose = true
                        this.movementLengthFrames = 0

                if(tooClose)
                    this.xspeed = xds
                    this.yspeed = yds

                if (!tooClose && this.movementLengthFrames == 0)
                    this.xspeed = 0
                    this.yspeed = 0

                    if (Crafty.math.randomInt(1, 100) > 99)
                        this.movementLengthFrames = Crafty.math.randomInt(50, 300)
                        this.xspeed = Crafty.math.randomInt(-1, 1)
                        this.yspeed = Crafty.math.randomInt(-1, 1)

                this.x += this.xspeed
                this.y += this.yspeed
                if(this.movementLengthFrames > 0)
                    this.movementLengthFrames = this.movementLengthFrames - 1

                if(this._x > Crafty.viewport.width)
                    this.x = -64

                if(this._x < -64)
                    this.x =  Crafty.viewport.width

                if(this._y > Crafty.viewport.height)
                    this.y = -64

                if(this._y < -64)
                    this.y = Crafty.viewport.height
            )
    )

    #function to fill the screen with asteroids by a random amount
    initRocks = (lower, upper) ->
        rocks = Crafty.math.randomInt(lower, upper)
        asteroidCount = rocks
        lastCount = rocks

        for i in [0..rocks]
            Crafty.e("2D, DOM, small, Collision, asteroid")
    #first level has between 1 and 10 asteroids
    initRocks(60, 60)



















