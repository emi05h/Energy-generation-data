using Pkg

Pkg.add("CSV")

Pkg.add("Dates")

Pkg.add("CairoMakie")

Pkg.add("DataFrames")

using CSV, Dates, CairoMakie, DataFrames

begin
    download("file:////home/ug2023/t23356421/cs4171/proj/proj02/wind-gen-PROJECT.csv", "wind.csv")
    download("file:////home/ug2023/t23356421/cs4171/proj/proj02/system-demand-PROJECT.csv", "sysdem.csv")
end

wind = DataFrame(CSV.File("wind.csv")

sysdem = DataFrame(CSV.File("sysdem.csv")

begin
    datef = dateformat"d U y HH:MM"
    wind.dates = DateTime.(wind."DATE & TIME", datef)
    sysdem.dates = DateTime.(sysdem."DATE & TIME", datef)
    wind.forecast = wind." FORECAST WIND(MW)"
end

begin
    sysdem.time = Time.(sysdem.dates)
    sysdem.date = Date.(sysdem.dates)
end

Wind.dates

Wind.forecast

Sysdem.time

Sysdem.date

begin
    wind.actual = map(wind."&nbsp; ACTUAL WIND(MW)") do 
    x == "-" ? missing : parse(Int64, x)
end
    sysdem.demand = map(sysdem." ACTUAL DEMAND(MW)") do 
    x == "-" ? missing : parse(Int64, x)
end
end

Wind.actual

Sysdem.demand

windfinal = wind[:, ["dates", "actual", "forecast"]]

sysdemfinal = sysdem[:, ["date", "time", "demand"]]

length(sysdemfinal.demand)

f = Figure()

length(windfinal.dates)

length(unique(windfinal.dates))

begin
    xticks = (unique(windfinal.dates))
    x = 1:length(xticks)
end

X

Xticks

windfinal.dates[1]

Dates.dayofweek(Date("2023-10-29"))

windfinal.dates[2]

windfinal.dates[101]

Dates.dayofweek(Date("2023-10-30"))

mondaydiff = 4*24*7

windfinal.dates[773]

Dates.dayofweek(Date("2023-11-06"))

axis = Axis(f[1,1], 
    xlabel = "Day", 
    ylabel = "Wind", 
    title = "Wind Generation in MW", 
    xticks = (x[101:672:end], string.(Date.(xticks[101:672:end]))))

begin
    axis.xticklabelrotation = π / 3
    axis.xticklabelalign = (:right, :center)
end

begin
    missinguno = findfirst(r -> typeof(r) == (Missing), windfinal.actual)
    actualpoints = Point2f.(1:length(windfinal.dates[1:2836]), windfinal.actual[1:2836])
    actuallines = lines!(axis, actualpoints, label = "Actual wind", labelcolor = :red)
end

missinguno – 1

length(windfinal.dates)

begin
    forecastpoints = Point2f.(1:2884, windfinal.forecast)
    forecastlines = lines!(axis, forecastpoints, label = "Forecasted wind", labelcolor = :black)
end

axislegend(axis, position = :lt)

save("wind-gen.png", f)

Sysdemfinal.demand

length(sysdemfinal.demand)

begin
    summm = []
    four = 0
        for x in 1:4:length(sysdemfinal.demand)
            totall = 0
            avg = 0
                for four in 0:3
                    num = sysdemfinal.demand[x]
                    typeof(num) == (Missing) ? num = 0 : num = num
                    totall += sysdemfinal.demand[x+four]
                end
            avg = totall / 4
            push!(summm, avg)
        end
    summm
end

length(summm)

begin
    summm2 = map(summm) do x
    typeof(x) == (Missing) ? missing : trunc(Int64, x)
end
end

filter!(r -> minute(r.time) == 00, sysdemfinal)

length(summm2)

for i in 1:720
    sysdemfinal.demand[i] = summm2[i]
end

data = Array(unstack(sysdemfinal, :date, :time, :demand)[!, 2:end])

f2 = Figure(resolution = (1450, 1000), fontsize = 25);

begin
    xticks2 = unique(sysdemfinal.date)
    x2 = 1:length(xticks2)
end

Xticks2

sysdemfinal.date[25]

sysdemfinal.date[50]

Dates.dayofweek(Date("2023-10-30"))

begin
    yticks2 = string.(unique(sysdemfinal[!, :time]))
    y2 = 1:length(yticks2)
end

axis2 = Axis(f2[1, 1], 
    xlabel = "Date", 
    ylabel = "Time", 
    title = "Actual System Demand", 
    xticks = (x2[2:7:end], string.(xticks2[2:7:end])), yticks = (y2, yticks2))

begin
    axis2.xticklabelrotation = π / 3
    axis2.xticklabelalign = (:right, :center)
end
end

hm = heatmap!(axis2, data)

Colorbar(f2[1, 2], hm)

length(xticks2)

length(yticks2)

for x in 1:30, y in 1:24
    d = data[x,y]
    typeof(d) == (Missing) ? d = "Missing" : d = d
    text!(axis2, 
        string.(d), 
        position = Point2f(x,y), 
        align = (:center, :center), 
        color = d == "Missing" ? :red : d < 4500 ? :white : :black, 
        fontsize = 10)
end

F2

save("system-demand.png", f2)
