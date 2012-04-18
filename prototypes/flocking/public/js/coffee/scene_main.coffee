define ["cs!coffee/init","cs!coffee/entities/score_entity", "cs!coffee/entities/player_entity"], (Init,ScoreEntity,PlayerEntity) ->
    init: ->
        console.log "scene loaded!"
        Crafty.scene "main", ->
            Crafty.background "url('../images/bg.png')"

            new ScoreEntity()
            new PlayerEntity().initRocks(1, 1)
        Init.init()




















