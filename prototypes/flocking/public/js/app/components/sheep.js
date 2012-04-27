(function() {

  define(function() {
    return Crafty.c("sheep", {
      init: function() {
        this.origin("center");
        return this.attr({
          x: Crafty.math.randomInt(Crafty.viewport.width / 2 - 200, Crafty.viewport.width / 2 + 200),
          y: Crafty.math.randomInt(200, Crafty.viewport.height - 200),
          maxspeed: 1,
          movementLengthFrames: 0,
          direction: new Crafty.math.Vector2D(Crafty.math.randomInt(-1, 1), Crafty.math.randomInt(-1, 1))
        }).bind("EnterFrame", function() {
          var a, avgDirection, avgPosition, bottomBound, count, countPosition, currentIndex, distance, distantSheep, element, gotoX, gotoY, highIndex, i, lowIndex, minDistance, mm, mmVector, rightBound, sheepX, sheepY, thisVector, vx, vy, xds, yds, _ref, _ref2, _ref3;
          minDistance = Crafty.minDistance + 10;
          element = {
            x: this.x - minDistance,
            y: this.y - minDistance
          };
          lowIndex = Crafty.sortedInsertion(Crafty.orderedSheepX, element, "x", true, false);
          element.x = this.x + minDistance;
          highIndex = Crafty.sortedInsertion(Crafty.orderedSheepX, element, "x", true, true);
          if (lowIndex === -1 || highIndex === -1) {
            sheepX = [];
          } else {
            sheepX = Crafty.orderedSheepX.slice(lowIndex, highIndex + 1 || 9e9);
          }
          lowIndex = Crafty.sortedInsertion(Crafty.orderedSheepY, element, "y", true, false);
          element.y = this.y + minDistance;
          highIndex = Crafty.sortedInsertion(Crafty.orderedSheepY, element, "y", true, true);
          if (lowIndex === -1 || highIndex === -1) {
            sheepY = [];
          } else {
            sheepY = Crafty.orderedSheepY.slice(lowIndex, highIndex + 1 || 9e9);
          }
          xds = 0;
          yds = 0;
          avgDirection = new Crafty.math.Vector2D(0, 0);
          avgPosition = new Crafty.math.Vector2D(0, 0);
          count = 0;
          countPosition = 0;
          distantSheep = 0;
          thisVector = new Crafty.math.Vector2D(this.x, this.y);
          for (i = 0, _ref = sheepX.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
            if (sheepY.indexOf(sheepX[i]) === -1) continue;
            mm = sheepX[i];
            if (mm[0] === this[0]) continue;
            a = new Crafty.math.Vector2D(mm.x - this.x, mm.y - this.y);
            a.normalize();
            if (Math.abs(this.direction.angleBetween(a)) > 1.57) continue;
            mmVector = new Crafty.math.Vector2D(mm.x, mm.y);
            distance = thisVector.distance(mmVector);
            avgPosition.add(mmVector);
            countPosition += 1;
            avgDirection.add(mm.direction);
            count += 1;
            if (distance < Crafty.minDistance) {
              vx = this.x - mm.x;
              vy = this.y - mm.y;
              avgDirection.add(new Crafty.math.Vector2D(vx, vy));
              count += 1;
            }
          }
          if (countPosition > 0) {
            avgPosition.x /= countPosition;
            avgPosition.y /= countPosition;
            avgPosition.x -= this.x;
            avgPosition.y -= this.y;
            avgDirection.add(avgPosition);
            count += 1;
          }
          if (count > 0) {
            avgDirection.x /= count;
            avgDirection.y /= count;
            avgDirection.normalize();
            this.direction.x = avgDirection.x;
            this.direction.y = avgDirection.y;
          }
          this.xspeed = this.direction.x;
          this.yspeed = this.direction.y;
          gotoX = this.x + this.xspeed;
          gotoY = this.y + this.yspeed;
          rightBound = Crafty.viewport.width - 50;
          bottomBound = Crafty.viewport.height - 50;
          if (gotoX > rightBound) {
            gotoX = rightBound - (gotoX - rightBound);
            this.direction.x *= -1;
          }
          if (gotoX < 0) {
            gotoX *= -1;
            this.direction.x *= -1;
          }
          if (gotoY > bottomBound) {
            gotoY = bottomBound - (gotoY - bottomBound);
            this.direction.y *= -1;
          }
          if (gotoY < 0) {
            gotoY *= -1;
            this.direction.y *= -1;
          }
          this.x = gotoX;
          this.y = gotoY;
          currentIndex = Crafty.orderedSheepX.indexOf(this);
          [].splice.apply(Crafty.orderedSheepX, [currentIndex, currentIndex - currentIndex + 1].concat(_ref2 = [])), _ref2;
          currentIndex = Crafty.orderedSheepY.indexOf(this);
          [].splice.apply(Crafty.orderedSheepY, [currentIndex, currentIndex - currentIndex + 1].concat(_ref3 = [])), _ref3;
          Crafty.sortedInsertion(Crafty.orderedSheepX, this, "x");
          Crafty.sortedInsertion(Crafty.orderedSheepY, this, "y");
          a = new Crafty.math.Vector2D(1, 0);
          return this.rotation = 270 - Crafty.math.radToDeg(this.direction.angleBetween(a));
        });
      }
    });
  });

}).call(this);
