MUL_RE = r"mul\((\d{1,3}),(\d{1,3})\)"
DO_RE = r"do\(\)"
DONT_RE = r"don\'t\(\)"
RE_MAP = Dict(false => DO_RE, true => DONT_RE)

function parse_mul(match::RegexMatch)
    a, b = parse.(Int, match)
    a * b
end

compute_sum(memory::String) = sum(parse_mul, eachmatch(MUL_RE, memory))

# oei this is ugly, but does the job :'-)
function compute_conditional_sum(memory::String)
    sum_ = 0
    start_ = 1

    # start with enabled and look for first don't
    enabled = true
    m = match(RE_MAP[enabled], memory)

    # keep switching between looking for do() and don't(), only counting contributions from 
    # multiplications when enabled is true
    while m ≠ nothing
        end_ = m.offset
        if enabled
            sum_ += compute_sum(memory[start_:end_])
        end

        enabled = !enabled
        # start looking for opposing pattern after previous match
        start_ = end_ + 1
        m = match(RE_MAP[enabled], memory, start_)
    end

    # if previous pattern was do(), count contribution from rest of memory
    if enabled
        sum_ += compute_sum(memory[start_:end])
    end

    sum_
end

function main()

    memory = open("data/03.txt") do io
        join(readlines(io, keep=true))
    end

    println("sum: $(compute_sum(memory))")
    println("conditional sum: $(compute_conditional_sum(memory))")
end

main()
