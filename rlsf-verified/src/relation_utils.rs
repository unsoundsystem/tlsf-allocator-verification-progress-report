use vstd::pervasive::*;
use vstd::prelude::*;
use vstd::seq::*;
use vstd::set::Set;

// NOTE: we have to rewrite some parts of vstd::relations because they are using == for equality
//       and Verus has no support for impl PartialEq

verus! {
use vstd::relations::{transitive, equivalence_relation, irreflexive};

pub open spec fn antisymmetric<T>(r: spec_fn(T, T) -> bool, eq: spec_fn(T, T) -> bool) -> bool
    recommends equivalence_relation(eq)
{
    forall|x: T, y: T| #[trigger] r(x, y) && #[trigger] r(y, x) ==> eq(x, y)
}

pub open spec fn connected<T>(r: spec_fn(T, T) -> bool, eq: spec_fn(T, T) -> bool) -> bool {
    forall|x: T, y: T| !eq(x, y) ==> #[trigger] r(x, y) || #[trigger] r(y, x)
}

pub open spec fn strict_total_ordering<T>(r: spec_fn(T, T) -> bool, eq: spec_fn(T, T) -> bool) -> bool
    recommends equivalence_relation(eq)
{
    &&& irreflexive(r)
    &&& antisymmetric(r, eq)
    &&& transitive(r)
    &&& connected(r, eq)
}

pub open spec fn injective<X, Y>(r: spec_fn(X) -> Y, eq1: spec_fn(Y, Y) -> bool, eq2: spec_fn(X, X) -> bool) -> bool
    recommends equivalence_relation(eq1) && equivalence_relation(eq2)
{
    forall|x1: X, x2: X| #[trigger] eq1(r(x1), #[trigger] r(x2)) ==> eq2(x1, x2)
}

}
