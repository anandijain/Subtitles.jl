using Subtitles, Test

@test_throws Any Subtitles.parse_vtt(joinpath(@__DIR__, "data/jelly.wav.vtt"))
srt = Subtitles.parse_srt(joinpath(@__DIR__, "data/jelly.wav.srt"))
