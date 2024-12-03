using CSV, DataFrames, DataStructures

function absolute_difference_sum(df::DataFrame)

    diffs = sort(df.a) - sort(df.b)
    return sum(abs.(diffs))
end

function counter_similarity(df::DataFrame)
    act = counter(df.a)
    bct = counter(df.b)

    sim = 0

    for (a, ct) in act
        sim += a * ct * get(bct, a, 0)
    end
    return sim
end

function main()
    # Read CSV with space separators
    df = CSV.read(
        "data/01.csv",
        DataFrame;
        delim = " ",
        ignorerepeated = true,
        header = [:a, :b],
    )


    println("difference: $(absolute_difference_sum(df))")
    println("similarity: $(counter_similarity(df))")
end

main()
