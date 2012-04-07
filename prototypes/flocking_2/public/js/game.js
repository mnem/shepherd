(function() {
  var GRAPHICS_MAPPING, IMPORT_GRAPHICS, IMPORT_MODULES, PlayerEntity, ScoreEntity, graphics_loaded, mapping, modules_loaded, path, try_start;

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

  Crafty.c('debug.framerate', {
    init: function() {
      this._last_frame_time = Date.now();
      this._samples = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      this._next_sample_index = 0;
      this._average_fps = 0;
      return this.bind('EnterFrame', function() {
        var elapsed, now, sample, sample_total, _i, _len, _ref;
        now = Date.now();
        elapsed = now - this._last_frame_time;
        this._last_frame_time = now;
        this._samples[this._next_sample_index] = elapsed;
        this._next_sample_index = this._next_sample_index + 1;
        if (this._next_sample_index >= this._samples.length) {
          this._next_sample_index = 0;
        }
        sample_total = 0;
        _ref = this._samples;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          sample = _ref[_i];
          sample_total += sample;
        }
        this._average_fps = 1000 / (sample_total / this._samples.length);
        return console.log("Average FPS: " + (Math.floor(this._average_fps)));
      });
    }
  });

  PlayerEntity = (function() {

    function PlayerEntity(asteroidCount, lastCount) {
      this.asteroidCount = asteroidCount != null ? asteroidCount : 0;
      this.lastCount = lastCount != null ? lastCount : 0;
      this.entity = Crafty.e("2D, Canvas, ship, Controls, Collision, MoveTo").moveTo(10).attr({
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
        vx = 10;
        vy = 10;
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
      var rocks;
      rocks = Crafty.math.randomInt(lower, upper);
      this.asteroidCount = rocks;
      return this.lastCount = rocks;
    };

    return PlayerEntity;

  })();

  ScoreEntity = (function() {

    function ScoreEntity() {
      this.entity = Crafty.e("2D, DOM, Text, debug.framerate").text("Score: 0").attr({
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

  IMPORT_MODULES = {
    TiledLevel: 'DEV',
    MoveTo: 'DEV'
  };

  GRAPHICS_MAPPING = {
    'images/sprite.png': {
      tilesize: 64,
      tiles: {
        ship: [0, 0],
        big: [1, 0],
        medium: [2, 0],
        small: [3, 0]
      }
    },
    "images/bg.png": null
  };

  IMPORT_GRAPHICS = (function() {
    var _results;
    _results = [];
    for (path in GRAPHICS_MAPPING) {
      mapping = GRAPHICS_MAPPING[path];
      _results.push(path);
    }
    return _results;
  })();

  modules_loaded = false;

  graphics_loaded = false;

  $(document).ready(function() {
    Crafty.init(480, 320);
    Crafty.canvas.init();
    Crafty.modules(IMPORT_MODULES, function() {
      modules_loaded = true;
      return try_start();
    });
    return Crafty.load(IMPORT_GRAPHICS, function() {
      var mapping, path;
      for (path in GRAPHICS_MAPPING) {
        mapping = GRAPHICS_MAPPING[path];
        if (mapping) Crafty.sprite(mapping.tilesize, path, mapping.tiles);
      }
      graphics_loaded = true;
      return try_start();
    });
  });

  try_start = function() {
    if (modules_loaded && graphics_loaded) return Crafty.scene("main");
  };

  Crafty.scene("main", function() {
    Crafty.background("url('images/bg.png')");
    new ScoreEntity();
    return new PlayerEntity();
  });

}).call(this);
