### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ b3df0bb6-06cd-48cb-bba2-0772bca2ab2c
begin
	using DataFrames
	using DocStringExtensions
	using StatsBase
end

# ╔═╡ a12106bf-4802-4fa2-9305-4f866bed80b8
function winsorized_mean(x, k)
	k > floor(length(x)/2) && @error "k > floor(length(x)/2), result incorrect."
	y = sort(x)
	for i in 1:k                
		y[i] = y[k + 1]
		y[end - i + 1] = y[end - k]
	end
	s = 0
	for v in y
		s += v
	end
	return (y = y, mean = sum(y) / length(y))
end

# ╔═╡ 3113de9d-1a8c-46cc-8bc1-8c40cdf51502
winsorized_mean([8, 3, 1, 5, 7], 1)

# ╔═╡ a5f332ad-09d6-45c6-9870-311961758d34
winsorized_mean([8, 3, 1, 5, 7], 2)

# ╔═╡ 5ab56fef-0cc9-4d96-b2a5-fd4a827e4df7
winsorized_mean([8, 3, 1, 5, 7], 3)

# ╔═╡ 6089e751-7a5b-45ed-b404-eb3f61afbce0
@info "test"

# ╔═╡ 2fe402fb-1e5c-436a-b7ff-e2b9e497214b
@warn "test"

# ╔═╡ 0a30b250-0a17-4c5b-8e61-bd6944e094f9
typeof(sum)

# ╔═╡ 21d13f39-1198-4e8d-8ce4-ccfadb02ca7e
typeof(sum) <: Function

# ╔═╡ e49ca1b8-845b-4d19-9131-923f4421e40c
supertype(typeof(sum))

# ╔═╡ 690dafb0-c320-4b10-8c5f-eaf1400db254
supertype(Function)

# ╔═╡ 4cc6678c-72f0-4cd1-9a83-e32c6a86ad23
subtypes(AbstractString)

# ╔═╡ 2c845720-c482-47e1-8fe4-00dc6c7b375e
subtypes(Number)

# ╔═╡ 3beaa530-9c4b-4027-859c-891553ffc958
subtypes(Real)

# ╔═╡ 756bf60c-95f3-457e-ae61-e7ea0b7721c7
subtypes(AbstractFloat)

# ╔═╡ 1b03cbf4-57e1-4e41-bd43-a36f803fe18f
function traverse(T, res=[])
	append!(res, [T])
	T == Any || traverse(supertype(T), res)
	return reverse(res)
end

# ╔═╡ ec31a054-59ba-4f26-8d23-303056287991
traverse(Int64)

# ╔═╡ 234ff60d-8ba5-4f9e-9ed2-84867d78a7a0
traverse(Int)

# ╔═╡ 47f937d1-b5c6-4ea3-b423-49c073099039
function get_subtype_list(T, indent_level=0, res=AbstractString[])
	indent = " " ^ indent_level
	append!(res, ["$indent $T"])
	for S in subtypes(T)
		get_subtype_list(S, indent_level + 2, res)
	end
	return res
end

# ╔═╡ 8321485d-002a-44f1-813f-499a02aa6929
get_subtype_list(Integer)

# ╔═╡ 73d8c26b-89ea-4366-9c81-dbab9c906a76
v = [3, missing, 5.0, "two"]

# ╔═╡ 982f3286-b4f9-422e-8bdf-72fe15de998b
m = map(ismissing, v)

# ╔═╡ 2f678776-d023-4d64-ac1f-074273849113
p = map(!ismissing, v)

# ╔═╡ f4bd6608-0589-4bae-a411-aa507ffa0eba
v[m]

# ╔═╡ 591a55de-0f71-4402-9d89-d6435fdd6164
v[p]

# ╔═╡ 926785e3-9ec5-4b34-af36-0fd59925f159
v[[true, false, false, true]]

# ╔═╡ 648130fb-b655-46e7-a1c1-bc80e89ddce4
v[Bool[1, 0, 0, 1]]

# ╔═╡ ef763a41-e8ad-492e-8570-7083170c9959
v[Bool[1, 0, 1, 1]]

# ╔═╡ 1f787b4a-db17-41f5-b48c-e888d1a744b3
traverse(typeof([1.0, 2.0]))

# ╔═╡ a0eb8a3f-3136-40ab-88d0-de8b4e9d4cac
traverse(typeof(1:3))

# ╔═╡ addb2148-efa9-4e5b-894f-cf4233e6b2bc
typejoin(typeof([1.0, 2.0, 3.0]), typeof(1:3))

# ╔═╡ b0e0fe5d-9875-4622-b4c6-44c7d10560f3
begin
	fun(x) = "Unsupported type!"
	fun(x::Float64) = "A Float64 was passed in."
	fun(x::Number) = "A number was passed in."
	fun(x::AbstractString) = "`$x` passed in."
end

# ╔═╡ c34e2edb-0dae-4a36-8cb6-392a26c5de53
methods(fun)

# ╔═╡ b76616c3-8e65-4d9b-a6ec-88efb2656bbe
fun(12.0)

# ╔═╡ af657fee-9a5d-459c-8b74-aff5cd766a2a
fun("Hi there!")

# ╔═╡ 77a70a53-7776-41a9-aa52-f2d2b16a3a6a
fun([1, 2])

# ╔═╡ 059c4e76-1798-48b6-89fd-dc3493090346
fun.([1, "three", missing, 12.0])

# ╔═╡ 8c03d28d-1c4d-49c7-aba1-df0d2bf6adb2
begin
	bar(x, y) = "No Numbers passed"
	bar(x::Number, y) = "First argument is aNumber."
	bar(x, y::Number) = "Second arguments is a Number"
end

# ╔═╡ ecd97137-b660-459c-a046-5a1d07fde90e
bar("Hi", "There")

# ╔═╡ ff621292-cb2a-453d-b031-b5704489ae61
bar(1, "world")

# ╔═╡ 30a10087-1d20-4968-a2aa-1ec00307b805
bar("new", 3)

# ╔═╡ f8b22346-37d6-4b71-b9f3-3b40a83d199c
bar(2, 4)

# ╔═╡ 9be57ad1-288a-47e3-a1be-e2973e17ed19
begin
	baz(x, y) = "No Numbers passed"
	baz(x::Number, y) = "First argument is aNumber."
	baz(x, y::Number) = "Second arguments is a Number"
	baz(x::Number, y::Number) = "Tho Numbers passed in"
end

# ╔═╡ d9333482-f57e-48f1-bf74-42d1ed487263
baz(4, 12.0)

# ╔═╡ 115ed627-c0a9-4b29-bd20-42297bb32009
"""

Compute the k winsorized mean of x.

$(SIGNATURES)

### Required arguments
```julia
* `x::AbstractVector` : Input vector
* `k::Int` : Window size
``` 
Not exported
"""
function winsorized_mean2(x::AbstractVector, k::Int)
	k < 0 && begin
		@error "k needs to be non-negative."
		return (y = x, k = k, winsorized_mean = missing)
	end
	k > floor(length(x)/2) && begin
		@error "k is too large."
		return (y = x, k = k, winsorized_mean = missing)
	end
	y = sort(collect(x))
	for i in 1:k                
		y[i] = y[k + 1]
		y[end - i + 1] = y[end - k]
	end
	s = 0
	for v in y
		s += v
	end
	return (y = y, k = k, winsorized_mean = sum(y) / length(y))
end

# ╔═╡ 9dbd5467-6801-4e32-b845-e2564fca81f6
winsorized_mean2([8, 3, 1, 5, 7], -1)

# ╔═╡ 86328bdd-b874-4de9-82ce-d37e0dade5bc
winsorized_mean2([8, 3, 1, 5, 7], 0)

# ╔═╡ e2a55360-2cf6-423d-8aaa-71785cce72b0
winsorized_mean2([8, 3, 1, 5, 7], 1)

# ╔═╡ 8d3997b3-3b05-469e-94ad-227484db8fc7
winsorized_mean2([8, 3, 1, 5, 7], 3)

# ╔═╡ 3c9be4b8-dcee-4dc4-aaa1-3ced1257dbe9
winsorized_mean2(1:10, 3)

# ╔═╡ 69e5409e-8ec1-4588-9a88-12d4cab21da3
winsorized_mean2([10], 1)

# ╔═╡ 27aff232-3ee4-437c-ae83-2863464d89dd
winsorized_mean2(2:2, 0)

# ╔═╡ b45a7c28-2180-416e-9ed7-bbe9a39a0d9e
methods(sort)

# ╔═╡ f76dedf9-b22d-4966-b9af-df07c07677fc
let
	v = rand(1:1000, 100)
	[mean(winsor(v, ; count = 3)), winsorized_mean2(v, 3)]
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DocStringExtensions = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
DataFrames = "~1.3.2"
DocStringExtensions = "~0.8.6"
StatsBase = "~0.33.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-DEV"
manifest_format = "2.0"
project_hash = "c5a0816a1752f729725820283b40b2596db63307"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.81.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a970d55c2ad8084ca317a4658ba6ce99b7523571"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.12"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "8d7530a38dbd2c397be7ddd01a424e4f411dcc41"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.2"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.41.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "16.2.1+1"
"""

# ╔═╡ Cell order:
# ╠═b3df0bb6-06cd-48cb-bba2-0772bca2ab2c
# ╠═a12106bf-4802-4fa2-9305-4f866bed80b8
# ╠═3113de9d-1a8c-46cc-8bc1-8c40cdf51502
# ╠═a5f332ad-09d6-45c6-9870-311961758d34
# ╠═5ab56fef-0cc9-4d96-b2a5-fd4a827e4df7
# ╠═6089e751-7a5b-45ed-b404-eb3f61afbce0
# ╠═2fe402fb-1e5c-436a-b7ff-e2b9e497214b
# ╠═0a30b250-0a17-4c5b-8e61-bd6944e094f9
# ╠═21d13f39-1198-4e8d-8ce4-ccfadb02ca7e
# ╠═e49ca1b8-845b-4d19-9131-923f4421e40c
# ╠═690dafb0-c320-4b10-8c5f-eaf1400db254
# ╠═4cc6678c-72f0-4cd1-9a83-e32c6a86ad23
# ╠═2c845720-c482-47e1-8fe4-00dc6c7b375e
# ╠═3beaa530-9c4b-4027-859c-891553ffc958
# ╠═756bf60c-95f3-457e-ae61-e7ea0b7721c7
# ╠═1b03cbf4-57e1-4e41-bd43-a36f803fe18f
# ╠═ec31a054-59ba-4f26-8d23-303056287991
# ╠═234ff60d-8ba5-4f9e-9ed2-84867d78a7a0
# ╠═47f937d1-b5c6-4ea3-b423-49c073099039
# ╠═8321485d-002a-44f1-813f-499a02aa6929
# ╠═73d8c26b-89ea-4366-9c81-dbab9c906a76
# ╠═982f3286-b4f9-422e-8bdf-72fe15de998b
# ╠═2f678776-d023-4d64-ac1f-074273849113
# ╠═f4bd6608-0589-4bae-a411-aa507ffa0eba
# ╠═591a55de-0f71-4402-9d89-d6435fdd6164
# ╠═926785e3-9ec5-4b34-af36-0fd59925f159
# ╠═648130fb-b655-46e7-a1c1-bc80e89ddce4
# ╠═ef763a41-e8ad-492e-8570-7083170c9959
# ╠═1f787b4a-db17-41f5-b48c-e888d1a744b3
# ╠═a0eb8a3f-3136-40ab-88d0-de8b4e9d4cac
# ╠═addb2148-efa9-4e5b-894f-cf4233e6b2bc
# ╠═b0e0fe5d-9875-4622-b4c6-44c7d10560f3
# ╠═c34e2edb-0dae-4a36-8cb6-392a26c5de53
# ╠═b76616c3-8e65-4d9b-a6ec-88efb2656bbe
# ╠═af657fee-9a5d-459c-8b74-aff5cd766a2a
# ╠═77a70a53-7776-41a9-aa52-f2d2b16a3a6a
# ╠═059c4e76-1798-48b6-89fd-dc3493090346
# ╠═8c03d28d-1c4d-49c7-aba1-df0d2bf6adb2
# ╠═ecd97137-b660-459c-a046-5a1d07fde90e
# ╠═ff621292-cb2a-453d-b031-b5704489ae61
# ╠═30a10087-1d20-4968-a2aa-1ec00307b805
# ╠═f8b22346-37d6-4b71-b9f3-3b40a83d199c
# ╠═9be57ad1-288a-47e3-a1be-e2973e17ed19
# ╠═d9333482-f57e-48f1-bf74-42d1ed487263
# ╠═115ed627-c0a9-4b29-bd20-42297bb32009
# ╠═9dbd5467-6801-4e32-b845-e2564fca81f6
# ╠═86328bdd-b874-4de9-82ce-d37e0dade5bc
# ╠═e2a55360-2cf6-423d-8aaa-71785cce72b0
# ╠═8d3997b3-3b05-469e-94ad-227484db8fc7
# ╠═3c9be4b8-dcee-4dc4-aaa1-3ced1257dbe9
# ╠═69e5409e-8ec1-4588-9a88-12d4cab21da3
# ╠═27aff232-3ee4-437c-ae83-2863464d89dd
# ╠═b45a7c28-2180-416e-9ed7-bbe9a39a0d9e
# ╠═f76dedf9-b22d-4966-b9af-df07c07677fc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
