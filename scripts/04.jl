DIRS = Dict([
    "N" => CartesianIndex(-1, 0),
    "NE" => CartesianIndex(-1, 1),
    "E" => CartesianIndex(0, 1),
    "SE" => CartesianIndex(1, 1),
    "S" => CartesianIndex(1, 0),
    "SW" => CartesianIndex(1, -1),
    "W" => CartesianIndex(0, -1),
    "NW" => CartesianIndex(-1, -1)
])


# ::Function{Tuple{Matrix{Char}, CartesianIndex, Int}, Vector{String}}
function count_matches(charmat::Matrix{Char}, word::String, count_candidates_at_point::Function)
    ct = 0
    indices = CartesianIndices(charmat)
    for i in eachindex(charmat)
        point = indices[i]
        ct += count_candidates_at_point(charmat, point, word)
    end
    ct
end

function count_simple_candidates_at_point(charmat::Matrix, point::CartesianIndex, word::String)
    word_len = length(word)
    candidates = [get_candidate(charmat, point, dir, word_len) for dir in values(DIRS)]
    sum([candidate == word for candidate in candidates])
end

function count_crossed_candidates_at_point(charmat::Matrix, point::CartesianIndex, word::String)
    word_len = length(word)
    start_NW = point
    start_NE = point + (word_len - 1) * DIRS["E"]
    start_SW = point + (word_len - 1) * DIRS["S"]
    start_SE = point + (word_len - 1) * DIRS["SE"]
    any_on_NWSE = any([
        get_candidate(charmat, start, DIRS[dir], word_len) == word 
        for (start, dir) in ((start_NW, "SE"), (start_SE, "NW"))
    ])
    any_on_NESW = any([
        get_candidate(charmat, start, DIRS[dir], word_len) == word 
        for (start, dir) in ((start_NE, "SW"), (start_SW, "NE"))
    ])
    Int(any_on_NWSE && any_on_NESW)
end

function get_candidate(charmat::Matrix, point::CartesianIndex, dir::CartesianIndex, n_chars::Int)
    try
        candidate = join([charmat[point+i*dir] for i in range(0, n_chars - 1)])
        return candidate
    catch BoundsError
        return nothing
    end
end

function main()
    lines = open("data/04.txt") do f
        readlines(f)
    end
    # https://discourse.julialang.org/t/how-to-convert-vector-of-vectors-to-matrix/72609
    charmat = mapreduce(permutedims, vcat, collect.(lines))
    word1 = "XMAS"
    word2 = "MAS"
    println("simple matches for '$word1': $(count_matches(charmat, word1, count_simple_candidates_at_point))")
    println("crossed matches for '$word2': $(count_matches(charmat, word2, count_crossed_candidates_at_point))")
end

main()
