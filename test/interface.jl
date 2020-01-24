struct MyModel <: AbstractModel end

struct MyTransition <: AbstractTransition
    a::Float64
    b::Float64
end

struct MySampler <: AbstractSampler end

AbstractMCMC.transition_type(::MySampler) = MyTransition

struct MyChain <: AbstractChains
    as::Vector{Float64}
    bs::Vector{Float64}
end

function AbstractMCMC.step!(
    rng::AbstractRNG,
    model::MyModel,
    sampler::MySampler,
    N::Integer;
    kwargs...
)
    a = rand(rng)
    b = randn(rng)

    return MyTransition(a, b)
end

function AbstractMCMC.step!(
    rng::AbstractRNG,
    model::MyModel,
    sampler::MySampler,
    N::Integer,
    transition::Union{Nothing,MyTransition};
    kwargs...
)
    a = rand(rng)
    b = randn(rng)

    return MyTransition(a, b)
end

function AbstractMCMC.bundle_samples(
    rng::AbstractRNG,
    model::MyModel,
    sampler::MySampler,
    N::Integer,
    transitions::Vector{MyTransition};
    kwargs...
)
    n = length(transitions)
    as = Vector{Float64}(undef, n)
    bs = Vector{Float64}(undef, n)
    for i in 1:n
        transition = transitions[i]
        as[i] = transition.a
        bs[i] = transition.b
    end

    return MyChain(as, bs)
end

AbstractMCMC.chainscat(chains::Union{MyChain,Vector{<:MyChain}}...) = vcat(chains...)