Crafty.c "sheep",
    init: ->
        this.origin "center"

        this.attr
            x: Crafty.math.randomInt(Crafty.viewport.width/2 - 200, Crafty.viewport.width/2 + 200 ),
            y: Crafty.math.randomInt(200, Crafty.viewport.height - 200),
            xspeed: Crafty.math.randomInt(1, 5),
            yspeed: Crafty.math.randomInt(1, 5),
            rspeed: Crafty.math.randomInt(-5, 5),
            movementLengthFrames: 0,
            direction: new Crafty.math.Vector2D(Crafty.math.randomInt(-1,1), Crafty.math.randomInt(-1,1))
        .bind "EnterFrame", ->
            #this.x += this.xspeed
            #this.y += this.yspeed
            #this.rotation += this.rspeed


            minDistance = 70
            element =
                x: this.x - minDistance
                y: this.y - minDistance



            
            lowIndex = Crafty.sortedInsertion Crafty.orderedSheepX, element, "x", true
            element.x = this.x + minDistance
            highIndex = Crafty.sortedInsertion Crafty.orderedSheepX, element, "x", true

            sheepX = Crafty.orderedSheepX[lowIndex..highIndex]


            lowIndex = Crafty.sortedInsertion Crafty.orderedSheepY, element, "y", true
            element.y = this.y + minDistance
            highIndex = Crafty.sortedInsertion Crafty.orderedSheepY, element, "y", true
            sheepY = Crafty.orderedSheepY[lowIndex..highIndex]



            xds = 0
            yds = 0
            tooClose = false
            avgDirection = new Crafty.math.Vector2D(0, 0)
            distantSheep = 0
            thisVector = new Crafty.math.Vector2D(this.x, this.y)
            for i in [0..sheepX.length - 1]
               
                if sheepY.indexOf(sheepX[i]) == -1 then continue

                mm = sheepX[i]
                if(mm[0] == this[0])
                    continue
                if Math.abs(this.direction.angleBetween(mm.direction)) > 1.57
                    continue
               

                mmVector = new Crafty.math.Vector2D(mm.x, mm.y)
                distance = thisVector.distance(mmVector)
                avgDirection.add(mm.direction)
                #avgDirection.add(mmVector)
                if(distance < 40)
                    vx = this.x - mm.x
                    vy = this.y - mm.y
                    #normalising the vector
                    vx = vx / distance
                    vy = vy / distance
                    mmVector.x = vx
                    mmVector.y = vy
                    avgDirection.add(mmVector)



            avgDirection.normalize()
            this.direction.x = avgDirection.x
            this.direction.y = avgDirection.y
            this.xspeed = this.direction.x
            this.yspeed = this.direction.y
            zeroV = new Crafty.math.Vector2D(1,0)
            this.rotation = this.direction.angleBetween(zeroV) * 180 / Math.PI

            ###
            if(tooClose)
                this.xspeed = xds
                this.yspeed = yds

            ###
            ###
            if (!tooClose && this.movementLengthFrames == 0)
                this.xspeed = 0
                this.yspeed = 0

                if (Crafty.math.randomInt(1, 1000) > 999)
                    this.movementLengthFrames = Crafty.math.randomInt(50, 300)
                    this.xspeed = Crafty.math.randomInt(-1, 1)
                    this.yspeed = Crafty.math.randomInt(-1, 1)
                    this.direction.x = this.xspeed
                    this.direction.y = this.yspeed
            ###

            this.x += this.xspeed
            this.y += this.yspeed

            if(this.x > Crafty.viewport.width-50)
                this.x = 0
            if(this.x < 0)
                this.x = Crafty.viewport.width-50 
            if(this.y > Crafty.viewport.height-50)
                this.y = 0
            if(this.y < 0)
                this.y = Crafty.viewport.height-50

            # remove sheep from ordered arrays
            # need to insert it again
            # console.log Crafty.orderedSheepX, Crafty.orderedSheepY
            currentIndex = Crafty.orderedSheepX.indexOf(this)
            Crafty.orderedSheepX[currentIndex..currentIndex] = []
            currentIndex = Crafty.orderedSheepY.indexOf(this)
            Crafty.orderedSheepY[currentIndex..currentIndex] = []
            Crafty.sortedInsertion Crafty.orderedSheepX, this, "x"
            Crafty.sortedInsertion Crafty.orderedSheepY, this, "y"

					
