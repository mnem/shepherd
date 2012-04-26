(function() {

  define(function() {
    var ScoreEntity;
    return ScoreEntity = (function() {

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
  });

}).call(this);
