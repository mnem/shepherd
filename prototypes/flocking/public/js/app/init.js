(function() {

  define(function() {
    return {
      init: function() {
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
      }
    };
  });

}).call(this);
