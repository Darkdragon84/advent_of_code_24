
function find_e(charmat::Matrix{Char}, word::String, row::Int, col::Int)
    word_len = length(word)
    stop = col + word_len -1
    try
        candidates = charmat[row, col:stop]
        return join(candidates) == word
    catch e
        return false
    end
end

function find_w(charmat::Matrix{Char}, word::String, row::Int, col::Int)
    word_len = length(word)
    start = col - word_len + 1
    try
        candidates = charmat[row, start:col]
        return join(reverse(candidates)) == word
    catch e
        return false
    end
end

function find_n(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end
function find_s(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end
function find_ne(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end
function find_se(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end
function find_nw(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end
function find_sw(charmat::Matrix{Char}, word::String, row::Int, col::Int)
end

function find_all(charmat::Matrix{Char}, word::String)
    rows, cols = size(charmat)
    ct = 0
    word_len = length(word)
    for row in range(1, rows)
        for col in range(1, cols - word_len)
            # stop = min(cols, (col+word_len-1))
            # candidate = join(charmat[row, col: col + word_len-1])
            if (find_e(charmat, word, row, col) || find_w(charmat, word, row, col))
                println("($row, $col)")
                ct += 1
            end
        end
    end
end

function main()
    lines = open("data/04_test.txt") do f
        readlines(f)
    end
    # https://discourse.julialang.org/t/how-to-convert-vector-of-vectors-to-matrix/72609
    charmat = mapreduce(permutedims, vcat, collect.(lines))
    find_all(charmat, "XMAS")
end

main()
