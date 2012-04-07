Crafty.c 'debug.framerate',
    init: ->
        @_last_frame_time = Date.now()
        @_samples = [
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
        ]
        @_next_sample_index = 0
        @_average_fps = 0

        @bind 'EnterFrame', ->
            now = Date.now()
            elapsed = now - @_last_frame_time
            @_last_frame_time = now
            @_samples[@_next_sample_index] = elapsed
            @_next_sample_index = @_next_sample_index + 1
            @_next_sample_index = 0 if @_next_sample_index >= @_samples.length

            sample_total = 0
            sample_total += sample for sample in @_samples
            @_average_fps = 1000 / (sample_total / @_samples.length)

            console.log "Average FPS: #{Math.floor(@_average_fps)}"
