# Modules loaded before the game starts
IMPORT_MODULES =
    TiledLevel: 'DEV',
    MoveTo: 'DEV',
    HitBox: 'DEV',

# Graphics loaded before the game starts
# and optional sprite maps
GRAPHICS_MAPPING =
    'images/sprite.png':
        tilesize:64,
        tiles:
            ship:[0, 0],
            big:[1, 0],
            medium:[2, 0],
            SheepImage:[3, 0],

    "images/bg.png": null,

IMPORT_GRAPHICS = for path, mapping of GRAPHICS_MAPPING
    path
