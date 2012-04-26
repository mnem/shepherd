(function() {

  define(["app/components/sheep"], function() {
    var PlayerEntity;
    return PlayerEntity = (function() {

      function PlayerEntity(asteroidCount, lastCount) {
        this.asteroidCount = asteroidCount != null ? asteroidCount : 0;
        this.lastCount = lastCount != null ? lastCount : 0;
        this.entity = Crafty.e("2D, Canvas, ship, Controls, Collision").attr({
          move: {
            left: 1,
            right: 2,
            up: 4,
            down: 8,
            direction: 0
          },
          xspeed: 0,
          yspeed: 0,
          decay: 0.9,
          x: Crafty.viewport.width / 2,
          y: Crafty.viewport.height / 2,
          score: 0
        }).origin("center").bind("KeyDown", function(e) {
          if (e.keyCode === Crafty.keys.RIGHT_ARROW) {
            return this.move.direction |= this.move.right;
          } else if (e.keyCode === Crafty.keys.LEFT_ARROW) {
            return this.move.direction |= this.move.left;
          } else if (e.keyCode === Crafty.keys.UP_ARROW) {
            return this.move.direction |= this.move.up;
          } else if (e.keyCode === Crafty.keys.DOWN_ARROW) {
            return this.move.direction |= this.move.down;
          } else if (e.keyCode === Crafty.keys.SPACE) {
            return Crafty.e("2D, DOM, Color, bullet").attr({
              x: this._x,
              y: this._y,
              w: 2,
              h: 5,
              rotation: this._rotation,
              xspeed: 20 * Math.sin(this._rotation / 57.3),
              yspeed: 20 * Math.cos(this._rotation / 57.3)
            }).color("rgb(255, 0, 0)").bind("EnterFrame", function() {
              this.x += this.xspeed;
              this.y -= this.yspeed;
              if (this._x > Crafty.viewport.width || this._x < 0 || this._y > Crafty.viewport.height || this._y < 0) {
                return this.destroy();
              }
            });
          }
        }).bind("KeyUp", function(e) {
          if (e.keyCode === Crafty.keys.RIGHT_ARROW) {
            return this.move.direction &= ~this.move.right;
          } else if (e.keyCode === Crafty.keys.LEFT_ARROW) {
            return this.move.direction &= ~this.move.left;
          } else if (e.keyCode === Crafty.keys.UP_ARROW) {
            return this.move.direction &= ~this.move.up;
          } else if (e.keyCode === Crafty.keys.DOWN_ARROW) {
            return this.move.direction &= ~this.move.down;
          }
        }).bind("EnterFrame", function() {
          var vx, vy;
          vx = Math.sin(this._rotation * Math.PI / 180) * 0.3;
          vy = Math.cos(this._rotation * Math.PI / 180) * 0.3;
          vx = 1.5;
          vy = 1.5;
          if (this.move.direction & this.move.up) this.yspeed = -vy;
          if (this.move.direction & this.move.down) this.yspeed = vy;
          if (this.move.direction & this.move.right) this.xspeed = vx;
          if (this.move.direction & this.move.left) this.xspeed = -vx;
          if (this.move.up && !this.move.left && !this.move.right) {
            this.xspeed *= this.decay;
            this.yspeed *= this.decay;
          }
          this.x += this.xspeed;
          this.y += this.yspeed;
          this.xspeed = 0;
          this.yspeed = 0;
          if (this._x > Crafty.viewport.width) this.x = -64;
          if (this._x < -64) this.x = Crafty.viewport.width;
          if (this._y > Crafty.viewport.height) this.y = -64;
          if (this._y < -64) this.y = Crafty.viewport.height;
          if (this.asteroidCount <= 0) {
            return this.initRocks(this.lastCount, this.lastCount * 2);
          }
        });
      }

      PlayerEntity.prototype.initRocks = function(lower, upper) {
        var i, rocks, sheep, _results;
        rocks = Crafty.math.randomInt(lower, upper);
        this.asteroidCount = rocks;
        this.lastCount = rocks;
        Crafty.orderedSheepX = [];
        Crafty.orderedSheepY = [];
        Crafty.sortedInsertion = this.sortedInsertion;
        _results = [];
        for (i = 0; 0 <= rocks ? i <= rocks : i >= rocks; 0 <= rocks ? i++ : i--) {
          sheep = Crafty.e("2D, DOM, small, Collision, sheep");
          this.sortedInsertion(Crafty.orderedSheepX, sheep, "x");
          _results.push(this.sortedInsertion(Crafty.orderedSheepY, sheep, "y"));
        }
        return _results;
      };

      PlayerEntity.prototype.printArray = function(arr) {
        var i, _ref;
        console.log("-----------");
        for (i = 0, _ref = arr.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
          console.log(i, arr[i].x);
        }
        console.log("-----------");
      };

      PlayerEntity.prototype.sortedInsertion = function(arr, element, property, justIndex, lessThan) {
        var imax, imid, imin, moreThan, p, targetIndex, _ref;
        if (justIndex == null) justIndex = false;
        if (lessThan == null) lessThan = true;
        if (arr.length === 0) {
          if (!justIndex) {
            arr.push(element);
            return;
          } else {
            return -1;
          }
        }
        imin = 0;
        imax = arr.length - 1;
        imid = 0;
        while (imax > imin) {
          imid = (imax + imin) >> 1;
          p = arr[imid];
          if (element[property] > p[property]) {
            imin = imid + 1;
          } else if (element[property] < p[property]) {
            imax = imid - 1;
          } else {
            break;
          }
        }
        if (justIndex) {
          if (arr[imin][property] < element[property]) imin += 1;
          moreThan = !lessThan;
          if (moreThan) {
            if (imin === arr.length) {
              return -1;
            } else {
              return imin;
            }
          }
          if (lessThan) return imin - 1;
        }
        targetIndex = arr[imin][property] < element[property] ? imin + 1 : imin;
        return ([].splice.apply(arr, [targetIndex, targetIndex - targetIndex].concat(_ref = [element])), _ref);
      };

      return PlayerEntity;

    })();
  });

}).call(this);
