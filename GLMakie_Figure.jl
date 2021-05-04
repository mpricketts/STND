include("Load_DataFrames.jl")

Data, datetime, Sites, n_S, Years, n_Y = rsoildata();

# Open a soil resp file, plot time series

using GLMakie, UnicodeFun
using PlotUtils: optimize_ticks

fig = Figure()

Plots = collect(1:7);
menu1 = Menu(fig, options = zip(["Columbia", "Fermilab", "Temple"], Sites))
menu2 = Menu(fig, options = zip(["2016", "2017", "2018", "2019", "2020"], Years))
menu3 = Menu(fig, options = zip(["A", "B", "C", "D", "E", "F", "X"], Plots)) 

fig[1, 1] = vgrid!(
    Label(fig, "Site", width = nothing),
    menu1,
    Label(fig, "Year", width = nothing),
    menu2,
    Label(fig, "Plot", width = nothing),
    menu3;
    tellheight = false, width = 200)

ax1 = Axis(fig[1,2], ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"))
ax2 = Axis(fig[2,2], ylabel = to_latex("T_{soil} (°C)"))

site = Node{Any}(Sites[1])
yeari = Node{Any}(Years[1])
plot = Node{Any}(Plots[1])

Rsoil = @lift(Data[$site][$yeari][$plot].Flux)
Tsoil = @lift(Data[$site][$yeari][$plot]."Temperature (C)")

scatter!(ax1, Rsoil, strokewidth = 0, markersize = 5, color = :black)
scatter!(ax2, Tsoil, strokewidth = 0, markersize = 5, color = :red)

on(menu1.selection) do s
	site[] = s
	autolimits!(ax1)
	autolimits!(ax2)
end

on(menu2.selection) do s
	yeari[] = s
	autolimits!(ax1)
	autolimits!(ax2)
end

on(menu3.selection) do s
	plot[] = s
	autolimits!(ax1)
	autolimits!(ax2)
end

fig

