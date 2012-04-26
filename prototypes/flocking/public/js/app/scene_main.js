(function() {

  define(["app/init", "app/entities/score_entity", "app/entities/player_entity"], function(Init, ScoreEntity, PlayerEntity) {
    return {
      init: function() {
        console.log("scene loaded!");
        Crafty.scene("main", function() {
          Crafty.background("url('images/bg.png')");
          new ScoreEntity();
          return new PlayerEntity().initRocks(20, 20);
        });
        return Init.init();
      }
    };
  });

}).call(this);
