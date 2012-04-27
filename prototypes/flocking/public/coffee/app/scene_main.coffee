define ["app/init","app/entities/score_entity", "app/entities/player_entity"], (Init,ScoreEntity,PlayerEntity) ->
    init: ->
        console.log "scene loaded!"
        Crafty.scene "main", ->
            Crafty.background "url('images/bg.png')"

            new ScoreEntity()
            new PlayerEntity().initRocks(200, 200)
        Init.init()




















