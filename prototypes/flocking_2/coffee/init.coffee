modules_loaded = false
graphics_loaded = false

$(document).ready ->
    Crafty.init(480, 320)
    Crafty.canvas.init()

    Crafty.modules IMPORT_MODULES, ->
        modules_loaded = true
        try_start()

    Crafty.load IMPORT_GRAPHICS, ->
        for path, mapping of GRAPHICS_MAPPING
            Crafty.sprite(mapping.tilesize, path, mapping.tiles) if mapping
        graphics_loaded = true
        try_start()

try_start = ->
    if modules_loaded && graphics_loaded
        Crafty.scene("main")
