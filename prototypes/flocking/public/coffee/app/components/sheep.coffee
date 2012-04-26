define ->
    Crafty.c "sheep",
        init: ->
            this.origin "center"

            this.attr
                x: Crafty.math.randomInt(Crafty.viewport.width/2 - 200, Crafty.viewport.width/2 + 200 ),
                y: Crafty.math.randomInt(200, Crafty.viewport.height - 200),
                maxspeed: 1,
                movementLengthFrames: 0,
                direction: new Crafty.math.Vector2D(Crafty.math.randomInt(-1,1), Crafty.math.randomInt(-1,1))
            .bind "EnterFrame", ->
                #this.x += this.xspeed
                #this.y += this.yspeed
                #this.rotation += this.rspeed


                minDistance = 40
                element =
                    x: this.x - minDistance
                    y: this.y - minDistance

                
                lowIndex = Crafty.sortedInsertion Crafty.orderedSheepX, element, "x", true, false
                element.x = this.x + minDistance
                highIndex = Crafty.sortedInsertion Crafty.orderedSheepX, element, "x", true, true
                if lowIndex == -1 or highIndex == -1
                    sheepX = []
                else
                    sheepX = Crafty.orderedSheepX[lowIndex..highIndex]
                #console.log "X", sheepX

                lowIndex = Crafty.sortedInsertion Crafty.orderedSheepY, element, "y", true, false
                element.y = this.y + minDistance
                highIndex = Crafty.sortedInsertion Crafty.orderedSheepY, element, "y", true, true
                if lowIndex == -1 or highIndex == -1
                    sheepY = []
                else
                    sheepY = Crafty.orderedSheepY[lowIndex..highIndex]
                #console.log "Y", sheepY


                xds = 0
                yds = 0
                avgDirection = new Crafty.math.Vector2D(0, 0)
                avgPosition = new Crafty.math.Vector2D(0, 0)
                count = 0
                countPosition = 0
                
                distantSheep = 0
                thisVector = new Crafty.math.Vector2D(this.x, this.y)
                for i in [0..sheepX.length - 1]
                   
                    if sheepY.indexOf(sheepX[i]) == -1 then continue

                    mm = sheepX[i]
                    if(mm[0] == this[0])
                        continue

                    a = new Crafty.math.Vector2D(mm.x - this.x, mm.y-this.y)
                    a.normalize()
                    if Math.abs(this.direction.angleBetween(a)) > 1.57
                        continue
                   

                    mmVector = new Crafty.math.Vector2D(mm.x, mm.y)
                    distance = thisVector.distance(mmVector)
                    # add position
                    avgPosition.add(mmVector)
                    countPosition += 1
                    # add direction
                    avgDirection.add(mm.direction)
                    count += 1
                    if(distance < 40)
                        vx = this.x - mm.x
                        vy = this.y - mm.y
                        # add repulsion
                        avgDirection.add(new Crafty.math.Vector2D(vx,vy))
                        count += 1


                if countPosition > 0
                    avgPosition.x /= countPosition
                    avgPosition.y /= countPosition
                    avgPosition.x -= this.x
                    avgPosition.y -= this.y
                    avgDirection.add avgPosition
                    count += 1



                if count > 0
                    avgDirection.x /= count
                    avgDirection.y /= count
                    avgDirection.normalize()
                    this.direction.x = avgDirection.x
                    this.direction.y = avgDirection.y



                this.xspeed = this.direction.x
                this.yspeed = this.direction.y

                #zeroV = new Crafty.math.Vector2D(1,0)
                #this.rotation = this.direction.angleBetween(zeroV) * 180 / Math.PI

                gotoX = this.x + this.xspeed
                gotoY = this.y + this.yspeed

                rightBound = Crafty.viewport.width-50
                bottomBound = Crafty.viewport.height-50
                if(gotoX > rightBound)
                    gotoX = rightBound - (gotoX - rightBound)
                    this.direction.x *= -1
                if(gotoX < 0)
                    gotoX *= -1
                    this.direction.x *= -1
                if(gotoY > bottomBound)
                    gotoY = bottomBound - (gotoY - bottomBound)
                    this.direction.y *= -1
                if(gotoY < 0)
                    gotoY *= -1
                    this.direction.y *= -1

                this.x = gotoX
                this.y = gotoY

                # remove sheep from ordered arrays
                # need to insert it again
                # console.log Crafty.orderedSheepX, Crafty.orderedSheepY
                currentIndex = Crafty.orderedSheepX.indexOf(this)
                Crafty.orderedSheepX[currentIndex..currentIndex] = []
                currentIndex = Crafty.orderedSheepY.indexOf(this)
                Crafty.orderedSheepY[currentIndex..currentIndex] = []
                Crafty.sortedInsertion Crafty.orderedSheepX, this, "x"
                Crafty.sortedInsertion Crafty.orderedSheepY, this, "y"


                a = new Crafty.math.Vector2D(1,0)
                this.rotation = 270 - Crafty.math.radToDeg(this.direction.angleBetween(a))

                        
