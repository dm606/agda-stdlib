------------------------------------------------------------------------
-- The Agda standard library
--
-- Results concerning function extensionality for propositional equality
------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Axiom.Extensionality.Propositional where

open import Function
open import Level using (Level; _⊔_; suc; lift)
open import Relation.Binary.Core
open import Relation.Binary.PropositionalEquality.Core

------------------------------------------------------------------------
-- Function extensionality states that if two functions are
-- propositionally equal for every input, then the functions themselves
-- must be propositionally equal.

Extensionality : (a b : Level) → Set _
Extensionality a b =
  {A : Set a} {B : A → Set b} {f g : (x : A) → B x} →
  (∀ x → f x ≡ g x) → f ≡ g

------------------------------------------------------------------------
-- Properties

-- If extensionality holds for a given universe level, then it also
-- holds for lower ones.

lower-extensionality : ∀ {a₁ b₁} a₂ b₂ →
                       Extensionality (a₁ ⊔ a₂) (b₁ ⊔ b₂) →
                       Extensionality a₁ b₁
lower-extensionality a₂ b₂ ext f≡g = cong (λ h → Level.lower ∘ h ∘ lift) $
    ext (cong (lift {ℓ = b₂}) ∘ f≡g ∘ Level.lower {ℓ = a₂})

-- Functional extensionality implies a form of extensionality for
-- Π-types.

∀-extensionality : ∀ {a b} → Extensionality a (suc b) →
                   {A : Set a} (B₁ B₂ : A → Set b) →
                   (∀ x → B₁ x ≡ B₂ x) →
                   (∀ x → B₁ x) ≡ (∀ x → B₂ x)
∀-extensionality ext B₁ B₂ B₁≡B₂ with ext B₁≡B₂
∀-extensionality ext B .B  B₁≡B₂ | refl = refl
