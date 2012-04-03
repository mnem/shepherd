(function() {
  var PlayerEntity, ScoreEntity;

  Crafty.c("asteroid", {
    init: function() {
      this.origin("center");
      return this.attr({
        x: Crafty.math.randomInt(10, Crafty.viewport.width - 10),
        y: Crafty.math.randomInt(10, Crafty.viewport.height - 10),
        xspeed: Crafty.math.randomInt(1, 5),
        yspeed: Crafty.math.randomInt(1, 5),
        rspeed: Crafty.math.randomInt(-5, 5),
        movementLengthFrames: 0,
        direction: new Crafty.math.Vector2D(Crafty.math.randomInt(-1, 1), Crafty.math.randomInt(-1, 1))
      }).bind("EnterFrame", function() {
        var avgDirection, distance, distantSheep, dx, dy, i, mm, mmVector, sheep, thisVector, tooClose, vx, vy, xds, yds, _ref;
        sheep = Crafty("asteroid");
        xds = 0;
        yds = 0;
        tooClose = false;
        avgDirection = new Crafty.math.Vector2D(0, 0);
        distantSheep = 0;
        thisVector = new Crafty.math.Vector2D(this.x, this.y);
        for (i = 0, _ref = sheep.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
          mm = Crafty(sheep[i]);
          if (mm[0] === this[0]) continue;
          dx = this.x - mm.x;
          dy = this.y - mm.y;
          mmVector = new Crafty.math.Vector2D(mm.x, mm.y);
          distance = thisVector.distance(mmVector);
          avgDirection.add(mm.direction);
          if (distance < 50) {
            vx = this.x - mm.x;
            vy = this.y - mm.y;
            vx = vx / distance;
            vy = vy / distance;
            xds += vx;
            yds += vy;
            tooClose = true;
            this.movementLengthFrames = 0;
          } else if (distance > 500) {
            vx = mm.x - this.x;
            vy = mm.y - this.y;
            vx = vx / distance;
            vy = vy / distance;
            xds += vx;
            yds += vy;
            tooClose = true;
            this.movementLengthFrames = 0;
          }
        }
        avgDirection.normalize();
        this.direction.x = avgDirection.x;
        this.direction.y = avgDirection.y;
        avgDirection.x += xds;
        avgDirection.y += yds;
        avgDirection.normalize();
        if (tooClose) {
          this.xspeed = xds;
          this.yspeed = yds;
        }
        if (!tooClose && this.movementLengthFrames === 0) {
          this.xspeed = 0;
          this.yspeed = 0;
          if (Crafty.math.randomInt(1, 1000) > 999) {
            this.movementLengthFrames = Crafty.math.randomInt(50, 300);
            this.xspeed = Crafty.math.randomInt(-1, 1);
            this.yspeed = Crafty.math.randomInt(-1, 1);
            this.direction.x = this.xspeed;
            this.direction.y = this.yspeed;
          }
        }
        this.x += this.xspeed;
        this.y += this.yspeed;
        if (this.movementLengthFrames > 0) {
          return this.movementLengthFrames = this.movementLengthFrames - 1;
        }
      });
    }
  }, this._x > Crafty.viewport.width ? this.direction.x = this.xspeed = -1 : void 0, this._x < -64 ? this.direction.x = this.xspeed = 1 : void 0, this._y > Crafty.viewport.height ? this.direction.y = this.yspeed = -1 : void 0, this._y < 0 ? this.direction.y = this.yspeed = 1 : void 0);

  PlayerEntity = (function() {

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
      var i, rocks, _results;
      rocks = Crafty.math.randomInt(lower, upper);
      this.asteroidCount = rocks;
      this.lastCount = rocks;
      _results = [];
      for (i = 0; 0 <= rocks ? i <= rocks : i >= rocks; 0 <= rocks ? i++ : i--) {
        _results.push(Crafty.e("2D, DOM, small, Collision, asteroid"));
      }
      return _results;
    };

    return PlayerEntity;

  })();

  ScoreEntity = (function() {

    function ScoreEntity() {
      this.entity = Crafty.e("2D, DOM, Text").text("Score: 0").attr({
        x: Crafty.viewport.width - 300,
        y: Crafty.viewport.height - 50,
        w: 200,
        h: 50
      }).css({
        color: "#fff"
      });
    }

    return ScoreEntity;

  })();

  $(document).ready(function() {
    Crafty.init();
    Crafty.canvas.init();
    return Crafty.load(["images/sprite.png", "images/bg.png"], function() {
      Crafty.sprite(64, "images/sprite.png", {
        ship: [0, 0],
        big: [1, 0],
        medium: [2, 0],
        small: [3, 0]
      });
      return Crafty.scene("main");
    });
  });

  Crafty.scene("main", function() {
    Crafty.background("url('images/bg.png')");
    new ScoreEntity;
    return new PlayerEntity().initRocks(60, 60);
  });

}).call(this);
