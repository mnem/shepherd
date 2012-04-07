Crafty.scene "main", ->
    # Crafty.e('TiledLevel').tiledLevel('levels/field.json') # Why is this ridiculously slow?
    Crafty.background "url('images/bg.png')"

    new ScoreEntity()
    new PlayerEntity()
