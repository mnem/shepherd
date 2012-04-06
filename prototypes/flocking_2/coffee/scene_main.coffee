Crafty.scene "main", ->
    bg = Crafty.e('TiledLevel')
    console.log bg
    # bg.tiledLevel('levels/field.json', 'DOM')
    Crafty.background "url('images/bg.png')"

    new ScoreEntity
    new PlayerEntity().initRocks(60, 60)
