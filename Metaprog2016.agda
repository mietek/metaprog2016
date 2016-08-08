module Metaprog2016 where

open import Data.List using (List) renaming ([] to ⌀)
open import Data.Maybe using (Maybe)
open import Data.Product using (_×_)
open import Data.Unit using () renaming (⊤ to 𝟙)




-- TOWARDS INTENSIONAL ANALYSIS OF SYNTAX
--
-- Miëtek Bak
-- mietek@bak.io
--
-- http://github.com/mietek/metaprog2016
--
-- International Summer School on Metaprogramming
-- Robinson College, Cambridge, 8th to 12th August 2016




-- Consider a basic fragment of intuitionistic modal logic S4 (IS4).

data Type : Set where
  _▻_ : Type → Type → Type
  _∧_ : Type → Type → Type
  ⊤  : Type
  □_  : Type → Type

postulate
  _⊢_ : List Type → Type → Set

-- IS4 provides the logical foundations for MetaML.




-- Sheard (2001) reminds us that MetaML only allows syntax to be constructed
-- and executed at runtime.  Observation and decomposition is not supported.
--
-- “Accomplishments and research challenges in meta-programming”
-- http://dx.doi.org/10.1007/3-540-44806-3_2

postulate
  •     : Type
  yes   : ∀ {Γ}   → Γ ⊢ •
  no    : ∀ {Γ}   → Γ ⊢ •
  isApp : ∀ {Γ A} → Γ ⊢ ((□ A) ▻ •)

-- Has anyone built a typed system supporting intensional analysis of syntax?




-- I don’t know, but Gabbay and Nanevski (2012) come close.  They give a
-- Tarski-style semantics for IS4, reading “□ A” as “closed syntax of type A”.
--
-- “Denotation of contextual modal type theory: Syntax and meta-programming”
-- http://dx.doi.org/10.1016/j.jal.2012.07.002

module GabbayNanevski2012 where
  ⊨_ : Type → Set
  ⊨ (A ▻ B) = ⊨ A → ⊨ B
  ⊨ (A ∧ B) = (⊨ A) × (⊨ B)
  ⊨ ⊤      = 𝟙
  ⊨ (□ A)   = (⌀ ⊢ A) × (⊨ A)

-- Can we construct a proof of completeness with respect to this semantics
-- and obtain normalisation by evaluation (NbE) for IS4?




-- Yes, we can!  As long as we also take from Coquand and Dybjer (1997).
--
-- “Intuitionistic model constructions and normalization proofs”
-- http://dx.doi.org/10.1017/S0960129596002150

module CoquandDybjer1997GabbayNanevski2012 where
  ⊨_ : Type → Set
  ⊨ (A ▻ B) = (⌀ ⊢ (A ▻ B)) × (⊨ A → ⊨ B)
  ⊨ (A ∧ B) = (⊨ A) × (⊨ B)
  ⊨ ⊤      = 𝟙
  ⊨ (□ A)   = (⌀ ⊢ A) × (⊨ A)

-- Could we perhaps read “□ A” as “open syntax of type A”?




-- I don’t know, but I’ve had an idea about that...

postulate
  _⊆_ : List Type → List Type → Set

module ??? where
  _⊨_ : List Type → Type → Set
  Δ ⊨ (A ▻ B) = ∀ {Δ′} → Δ ⊆ Δ′ → Δ′ ⊨ A → Δ′ ⊨ B
  Δ ⊨ (A ∧ B) = (Δ ⊨ A) × (Δ ⊨ B)
  Δ ⊨ ⊤      = 𝟙
  Δ ⊨ (□ A)   = ∀ {Δ′} → Δ ⊆ Δ′ → (Δ′ ⊢ A) × (Δ′ ⊨ A)

-- Does this look suspiciously like a Kripke-style possible worlds semantics?




-- Yes, it does!  We can find one of these in Alechina et al. (2001).
--
-- “Categorical and Kripke semantics for constructive S4 modal logic”
-- http://dx.doi.org/10.1007/3-540-44802-0_21

postulate
  World : Set
  _≤_   : World → World → Set
  _R_   : World → World → Set

module AlechinaMendlerDePaivaRitter2001 where
  _⊩_ : World → Type → Set
  w ⊩ (A ▻ B) = ∀ {w′} → w ≤ w′ → w′ ⊩ A → w′ ⊩ B
  w ⊩ (A ∧ B) = (w ⊩ A) × (w ⊩ B)
  w ⊩ ⊤      = 𝟙
  w ⊩ (□ A)   = ∀ {w′} → w ≤ w′ → ∀ {v′} → w′ R v′ → v′ ⊩ A

-- Has anyone constructed a proof of completeness with respect to a
-- Kripke-style semantics for IS4?




-- I haven’t found one, and I’ve tried five.

--           v′      w″  →   v″              w″
--           ◌───R───●   →   ◌───────R───────●
--           │           →   │
--           ≤  ξ′,ζ′    →   │
--   v       │           →   │
--   ◌───R───●           →   ≤
--   │       w′          →   │
--   ≤  ξ,ζ              →   │
--   │                   →   │
--   ●                   →   ●
--   w                   →   w

-- How do we go from being able to talk about open syntax to being able
-- to intensionally analyse syntax at runtime?




-- I don’t know, but I’ve noticed a funny coincidence...
--
-- Work in progress:
-- http://github.com/mietek/hilbert-gentzen




-- FIN
