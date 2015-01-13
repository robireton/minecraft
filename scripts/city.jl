for x = 9:14, y = 4:5, z = 27:32
    x₀, y₀, z₀ = -16x, 64, 16z
    x₁, y₁, z₁ = x₀-15, 71, z₀+15
    println("fill $x₀ $y₀ $z₀ $x₁ $y₁ $z₁ dirt")
end
