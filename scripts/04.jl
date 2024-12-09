DIRS = [
    CartesianIndex(-1, 0),
    CartesianIndex(-1, 1),
    CartesianIndex(0, 1),
    CartesianIndex(1, 1),
    CartesianIndex(1, 0),
    CartesianIndex(1, -1),
    CartesianIndex(0, -1),
    CartesianIndex(-1, -1)
]

function get_candidate(charmat::Matrix, point::CartesianIndex, dir::CartesianIndex, n_chars::Int)
    try
        candidate = join([charmat[point+i*dir] for i in range(0, n_chars - 1)])
        return candidate
    catch BoundsError
        return nothing
    end
end

function count_all(charmat::Matrix{Char}, word::String)
    ct = 0
    word_len = length(word)
    indices = CartesianIndices(charmat)
    for i in eachindex(charmat)
        p = indices[i]
        for dir in DIRS
            candidate = get_candidate(charmat, p, dir, word_len)
            if candidate == word
                ct += 1
            end
        end
    end
    ct
end

function main()
    lines = open("data/04.txt") do f
        readlines(f)
    end
    # https://discourse.julialang.org/t/how-to-convert-vector-of-vectors-to-matrix/72609
    charmat = mapreduce(permutedims, vcat, collect.(lines))
    word = "XMAS"
    println("matches for '$word': $(count_all(charmat, word))")
end

main()
