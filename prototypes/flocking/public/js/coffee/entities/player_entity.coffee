define ["cs!coffee/components/sheep"], () ->
    class PlayerEntity
        constructor: (@asteroidCount = 0, @lastCount = 0) ->
            @entity = Crafty.e("2D, Canvas, ship, Controls, Collision")
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

                                    this.destroy()
                            )


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
                    if @asteroidCount <= 0
                        @initRocks(@lastCount, @lastCount * 2)
                )

        #function to fill the screen with asteroids by a random amount
        initRocks: (lower, upper) ->
            rocks = Crafty.math.randomInt(lower, upper)
            @asteroidCount = rocks
            @lastCount = rocks


            Crafty.orderedSheepX = []
            Crafty.orderedSheepY = []
            Crafty.sortedInsertion = @sortedInsertion
            for i in [0..rocks]
                sheep = Crafty.e("2D, DOM, small, Collision, sheep")
                @sortedInsertion Crafty.orderedSheepX, sheep, "x"
                @sortedInsertion Crafty.orderedSheepY, sheep, "y"
            
            myarr = [{x:0},{x:1},{x:2},{x:3},{x:4},{x:5},{x:6}]
            console.log @sortedInsertion myarr, {x:0.5}, "x", true
            console.log @sortedInsertion myarr, {x:4.5}, "x", true
            myarr = [{x:3},{x:5},{x:6}]
            console.log @sortedInsertion myarr, {x:3.5}, "x", true
            console.log @sortedInsertion myarr, {x:5.5}, "x", true
            console.log @sortedInsertion myarr, {x:6.5}, "x", true
            console.log "blah blah"
            


        printArray: (arr) ->
            console.log "-----------"
            for i in [0..arr.length-1]
                console.log i, arr[i].x
            console.log "-----------"
            return

        sortedInsertion: (arr, element, property, justIndex) ->
            if arr.length == 0 and not justIndex
                arr.push element
                return
            imin = 0
            imax = arr.length-1
            imid = 0
            while imax > imin
                imid = (imax+imin)>>1
                p = arr[imid]
                if element[property] > p[property]
                    imin = imid+1
                else if element[property] < p[property]
                    imax = imid-1
                else
                    break

            # find out which index to return
            return imin if justIndex

            targetIndex = if arr[imin]["x"] < element["x"] then imin+1 else imin
            arr[targetIndex...targetIndex] = [element]

                
                

