
parse_line(line::String) = parse.(Int64, split(line))
remove_index_from_line(line::Vector{Int}, index::Int) = line[setdiff(begin:end, index)]

function is_line_safe(line::Vector{Int})
    diffs = diff(line)
    all(i -> 1 <= i <= 3, diffs) || all(i -> -3 <= i <= -1, diffs)
end

# not the most efficient, but it does the job :-)
function is_line_safe_with_dampener(line::Vector{Int})
    if is_line_safe(line)
        return true
    else
        return any(idx -> is_line_safe(remove_index_from_line(line, idx)), 1:length(line))
    end
end

function count_safe_lines(lines::Vector{String}, safe_fn::Function)
    sum(line -> parse_line(line) |> safe_fn, lines)
end

function main()
    lines = open("data/02.txt") do io
        readlines(io)
    end

    println("$(count_safe_lines(lines, is_line_safe)) safe rows without dampener")
    println(
        "$(count_safe_lines(lines, is_line_safe_with_dampener)) safe rows with dampener",
    )
end

main()
