__precompile__(true)

# main module for `LazySets.jl`
module LazySets

using LinearAlgebra, Reexport, Requires, SparseArrays
using LinearAlgebra: checksquare
import LinearAlgebra: norm, ×, normalize, normalize!
import SparseArrays: permute
import Pkg, Random
using Random: AbstractRNG, GLOBAL_RNG, SamplerType, shuffle, randperm
import InteractiveUtils: subtypes
import JuMP, GLPK
import IntervalArithmetic
import IntervalArithmetic: radius, ⊂

export Arrays
export ×, normalize, ⊂

# ==========
# Assertions
# ==========

include("Assertions/Assertions.jl")
@reexport using .Assertions
using .Assertions: @assert
import .Assertions: activate_assertions, deactivate_assertions
# activate assertions by default
activate_assertions(LazySets)

# ==================
# Linear programming
# ==================
include("Initialization/init_GLPK.jl")
include("Initialization/init_JuMP.jl")

# =====================
# Numeric approximation
# =====================
include("Utils/comparisons.jl")

# =======================
# Arrays auxiliary module
# =======================
include("Arrays/Arrays.jl")
using .Arrays
import .Arrays: distance,
                rectify,
                _rationalize,
                _similar_type

# ===================
# Auxiliary functions
# ===================
include("Utils/require.jl")
include("Utils/helper_functions.jl")
include("Utils/macros.jl")
include("Utils/iterators.jl")
include("Utils/matrix_exponential.jl")

# ==================
# Abstract set types
# ==================
include("Interfaces/LazySet.jl")
include("Interfaces/AbstractStar.jl")
include("Interfaces/AbstractPolyhedron.jl")
include("Sets/HalfSpace.jl")  # must come before AbstractPolyhedron_functions
include("Interfaces/AbstractPolyhedron_functions.jl")
include("Interfaces/AbstractPolytope.jl")
include("Interfaces/AbstractCentrallySymmetric.jl")
include("Interfaces/AbstractCentrallySymmetricPolytope.jl")
include("Interfaces/AbstractZonotope.jl")
include("Interfaces/AbstractHyperrectangle.jl")
include("Interfaces/AbstractPolygon.jl")
include("Interfaces/AbstractSingleton.jl")
include("Interfaces/AbstractHPolygon.jl")
include("Interfaces/AbstractAffineMap.jl")

# =============================
# Types representing basic sets
# =============================
include("Sets/Ball1.jl")
include("Sets/Ball2.jl")
include("Sets/BallInf.jl")
include("Sets/Ballp.jl")
include("Sets/Ellipsoid.jl")
include("Sets/EmptySet.jl")
include("Sets/HPolygon.jl")
include("Sets/HPolygonOpt.jl")
include("Sets/HPolytope.jl")
include("Sets/HPolyhedron.jl")
include("Sets/Hyperplane.jl")
include("Sets/Hyperrectangle.jl")
include("Sets/Interval.jl")
include("Sets/Line2D.jl")
include("Sets/Line.jl")
include("Sets/LineSegment.jl")
include("Sets/RotatedHyperrectangle.jl")
include("Sets/Singleton.jl")
include("Sets/Universe.jl")
include("Sets/VPolygon.jl")
include("Sets/VPolytope.jl")
include("Sets/ZeroSet.jl")
include("Sets/Zonotope.jl")
include("Sets/HParallelotope.jl")

# ==================================
# Types representing non-convex sets
# ==================================
include("Sets/PolynomialZonotope.jl")

# =================================
# Types representing set operations
# =================================
include("LazyOperations/Bloating.jl")
include("LazyOperations/CartesianProduct.jl")
include("LazyOperations/CartesianProductArray.jl")
include("LazyOperations/Complement.jl")
include("LazyOperations/ConvexHull.jl")
include("LazyOperations/ConvexHullArray.jl")
include("LazyOperations/ExponentialMap.jl")
include("LazyOperations/Intersection.jl")
include("LazyOperations/IntersectionArray.jl")
include("LazyOperations/LinearMap.jl")
include("LazyOperations/InverseLinearMap.jl")
include("LazyOperations/AffineMap.jl")  # must come after LinearMap
include("LazyOperations/MinkowskiSum.jl")
include("LazyOperations/MinkowskiSumArray.jl")
include("LazyOperations/CachedMinkowskiSumArray.jl")
include("LazyOperations/ResetMap.jl")
include("LazyOperations/SymmetricIntervalHull.jl")
include("LazyOperations/Translation.jl")
include("LazyOperations/UnionSet.jl")
include("LazyOperations/UnionSetArray.jl")
include("LazyOperations/Rectification.jl")  # must come after UnionSet

# =======
# Aliases
# =======
include("Interfaces/aliases.jl")
include("Interfaces/AbstractArraySet.jl")
include("Sets/Star.jl")

# =============================
# Conversions between set types
# =============================
include("convert.jl")

# ===========================
# Concrete operations on sets
# ===========================
include("ConcreteOperations/cartesian_product.jl")
include("ConcreteOperations/convex_hull.jl")
include("ConcreteOperations/difference.jl")
include("ConcreteOperations/distance.jl")
include("ConcreteOperations/intersection.jl")
include("ConcreteOperations/isdisjoint.jl")
include("ConcreteOperations/issubset.jl")
include("ConcreteOperations/isstrictsubset.jl")
include("ConcreteOperations/minkowski_difference.jl")
include("ConcreteOperations/minkowski_sum.jl")
include("Utils/samples.jl")

# =====================
# Approximations module
# =====================
include("Approximations/Approximations.jl")
# We export all symbols from Approximations.
# Note that the LazySets module is not supposed to depend on Approximations.
# It can, however, happen that we forget to add the `using` statements.
@reexport using .Approximations

# ==================================
# Plotting (requires Approximations)
# ==================================
include("Plotting/plot_recipes.jl")
include("Plotting/mesh.jl")

# ==========================
# Parallel-algorithms module
# ==========================
include("Parallel/Parallel.jl")

# ===================================================
# Load external packages on-demand (using 'Requires')
# ===================================================
include("init.jl")

# ================================================
# Convenience functions to (de)activate assertions
# ================================================
function activate_assertions()
    for m in [LazySets, Arrays, Approximations, Parallel]
        Assertions.activate_assertions(m)
    end
end
function deactivate_assertions()
    for m in [LazySets, Arrays, Approximations, Parallel]
        Assertions.deactivate_assertions(m)
    end
end

end # module
