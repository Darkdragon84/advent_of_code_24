using IterTools

function get_violating_pair_indices(update, rules)
    for ((i_before, before), (i_after, after)) in subsets(collect(enumerate(update)), 2)
        if (after, before) in rules
            return (i_after, i_before)
        end
    end
    nothing
end

function main()
    test = false

    lines_updates = open("data/05$(test ? "_test" : "").txt") do f
        readlines(f)
    end
    lines_rules = open("data/05_rules$(test ? "_test" : "").txt") do f
        readlines(f)
    end
    
    rules = Set(map(line -> Tuple(parse.(Int, split(line, "|"))), lines_rules))
    updates = map(line -> parse.(Int, split(line, ",")), lines_updates)

    page_sum_correct = 0
    page_sum_fixed = 0
    for update in updates
        middle_index = Int(ceil(length(update) / 2))
        # check if rule is correct from the beginning
        violated_pair_inds = get_violating_pair_indices(update, rules)
        if violated_pair_inds !== nothing
            # if not, exchange violating page pairs until all rules are satisfied
            while violated_pair_inds !== nothing
                i, j = violated_pair_inds
                update[i], update[j] = update[j], update[i]
                violated_pair_inds = get_violating_pair_indices(update, rules)
            end
            page_sum_fixed += update[middle_index] 
        else
            page_sum_correct += update[middle_index] 
        end
    end
    println("sum of middle pages of currect updates: $(page_sum_correct)")
    println("sum of middle pages of fixed updates: $(page_sum_fixed)")
end

main()
