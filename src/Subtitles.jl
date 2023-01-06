module Subtitles

using Dates

# Struct to store a single subtitle
mutable struct Subtitle
    start_time::DateTime
    end_time::DateTime
    text::String
end

# Function to parse a vtt file and return an array of Subtitle structs
function parse_vtt(filepath::String)
    subtitles = []
    lines = readlines(filepath)
    # Create a DateFormat object for parsing the timecodes
    time_format = DateFormat("HH:MM:SS.SSS")
    for i in 1:length(lines)
        line = lines[i]
        # if startswith(line, "-->")
        # Parse the start and end timecodes
        start_time, end_time = map(x -> Date(x, time_format), split(line, " --> "))
        # Initialize the subtitle text
        text = ""
        # Concatenate the text lines until the next timecodes line is reached
        i += 1
        while i <= length(lines) && !startswith(lines[i], "-->")
            text *= lines[i] * "\n"
            i += 1
        end
        # Create a Subtitle struct and add it to the array
        push!(subtitles, Subtitle(start_time, end_time, text))
        # end
    end
    return subtitles
end


function parse_srt(filepath::String)
    subtitles = []
    current_subtitle = Subtitle(DateTime(0,1,1), DateTime(0,1,1), "")
    lines = readlines(filepath)
    i = 1
    # Create a DateFormat object for parsing the timecodes
    time_format = DateFormat("HH:MM:SS,SSS")
    while i <= length(lines)
        # Parse the index line
        if occursin(r"^\d+$", lines[i])
            i += 1
            # Parse the timecodes line
            timecodes_line = lines[i]
            print(timecodes_line)
            start_time, end_time = map(x -> Date(string(x),time_format), split(timecodes_line, " --> "))
            current_subtitle = Subtitle(start_time, end_time, "")
            i += 1
            # Parse the text lines
            while i <= length(lines) && !occursin(r"^\d+$", lines[i])
                current_subtitle.text *= lines[i] * "\n"
                i += 1
            end
            push!(subtitles, current_subtitle)
        end
    end
    return subtitles
end


end # module 
