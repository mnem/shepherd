Crafty.c 'debug.Framerate',
    init: ->
        @_last_frame_time = Date.now()
        @_samples = [
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
        ]
        @_next_sample_index = 0
        @_min_max_sample_range = 200
        @_min_max_reset_count = 10
        @avg_fps = 0
        @min_fps = 100000
        @max_fps = 0


        @bind 'EnterFrame', ->
            now = Date.now()
            elapsed = now - @_last_frame_time
            @_last_frame_time = now
            @_samples[@_next_sample_index] = elapsed
            @_next_sample_index = @_next_sample_index + 1
            @_next_sample_index = 0 if @_next_sample_index >= @_samples.length

            sample_total = 0
            sample_total += sample for sample in @_samples
            @avg_fps = 1000 / (sample_total / @_samples.length)

            @_min_max_reset_count -= 1
            if @_min_max_reset_count < 0
                @min_fps = 100000
                @max_fps = 0
                @_min_max_reset_count =  @_min_max_sample_range
            @min_fps = @avg_fps if @avg_fps < @min_fps
            @max_fps = @avg_fps if @avg_fps > @max_fps
