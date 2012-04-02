Crafty.c "asteroid",
    init: ->
        this.origin "center"

        this.attr
            x: Crafty.math.randomInt(Crafty.viewport.width/2 - 100, Crafty.viewport.width/2 + 100), #give it random positions, rotation and speed
            y: Crafty.math.randomInt(Crafty.viewport.height/2 - 100, Crafty.viewport.height/2 + 100),
            xspeed: Crafty.math.randomInt(1, 5),
            yspeed: Crafty.math.randomInt(1, 5),
            rspeed: Crafty.math.randomInt(-5, 5),
            movementLengthFrames: 0

        .bind "EnterFrame", ->
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
