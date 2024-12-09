using IterTools

function update_violates_rule(update, rules)
    for (before, after) in subsets(update, 2)
        if (after, before) in rules
            return true
        end
    end
    false
end

function main()
    test = true

    lines_updates = open("data/05$(test ? "_test" : "").txt") do f
        readlines(f)
    end
    lines_rules = open("data/05_rules$(test ? "_test" : "").txt") do f
        readlines(f)
    end
    rules = Set(map(line -> Tuple(parse.(Int, split(line, "|"))), lines_rules))
    updates = map(line -> parse.(Int, split(line, ",")), lines_updates)

    ct = 0
    for update in updates
        if !update_violates_rule(update, rules)
            middle_index = Int(ceil(length(update) / 2))
            ct += update[middle_index] 
            println("$update: $(update) pages, middle page: $(update[middle_index])")
        end
        # println("$update: $(update_violates_rule(update, rules) ? "valid" : "invalid")")
    end
    println("sum of middle pages of currect updates: $(ct)")
end

main()
