use vstd::prelude::*;

verus! {
use vstd::std_specs::bits::{
    u64_trailing_zeros, u64_leading_zeros,
    u32_leading_zeros, u32_trailing_zeros,
    axiom_u64_trailing_zeros
};
use vstd::arithmetic::logarithm::{log, lemma_log_nonnegative};
use vstd::arithmetic::power::{pow, lemma_pow_adds};
use vstd::arithmetic::div_mod::lemma_mod_breakdown;
use vstd::math::abs;
use vstd::calc;

//#[cfg(target_pointer_width = "32")]
//global layout usize is size == 4;

//#[cfg(target_pointer_width = "64")]
//global layout usize is size == 8;

// for codes being executed
#[macro_export]
macro_rules! get_bit {
    ($a:expr, $b:expr) => {{
        (0x1 & ($a >> $b)) == 1
    }};
}

// for spec/proof codes
#[macro_export]
macro_rules! nth_bit {
    ($($a:tt)*) => {
        verus_proof_macro_exprs!(get_bit!($($a)*))
    }
}


// NOTE: following compatibility layer for usize formalization should be removed in future once
//       Verus implements equivalent functionalities

// NOTE: vstd's interface returns u32 for u(64|32)_(leading|trailing)_zeros,
//       except for u64_leading_zeros (this returns int).
//       Thus, aligned the return type at int for spec functions here.

#[cfg(target_pointer_width = "32")]
pub open spec fn usize_leading_zeros(x: usize) -> int
{
    u32_leading_zeros(x as u32) as int
}

#[cfg(target_pointer_width = "64")]
pub open spec fn usize_leading_zeros(x: usize) -> u32
{
    u64_leading_zeros(x as u64) as u32
}


#[cfg(target_pointer_width = "32")]
pub open spec fn usize_trailing_zeros(x: usize) -> u32
{
    u32_trailing_zeros(x as u32) as u32
}

#[cfg(target_pointer_width = "64")]
pub open spec fn usize_trailing_zeros(x: usize) -> u32
{
    u64_trailing_zeros(x as u64) as u32
}

pub assume_specification [usize::leading_zeros] (x: usize) -> (r: u32)
    ensures r == usize_leading_zeros(x)
    opens_invariants none
    no_unwind;

pub assume_specification [usize::trailing_zeros] (x: usize) -> (r: u32)
    ensures r == usize_trailing_zeros(x)
    opens_invariants none
    no_unwind;

#[cfg(target_pointer_width = "64")]
pub proof fn axiom_usize_trailing_zeros(x: usize) {
    axiom_u64_trailing_zeros(x as u64);
}

//pub proof fn power2_log2(x: int)
    //requires is_power_of_two(x)
    //ensures x >> log(2, x) >= 1
use vstd::arithmetic::power::lemma_pow_strictly_increases_converse;
pub proof fn pow2_is_single_bit(x: usize, y: nat)
    requires pow(2, y) == x, x > 0,
    ensures x == 1 << y,
    decreases y,
{
    // TODO
    assert((x as int) < pow(2, usize::BITS as nat)) by (compute);
    assert(pow(2, y) < pow(2, usize::BITS as nat));
    lemma_pow_strictly_increases_converse(2, y, usize::BITS as nat);
    assert(y < usize::BITS as nat);
    assert(y < 64);
    if x == 1 {
        assert(y == 0);
        assert(pow(2, 0) == 1) by (compute);
        assert(1 == 1 << 0) by (bit_vector);
        assert(x == 1 << y);
    } else {
        pow2_is_single_bit(x / 2, (y - 1) as nat);
        assert((x / 2) == 1 << (y - 1));
        lemma_u64_shl_is_mul(1, y as u64);
        assert(1 << y == pow(2, y));
        assert(1 << (y - 1) == pow(2, (y - 1) as nat));
        assert(2*pow(2, (y - 1) as nat) == pow(2, y));
        assert(2*(1 << (y - 1)) == 1 << y);
        //assert(y > 0);
        //assert(pow(2, (y - 1) as nat + 1) == pow(2, y));
        //lemma_pow_adds(2, (y - 1) as nat, 1);
        //assert(pow(2, y) == pow(2, (y - 1) as nat) * pow(2, 1));
        //assert(pow(2, y) == pow(2, (y - 1) as nat) * 2);
        //assert(pow(2, y) == pow(2, (y - 1) as nat) * 2);
        //assert(x / 2 == pow(2, (y - 1) as nat));

    }
}

#[cfg(target_pointer_width = "64")]
pub proof fn usize_trailing_zeros_is_log2_when_pow2_given(x: usize, e: nat)
    requires pow2(e) == x as int
    ensures usize_trailing_zeros(x) == log(2, x as int)
{
    u64_trailing_zeros_is_log2_when_pow2_given(x as u64, e)
}

pub proof fn u64_trailing_zeros_is_log2_when_pow2_given(x: u64, e: nat)
    requires pow2(e) == x as int
    ensures u64_trailing_zeros(x) == log(2, x as int)
    decreases x, e
{
    assert(log(2, x as int) == e) by {
        vstd::arithmetic::power2::lemma_pow2(e);
        vstd::arithmetic::logarithm::lemma_log_pow(2, e);
    };

    vstd::arithmetic::power2::lemma_pow2_pos(e);
    if x == pow2(0) {
        assert(pow2(0) == 1) by (compute);
        reveal(u64_trailing_zeros);
        assert(u64_trailing_zeros(1) == 0) by (compute);
        assert(log(2, 1) == 0) by (compute);
    } else {
        assume(x / 2 == pow2((e - 1) as nat));
        u64_trailing_zeros_is_log2_when_pow2_given(x / 2, (e - 1) as nat);
        assert(u64_trailing_zeros(x / 2) == log(2, x as int / 2));
        assert(x != 0 && x & 1 == 0) by {
            assert(x > 0);
            lemma_u64_last_bit_zero_iff_mul_of_two(x, e);
        };
        reveal(u64_trailing_zeros);
        assert(u64_trailing_zeros(x) == 1 + u64_trailing_zeros(x / 2));
        assert(log(2, x as int) == 1 + log(2, x as int / 2)) by {
            vstd::arithmetic::logarithm::lemma_log_s(2, x as int);
        };
        assert(1 + u64_trailing_zeros(x / 2) == 1 + log(2, x as int / 2));
    }
}


#[cfg(target_pointer_width = "64")]
pub open spec fn usize_rotate_right(x: usize, n: i32) -> usize {
    u64_rotate_right(x as u64, n) as usize
}

pub open spec fn u64_rotate_right(x: u64, n: i32) -> u64 {
    let sa: nat = abs(n as int) as nat % u64::BITS as nat;
    let sa_ctr: nat = (u64::BITS as nat - sa) as nat;
    if n == 0 {
        x
    } else if n > 0 {
        ((x & high_mask_u64(sa)) >> sa) | ((x & low_mask_u64(sa)) << sa_ctr)
    } else { // n < 0
        ((x & low_mask_u64(sa_ctr)) << sa) | ((x & high_mask_u64(sa)) >> sa_ctr)
    }
}

#[cfg(target_pointer_width = "64")]
pub proof fn lemma_usize_rotr_mask_lower(x: usize, n: i32)
    requires
        0 <= n < usize::BITS
    ensures
        usize_rotate_right(x, n) & low_mask_usize((usize::BITS - n) as nat)
            == (x >> n) & low_mask_usize((usize::BITS - n) as nat)
{
    lemma_u64_rotr_mask_lower(x as u64, n)
}

pub proof fn lemma_u64_rotr_mask_lower(x: u64, n: i32)
    requires
        0 <= n < u64::BITS
    ensures
        u64_rotate_right(x, n) & low_mask_u64((u64::BITS - n) as nat)
            == (x >> n) & low_mask_u64((u64::BITS - n) as nat)
{
    if n == 0 {
        let mask = low_mask_u64((u64::BITS - n) as nat);
        assert(x >> 0 == x) by (bit_vector);
        assert(u64_rotate_right(x, n) == x);
    } else {
        assert(n > 0);
        let sa: nat = abs(n as int) as nat % u64::BITS as nat;
        let sa_ctr: nat = (u64::BITS as nat - sa) as nat;
        assert(0 <= sa < u64::BITS);
        assert(0 <= sa_ctr < u64::BITS);
        assert(0 <= n < u64::BITS);
        let rotr_mask1: u64 = high_mask_u64(sa);
        let rotr_mask2: u64 = low_mask_u64(sa);
        let sa = sa as u64;
        let sa_ctr = sa_ctr as u64;
        let n = n as u64;
        let mask = low_mask_u64((u64::BITS - n) as nat);
        lemma_low_mask_u64_values();
        lemma_high_mask_u64_values();
        assert((((x & rotr_mask1) >> sa) | ((x & rotr_mask2) << sa_ctr)) & mask
            == (x >> n) & mask) by (bit_vector);
    }
}

#[cfg(target_pointer_width = "64")]
pub proof fn lemma_low_mask_usize_u64(x: nat)
    ensures low_mask_u64(x) == low_mask_usize(x)
{}

#[cfg(target_pointer_width = "64")]
pub proof fn lemma_duplicate_low_mask_usize(x: usize, n: nat, m: nat)
    requires
        0 <= n <= u64::BITS,
        0 <= m <= u64::BITS,
        n <= m
    ensures
        (x & low_mask_usize(m)) & low_mask_usize(n) == x & low_mask_usize(n)
{
    lemma_duplicate_low_mask_u64(x as u64, n, m);
}

//pub proof fn lemma_low_mask_u64_is_mod(x: u64, n: nat)
    //requires
        //0 <= n < u64::BITS,
    //ensures x & low_mask_u64(n) == ((x as nat) % pow2(n)) as u64
//{
    //if n < u64::BITS {
        //vstd::bits::lemma_u64_low_bits_mask_is_mod(x, n);
        //assume(pow2(n) <= u64::MAX);
        //assume((x as nat) % pow2(n) == ((x as nat) % pow2(n)) as u64);
        //assume(pow2(n) == pow2(n) as u64);
        //vstd::bits::lemma_u64_pow2_no_overflow(n);
        //assert(x % pow2(n) as u64 == ((x as nat) % pow2(n)) as u64);
    //} else {
        //assert(low_mask_u64(u64::BITS as nat) == 18446744073709551615) by (compute);
        //assert(x & 18446744073709551615 == x) by (bit_vector);
        //assert(pow2(u64::BITS as nat) == 18446744073709551616) by (compute);
        //assert(x as nat % 18446744073709551616 == x as nat);
    //}
//}

pub proof fn lemma_duplicate_low_mask_u64(x: u64, n: nat, m: nat)
    requires
        0 <= n <= u64::BITS,
        0 <= m <= u64::BITS,
        n <= m
    ensures
        (x & low_mask_u64(m)) & low_mask_u64(n) == x & low_mask_u64(n)
{
    if n == u64::BITS {
        assert(m == u64::BITS);
        assert(low_mask_u64(u64::BITS as nat) == 18446744073709551615) by (compute);
        assert(x & 18446744073709551615 == x) by (bit_vector);
        assert(pow2(u64::BITS as nat) == 18446744073709551616) by (compute);
    } else if m == u64::BITS {
        assert(low_mask_u64(u64::BITS as nat) == 18446744073709551615) by (compute);
        assert(x & 18446744073709551615 == x) by (bit_vector);
        assert(pow2(u64::BITS as nat) == 18446744073709551616) by (compute);
    } else {
        assert(n < u64::BITS && m < u64::BITS);
        vstd::bits::lemma_u64_pow2_no_overflow(n);
        vstd::bits::lemma_u64_pow2_no_overflow(m);
        assert((x & low_mask_u64(m)) & low_mask_u64(n)
            == x % (pow2(m) as u64) % (pow2(n) as u64)) by {
            vstd::bits::lemma_u64_low_bits_mask_is_mod(x, m);
            vstd::bits::lemma_u64_low_bits_mask_is_mod(x % pow2(m) as u64, n);
        }

        assert((x as int) % (pow2(m) as int) % (pow2(n) as int)
                    == x % (pow2(m) as u64) % (pow2(n) as u64)) by {
            vstd::arithmetic::power2::lemma_pow2_pos(n);
            vstd::arithmetic::power2::lemma_pow2_pos(m);
            assert(pow2(m) != 0);
            assert(pow2(n) != 0);
        };


        assert((x as int)
                % pow2(m) as int
                % pow2(n) as int
            == x as int % pow2(n) as int) by {
            vstd::arithmetic::power2::lemma_pow2_pos(n);
            vstd::arithmetic::power2::lemma_pow2_pos((m - n) as nat);
            assert(pow2(m) as int == pow2((m - n) as nat) * pow2(n)) by {
                vstd::arithmetic::power2::lemma_pow2_adds(n, (m - n) as nat);
            };
            vstd::arithmetic::div_mod::lemma_mod_mod(x as int, pow2(n) as int, pow2((m - n) as nat) as int);
        };

        assert(x as int % pow2(n) as int == x & low_mask_u64(n)) by {
            vstd::bits::lemma_u64_low_bits_mask_is_mod(x, n);
        };
    }
}

proof fn lemma_usize_rotate_right_0_eq(x: usize)
    ensures x == usize_rotate_right(x, 0)
{}

proof fn lemma_usize_shr_0(x: usize) by (bit_vector)
    ensures x == x >> 0
{}

proof fn lemma_usize_shl_0(x: usize) by (bit_vector)
    ensures x == x << 0
{}

proof fn lemma_usize_shr_over(x: usize) by (bit_vector)
    ensures x >> usize::BITS == 0
{}

proof fn lemma_usize_full_mask(x: usize)
    ensures x & usize::MAX == x
{
    assert(x & usize::MAX == x) by (compute);
}

proof fn lemma_usize_rotate_right_mod0_noop(x: usize, n: i32)
    requires n % usize::BITS as i32 == 0
    ensures x == usize_rotate_right(x, n)
{
    let sa = 0nat;
    let sa_ctr = usize::BITS as nat;
    assert(high_mask_usize(0) == usize::MAX) by (compute_only);
    assert(low_mask_usize(0) == 0) by (compute_only);
    assert(low_mask_usize(usize::BITS as nat) == usize::MAX) by (compute_only);
    if n == 0 {
        assert(x == x);
    } else if n > 0 {
        lemma_usize_full_mask(x);
        lemma_usize_shr_0(x);
        lemma_usize_shl_0(x);
        assert(x == (x & usize::MAX) >> 0 | ((x & 0) << (usize::BITS as nat))) by (compute);
    } else {
        lemma_usize_full_mask(x);
        lemma_usize_shr_over(x);
        lemma_usize_shl_0(x);
        assert(x == x | 0) by (bit_vector);
        assert(x == (x & usize::MAX) << 0 | ((x & usize::MAX) >> (usize::BITS as nat))) by (compute);
    }
}

proof fn lemma_usize_rotate_right_distr(x: usize, m: i32, n: i32, l: i32)
    requires m == n + l
    ensures usize_rotate_right(x, m) == usize_rotate_right(usize_rotate_right(x, n), l)
{
    // TODO
}

proof fn lemma_usize_rotate_right_reversible(x: usize, n: i32)
    ensures x == usize_rotate_right(usize_rotate_right(x, n), -(n as int) as i32)
{
    // TODO
    if n == 0 {
        assert(x == usize_rotate_right(usize_rotate_right(x, 0), 0));
    } else if n > 0 {
        assert(-n < 0);
        let sa1: nat = abs(n as int) as nat % usize::BITS as nat;
        let sa_ctr1: nat = (usize::BITS as nat - sa1) as nat;
        let sa2: nat = abs(-(n as int)) as nat % usize::BITS as nat;
        let sa_ctr2: nat = (usize::BITS as nat - sa2) as nat;
    } else {
        assert(-n > 0);
    }
}


use vstd::bits::low_bits_mask;

/// mask with n or higher bits n..usize::BITS set
pub open spec fn high_mask_usize(n: nat) -> usize {
    !low_mask_usize(n)
}

/// masks with bits 0..n set
pub open spec fn low_mask_usize(n: nat) -> usize {
    low_bits_mask(n) as usize
}

/// mask with n or higher bits n..u64::BITS set
pub open spec fn high_mask_u64(n: nat) -> u64 {
    !low_mask_u64(n)
}


pub proof fn lemma_low_mask_u64_values()
    ensures
        low_mask_u64(0) == 0x0,
        low_mask_u64(1) == 0x1,
        low_mask_u64(2) == 0x3,
        low_mask_u64(3) == 0x7,
        low_mask_u64(4) == 0xf,
        low_mask_u64(5) == 0x1f,
        low_mask_u64(6) == 0x3f,
        low_mask_u64(7) == 0x7f,
        low_mask_u64(8) == 0xff,
        low_mask_u64(9) == 0x1ff,
        low_mask_u64(10) == 0x3ff,
        low_mask_u64(11) == 0x7ff,
        low_mask_u64(12) == 0xfff,
        low_mask_u64(13) == 0x1fff,
        low_mask_u64(14) == 0x3fff,
        low_mask_u64(15) == 0x7fff,
        low_mask_u64(16) == 0xffff,
        low_mask_u64(17) == 0x1ffff,
        low_mask_u64(18) == 0x3ffff,
        low_mask_u64(19) == 0x7ffff,
        low_mask_u64(20) == 0xfffff,
        low_mask_u64(21) == 0x1fffff,
        low_mask_u64(22) == 0x3fffff,
        low_mask_u64(23) == 0x7fffff,
        low_mask_u64(24) == 0xffffff,
        low_mask_u64(25) == 0x1ffffff,
        low_mask_u64(26) == 0x3ffffff,
        low_mask_u64(27) == 0x7ffffff,
        low_mask_u64(28) == 0xfffffff,
        low_mask_u64(29) == 0x1fffffff,
        low_mask_u64(30) == 0x3fffffff,
        low_mask_u64(31) == 0x7fffffff,
        low_mask_u64(32) == 0xffffffff,
        low_mask_u64(33) == 0x1ffffffff,
        low_mask_u64(34) == 0x3ffffffff,
        low_mask_u64(35) == 0x7ffffffff,
        low_mask_u64(36) == 0xfffffffff,
        low_mask_u64(37) == 0x1fffffffff,
        low_mask_u64(38) == 0x3fffffffff,
        low_mask_u64(39) == 0x7fffffffff,
        low_mask_u64(40) == 0xffffffffff,
        low_mask_u64(41) == 0x1ffffffffff,
        low_mask_u64(42) == 0x3ffffffffff,
        low_mask_u64(43) == 0x7ffffffffff,
        low_mask_u64(44) == 0xfffffffffff,
        low_mask_u64(45) == 0x1fffffffffff,
        low_mask_u64(46) == 0x3fffffffffff,
        low_mask_u64(47) == 0x7fffffffffff,
        low_mask_u64(48) == 0xffffffffffff,
        low_mask_u64(49) == 0x1ffffffffffff,
        low_mask_u64(50) == 0x3ffffffffffff,
        low_mask_u64(51) == 0x7ffffffffffff,
        low_mask_u64(52) == 0xfffffffffffff,
        low_mask_u64(53) == 0x1fffffffffffff,
        low_mask_u64(54) == 0x3fffffffffffff,
        low_mask_u64(55) == 0x7fffffffffffff,
        low_mask_u64(56) == 0xffffffffffffff,
        low_mask_u64(57) == 0x1ffffffffffffff,
        low_mask_u64(58) == 0x3ffffffffffffff,
        low_mask_u64(59) == 0x7ffffffffffffff,
        low_mask_u64(60) == 0xfffffffffffffff,
        low_mask_u64(61) == 0x1fffffffffffffff,
        low_mask_u64(62) == 0x3fffffffffffffff,
        low_mask_u64(63) == 0x7fffffffffffffff,
        low_mask_u64(64) == 0xffffffffffffffff,
{
    reveal(pow2);
    assert(
        low_mask_u64(0) == 0x0 &&
        low_mask_u64(1) == 0x1 &&
        low_mask_u64(2) == 0x3 &&
        low_mask_u64(3) == 0x7 &&
        low_mask_u64(4) == 0xf &&
        low_mask_u64(5) == 0x1f &&
        low_mask_u64(6) == 0x3f &&
        low_mask_u64(0) == 0x0 &&
        low_mask_u64(1) == 0x1 &&
        low_mask_u64(2) == 0x3 &&
        low_mask_u64(3) == 0x7 &&
        low_mask_u64(4) == 0xf &&
        low_mask_u64(5) == 0x1f &&
        low_mask_u64(6) == 0x3f &&
        low_mask_u64(7) == 0x7f &&
        low_mask_u64(8) == 0xff &&
        low_mask_u64(9) == 0x1ff &&
        low_mask_u64(10) == 0x3ff &&
        low_mask_u64(11) == 0x7ff &&
        low_mask_u64(12) == 0xfff &&
        low_mask_u64(13) == 0x1fff &&
        low_mask_u64(14) == 0x3fff &&
        low_mask_u64(15) == 0x7fff &&
        low_mask_u64(16) == 0xffff &&
        low_mask_u64(17) == 0x1ffff &&
        low_mask_u64(18) == 0x3ffff &&
        low_mask_u64(19) == 0x7ffff &&
        low_mask_u64(20) == 0xfffff &&
        low_mask_u64(21) == 0x1fffff &&
        low_mask_u64(22) == 0x3fffff &&
        low_mask_u64(23) == 0x7fffff &&
        low_mask_u64(24) == 0xffffff &&
        low_mask_u64(25) == 0x1ffffff &&
        low_mask_u64(26) == 0x3ffffff &&
        low_mask_u64(27) == 0x7ffffff &&
        low_mask_u64(28) == 0xfffffff &&
        low_mask_u64(29) == 0x1fffffff &&
        low_mask_u64(30) == 0x3fffffff &&
        low_mask_u64(31) == 0x7fffffff &&
        low_mask_u64(32) == 0xffffffff &&
        low_mask_u64(33) == 0x1ffffffff &&
        low_mask_u64(34) == 0x3ffffffff &&
        low_mask_u64(35) == 0x7ffffffff &&
        low_mask_u64(36) == 0xfffffffff &&
        low_mask_u64(37) == 0x1fffffffff &&
        low_mask_u64(38) == 0x3fffffffff &&
        low_mask_u64(39) == 0x7fffffffff &&
        low_mask_u64(40) == 0xffffffffff &&
        low_mask_u64(41) == 0x1ffffffffff &&
        low_mask_u64(42) == 0x3ffffffffff &&
        low_mask_u64(43) == 0x7ffffffffff &&
        low_mask_u64(44) == 0xfffffffffff &&
        low_mask_u64(45) == 0x1fffffffffff &&
        low_mask_u64(46) == 0x3fffffffffff &&
        low_mask_u64(47) == 0x7fffffffffff &&
        low_mask_u64(48) == 0xffffffffffff &&
        low_mask_u64(49) == 0x1ffffffffffff &&
        low_mask_u64(50) == 0x3ffffffffffff &&
        low_mask_u64(51) == 0x7ffffffffffff &&
        low_mask_u64(52) == 0xfffffffffffff &&
        low_mask_u64(53) == 0x1fffffffffffff &&
        low_mask_u64(54) == 0x3fffffffffffff &&
        low_mask_u64(55) == 0x7fffffffffffff &&
        low_mask_u64(56) == 0xffffffffffffff &&
        low_mask_u64(57) == 0x1ffffffffffffff &&
        low_mask_u64(58) == 0x3ffffffffffffff &&
        low_mask_u64(59) == 0x7ffffffffffffff &&
        low_mask_u64(60) == 0xfffffffffffffff &&
        low_mask_u64(61) == 0x1fffffffffffffff &&
        low_mask_u64(62) == 0x3fffffffffffffff &&
        low_mask_u64(63) == 0x7fffffffffffffff &&
        low_mask_u64(64) == 0xffffffffffffffff
    ) by (compute_only);
}

proof fn lemma_high_mask_u64_values()
    ensures
        high_mask_u64(0)  == 0xffffffffffffffff,
        high_mask_u64(1)  == 0xfffffffffffffffe,
        high_mask_u64(2)  == 0xfffffffffffffffc,
        high_mask_u64(3)  == 0xfffffffffffffff8,
        high_mask_u64(4)  == 0xfffffffffffffff0,
        high_mask_u64(5)  == 0xffffffffffffffe0,
        high_mask_u64(6)  == 0xffffffffffffffc0,
        high_mask_u64(7)  == 0xffffffffffffff80,
        high_mask_u64(8)  == 0xffffffffffffff00,
        high_mask_u64(9)  == 0xfffffffffffffe00,
        high_mask_u64(10) == 0xfffffffffffffc00,
        high_mask_u64(11) == 0xfffffffffffff800,
        high_mask_u64(12) == 0xfffffffffffff000,
        high_mask_u64(13) == 0xffffffffffffe000,
        high_mask_u64(14) == 0xffffffffffffc000,
        high_mask_u64(15) == 0xffffffffffff8000,
        high_mask_u64(16) == 0xffffffffffff0000,
        high_mask_u64(17) == 0xfffffffffffe0000,
        high_mask_u64(18) == 0xfffffffffffc0000,
        high_mask_u64(19) == 0xfffffffffff80000,
        high_mask_u64(20) == 0xfffffffffff00000,
        high_mask_u64(21) == 0xffffffffffe00000,
        high_mask_u64(22) == 0xffffffffffc00000,
        high_mask_u64(23) == 0xffffffffff800000,
        high_mask_u64(24) == 0xffffffffff000000,
        high_mask_u64(25) == 0xfffffffffe000000,
        high_mask_u64(26) == 0xfffffffffc000000,
        high_mask_u64(27) == 0xfffffffff8000000,
        high_mask_u64(28) == 0xfffffffff0000000,
        high_mask_u64(29) == 0xffffffffe0000000,
        high_mask_u64(30) == 0xffffffffc0000000,
        high_mask_u64(31) == 0xffffffff80000000,
        high_mask_u64(32) == 0xffffffff00000000,
        high_mask_u64(33) == 0xfffffffe00000000,
        high_mask_u64(34) == 0xfffffffc00000000,
        high_mask_u64(35) == 0xfffffff800000000,
        high_mask_u64(36) == 0xfffffff000000000,
        high_mask_u64(37) == 0xffffffe000000000,
        high_mask_u64(38) == 0xffffffc000000000,
        high_mask_u64(39) == 0xffffff8000000000,
        high_mask_u64(40) == 0xffffff0000000000,
        high_mask_u64(41) == 0xfffffe0000000000,
        high_mask_u64(42) == 0xfffffc0000000000,
        high_mask_u64(43) == 0xfffff80000000000,
        high_mask_u64(44) == 0xfffff00000000000,
        high_mask_u64(45) == 0xffffe00000000000,
        high_mask_u64(46) == 0xffffc00000000000,
        high_mask_u64(47) == 0xffff800000000000,
        high_mask_u64(48) == 0xffff000000000000,
        high_mask_u64(49) == 0xfffe000000000000,
        high_mask_u64(50) == 0xfffc000000000000,
        high_mask_u64(51) == 0xfff8000000000000,
        high_mask_u64(52) == 0xfff0000000000000,
        high_mask_u64(53) == 0xffe0000000000000,
        high_mask_u64(53) == 0xffe0000000000000,
        high_mask_u64(54) == 0xffc0000000000000,
        high_mask_u64(55) == 0xff80000000000000,
        high_mask_u64(56) == 0xff00000000000000,
        high_mask_u64(57) == 0xfe00000000000000,
        high_mask_u64(58) == 0xfc00000000000000,
        high_mask_u64(59) == 0xf800000000000000,
        high_mask_u64(60) == 0xf000000000000000,
        high_mask_u64(61) == 0xe000000000000000,
        high_mask_u64(62) == 0xc000000000000000,
        high_mask_u64(63) == 0x8000000000000000,
        high_mask_u64(64) == 0x0000000000000000,
{
    reveal(pow2);
    assert(
        high_mask_u64(0)  == 0xffffffffffffffff &&
        high_mask_u64(1)  == 0xfffffffffffffffe &&
        high_mask_u64(2)  == 0xfffffffffffffffc &&
        high_mask_u64(3)  == 0xfffffffffffffff8 &&
        high_mask_u64(4)  == 0xfffffffffffffff0 &&
        high_mask_u64(5)  == 0xffffffffffffffe0 &&
        high_mask_u64(6)  == 0xffffffffffffffc0 &&
        high_mask_u64(7)  == 0xffffffffffffff80 &&
        high_mask_u64(8)  == 0xffffffffffffff00 &&
        high_mask_u64(9)  == 0xfffffffffffffe00 &&
        high_mask_u64(10) == 0xfffffffffffffc00 &&
        high_mask_u64(11) == 0xfffffffffffff800 &&
        high_mask_u64(12) == 0xfffffffffffff000 &&
        high_mask_u64(13) == 0xffffffffffffe000 &&
        high_mask_u64(14) == 0xffffffffffffc000 &&
        high_mask_u64(15) == 0xffffffffffff8000 &&
        high_mask_u64(16) == 0xffffffffffff0000 &&
        high_mask_u64(17) == 0xfffffffffffe0000 &&
        high_mask_u64(18) == 0xfffffffffffc0000 &&
        high_mask_u64(19) == 0xfffffffffff80000 &&
        high_mask_u64(20) == 0xfffffffffff00000 &&
        high_mask_u64(21) == 0xffffffffffe00000 &&
        high_mask_u64(22) == 0xffffffffffc00000 &&
        high_mask_u64(23) == 0xffffffffff800000 &&
        high_mask_u64(24) == 0xffffffffff000000 &&
        high_mask_u64(25) == 0xfffffffffe000000 &&
        high_mask_u64(26) == 0xfffffffffc000000 &&
        high_mask_u64(27) == 0xfffffffff8000000 &&
        high_mask_u64(28) == 0xfffffffff0000000 &&
        high_mask_u64(29) == 0xffffffffe0000000 &&
        high_mask_u64(30) == 0xffffffffc0000000 &&
        high_mask_u64(31) == 0xffffffff80000000 &&
        high_mask_u64(32) == 0xffffffff00000000 &&
        high_mask_u64(33) == 0xfffffffe00000000 &&
        high_mask_u64(34) == 0xfffffffc00000000 &&
        high_mask_u64(35) == 0xfffffff800000000 &&
        high_mask_u64(36) == 0xfffffff000000000 &&
        high_mask_u64(37) == 0xffffffe000000000 &&
        high_mask_u64(38) == 0xffffffc000000000 &&
        high_mask_u64(39) == 0xffffff8000000000 &&
        high_mask_u64(40) == 0xffffff0000000000 &&
        high_mask_u64(41) == 0xfffffe0000000000 &&
        high_mask_u64(42) == 0xfffffc0000000000 &&
        high_mask_u64(43) == 0xfffff80000000000 &&
        high_mask_u64(44) == 0xfffff00000000000 &&
        high_mask_u64(45) == 0xffffe00000000000 &&
        high_mask_u64(46) == 0xffffc00000000000 &&
        high_mask_u64(47) == 0xffff800000000000 &&
        high_mask_u64(48) == 0xffff000000000000 &&
        high_mask_u64(49) == 0xfffe000000000000 &&
        high_mask_u64(50) == 0xfffc000000000000 &&
        high_mask_u64(51) == 0xfff8000000000000 &&
        high_mask_u64(52) == 0xfff0000000000000 &&
        high_mask_u64(53) == 0xffe0000000000000 &&
        high_mask_u64(54) == 0xffc0000000000000 &&
        high_mask_u64(55) == 0xff80000000000000 &&
        high_mask_u64(56) == 0xff00000000000000 &&
        high_mask_u64(57) == 0xfe00000000000000 &&
        high_mask_u64(58) == 0xfc00000000000000 &&
        high_mask_u64(59) == 0xf800000000000000 &&
        high_mask_u64(60) == 0xf000000000000000 &&
        high_mask_u64(61) == 0xe000000000000000 &&
        high_mask_u64(62) == 0xc000000000000000 &&
        high_mask_u64(63) == 0x8000000000000000 &&
        high_mask_u64(64) == 0x0000000000000000
        ) by (compute_only);
}

proof fn lemma_mask_64_basics(n: nat)
    requires 0 <= n < u64::BITS
    ensures
        0 & high_mask_u64(n) == 0,
        0 & low_mask_u64(n) == 0,
        //forall|i: nat, u: u64| n <= i < u64::BITS ==>
        //    !nth_bit!(u & low_mask_u64(n), i as u32),
        //forall|i: nat, u: u64| 0 <= i < n ==>
        //    !nth_bit!(u & high_mask_u64(n), i as u32)
{
    u64_bits_basics(high_mask_u64(n));
    u64_bits_basics(low_mask_u64(n));
}

proof fn u64_bits_basics(x: u64) by (bit_vector)
    ensures
        0 & x == 0,
        x & 0 == 0,
        x | 0 == x,
        0 | x == x,
        x >> 0 == 0,
        0 >> x == 0,
        x << 0 == 0,
        0 << x == 0,
{}

/// masks with bits 0..n set
pub open spec fn low_mask_u64(n: nat) -> u64 {
    low_bits_mask(n) as u64
}


#[cfg(target_pointer_width = "64")]
pub assume_specification [usize::rotate_right] (x: usize, n: u32) -> (r: usize)
    // This primitive cast just work as usual exec code
    // NOTE: is it ok? primitive cast really just reinterpet bytes?
    //      ref. `unsigned_to_signed`
    ensures r == usize_rotate_right(x, n as i32)
    opens_invariants none
    no_unwind;

use vstd::bits::*;
use vstd::arithmetic::power2::*;

proof fn example5() {
//    reveal(pow2);
//    lemma_low_bits_mask_values();
//    assert(usize_rotate_right(1, 1) == 1usize << 63) by (compute);
//    assert(usize_rotate_right(1usize << 63, -1) == 1) by (compute);
//    assert(usize_rotate_right(0xbeef00000000dead, -16) == 0xdeadbeef) by (compute);
//    assert(usize_rotate_right(0xbeef00000000dead, 16) == 0xdeadbeef00000000) by (compute);
//    assert(usize_rotate_right(0xdeadbeef, 128) == 0xdeadbeef) by (compute);
//    assert(usize_rotate_right(0xdeadbeef, -128) == 0xdeadbeef) by (compute);
//    assert(usize_rotate_right(usize_rotate_right(0xdeadbeef, -1234), 1234) == 0xdeadbeef) by (compute);
//    assert(0xfffffff0u32 as i32 == -16int) by (bit_vector);
//    assert(usize_rotate_right(0xbeef00000000dead, 0xfffffff0u32 as i32) == 0xdeadbeef);
//    // NOTE: 
//    // - it seems `0xXXXu32 as i32` can be solved by bit_vector only 
//    //   (by (compute) doesn't terminate)
//    // - lemma around `usize_rotate_right` requires separate `assert` for `0xXXu32 as i32`
}

proof fn unsigned_to_signed(n: u32) by (bit_vector)
    ensures
        0 <= n && n <= 0x7fffffffu32 ==> (n as i32) >= 0,
        0x7fffffff < n ==> (n as i32) < 0,
{}

// NOTE: no need to conditoinal compilation for external spec using `usize_wrapping_*`
//      because `usize::` implicitly branch for the appropriate architecture.


pub open spec fn is_power_of_two(n: int) -> bool
{
    exists|p: nat| n == pow2(p) as int
}


// proof equivalence with above definition if needed
pub open spec fn is_power_of_two_rec(n: int) -> bool
    decreases n
{
     if n <= 0 {
         false
     } else if n == 1 {
         true
     } else {
         n % 2 == 0 && is_power_of_two_rec(n / 2)
     } 
}


use vstd::bits::lemma_u64_low_bits_mask_is_mod;

#[cfg(target_pointer_width = "64")]
proof fn lemma_usize_low_bits_mask_is_mod(x: usize, n: nat) {
    lemma_u64_low_bits_mask_is_mod(x as u64, n);
}

#[inline(always)]
pub fn bit_scan_forward(b: usize, start: u32) -> u32 {
    if start >= usize::BITS {
        usize::BITS
    } else {
        usize_hight_mask(b, start).trailing_zeros()
    }
}

// mask with start..usize::BITS bits set
#[inline(always)]
pub fn usize_hight_mask(b: usize, start: u32) -> usize {
    b & !(usize::MAX >> start)
}

pub assume_specification [usize::saturating_sub] (x: usize, y: usize) -> (r: usize)
    ensures
        x as int - y as int <= 0 ==> r == 0,
        x as int - y as int > 0 ==> r == x - y,
    opens_invariants none
    no_unwind;

pub proof fn usize_leading_trailing_zeros(x: usize)
by (nonlinear_arith)
    requires x != 0
    ensures usize_leading_zeros(x) + usize_trailing_zeros(x) < 64
{}

pub proof fn granularity_is_power_of_two()
    ensures is_power_of_two(size_of::<usize>() * 4)
{
    assert(is_power_of_two(size_of::<usize>() * 4)) by {
        assert(is_power_of_two(32)) by {
            reveal(pow2);
            assert(32 == pow2(5) as int) by (compute);
        };
        assert(is_power_of_two(16))  by {
            reveal(pow2);
            assert(16 == pow2(4) as int) by (compute);
        };
    };
}

use vstd::std_specs::bits::group_bits_axioms;
pub proof fn mask_higher_bits_leq_mask(x: usize, y: usize)
    by (bit_vector)
    requires 0 < y
    ensures x & ((y - 1) as usize) < y
{
}

proof fn log2_div_sub_distr(x: int, y: int) by (nonlinear_arith)
    requires  exists|n: int| n >= 0 && x == #[trigger] (n*y)
    ensures
        log(2, x) - log(2, y) == log(2, x / y)
{
    admit()
    //let n = choose|n: int| n >= 0 && x == #[trigger] (n*y);
    //if y == 0 {
        //assert(x == 0);
        //assert(log(2, 0) - log(2, 0) == log(2, 0int / 0int));
    //} else {

    //}
}

#[cfg(target_pointer_width = "64")]
pub proof fn log2_using_leading_zeros_usize(x: usize) by (nonlinear_arith)
    requires x > 0
    ensures log(2, x as int) == usize::BITS - usize_leading_zeros(x) - 1
{
    log2_using_leading_zeros_u64(x as u64)
}

proof fn log2_using_leading_zeros_u64(x: u64)
    requires x > 0
    ensures log(2, x as int) == u64::BITS - u64_leading_zeros(x) - 1
    decreases x
{
    if x == 1 {
        reveal(u64_leading_zeros);
        assert(u64_leading_zeros(1) == 63) by (compute);
        assert(log(2, 1) == 0) by {
            reveal(log);
        };
        assert(log(2, 1) == u64::BITS - u64_leading_zeros(1) - 1) by (compute);
    } else {
            assert(x >= 2);
            log2_using_leading_zeros_u64(x / 2);
            assert(log(2, x as int / 2) == u64::BITS - u64_leading_zeros(x / 2) - 1);
            vstd::arithmetic::logarithm::lemma_log_s(2, x as int);

            assert(1 + log(2, x as int / 2) == 1 + u64::BITS - u64_leading_zeros(x / 2) - 1);

            // 1 + log(2, x as int / 2) = ...
            assert(1 + log(2, x as int / 2) == log(2, x as int));

            // 1 + u64::BITS - u64_leading_zeros(x / 2) - 1 = ..
            assert(1 + u64::BITS - u64_leading_zeros(x / 2) - 1 == u64::BITS - (u64_leading_zeros(x / 2) - 1) - 1);
            assert(u64_leading_zeros(x / 2) - 1 == u64_leading_zeros(x)) by {
                assert(x / 2 != 0);
                reveal(u64_leading_zeros);
            };

            assert(log(2, x as int) == u64::BITS - u64_leading_zeros(x) - 1);
    }
}

proof fn lemma_div2_leading_zeros_suc(x: u64)
    requires x > 1
    ensures u64_leading_zeros(x / 2) == 1 + u64_leading_zeros(x)
    decreases x
{
    if x == 2 || x == 3 {
        reveal(u64_leading_zeros);
        assert(u64_leading_zeros(2) == 62) by (compute);
        assert(u64_leading_zeros(2u64 / 2) == 1 + u64_leading_zeros(2)) by (compute);
    } else {
        assert(x / 2 == x >> 1) by (bit_vector);
        assert(x >= 4);
        lemma_div2_leading_zeros_suc(x / 2);

        assert(u64_leading_zeros(x >> 1) == 1 + u64_leading_zeros(x)) by {
            reveal(u64_leading_zeros);
            broadcast use vstd::std_specs::bits::group_bits_axioms;
        };
    }
}


proof fn lemma_div2_trailing_zeros_dec(x: u64)
    requires x > 1, exists|n: nat| x == pow2(n)
    ensures u64_trailing_zeros(x / 2) == u64_trailing_zeros(x) - 1
    decreases x
{
    if x == 2 {
        reveal(u64_trailing_zeros);
        assert(u64_trailing_zeros(2) == 1) by (compute);
        assert(u64_trailing_zeros(1) == 0) by (compute);
        assert(x / 2 == 1);
        assert(u64_trailing_zeros(1) == 1 - 1) by (compute);
    } else {
        admit()
        //assert(x / 2 == x >> 1) by (bit_vector);

        //assert(x >= 4) by {
            //broadcast use vstd::arithmetic::power::group_pow_properties;
        //};
        //let n = choose|n: nat| x == pow2(n);
        //assert(x > 2);
        //assert(pow2(1) == 2) by (compute);
        //broadcast use vstd::arithmetic::power::group_pow_properties;
        //vstd::arithmetic::power2::lemma_pow2_strictly_increases(1, n);
        //vstd::arithmetic::power2::lemma_pow2_unfold(n);
        //assert(x / 2 == pow2((n - 1) as nat));
        //lemma_div2_trailing_zeros_dec(x / 2);

        //assert(u64_trailing_zeros(x >> 1) == u64_trailing_zeros(x) - 1) by {
            //reveal(u64_trailing_zeros);
            //broadcast use vstd::std_specs::bits::group_bits_axioms;
        //};
    }
}

proof fn lemma_low_mask_pow2_pred(m: int, n: nat)
    requires m > 0, m == pow2(n) as int
    ensures low_mask_usize(n) == m - 1
{
    // TODO
    admit()
}

proof fn lemma_low_mask_pow2_pred_u64(m: u64, n: nat)
    requires m > 0, m == pow2(n) as int
    ensures low_mask_u64(n) == m - 1
    decreases m, n
{
    assert(low_bits_mask(n) == pow2(n) - 1);
    assert(low_bits_mask(n) as u64 == m - 1) by {
        lemma_pow2_u64_width(m, n);
        assert(m == pow2(n));
    };
}

#[cfg(target_pointer_width = "64")]
pub proof fn bit_mask_is_mod_for_pow2(x: usize, m: usize)
    requires m > 0, is_power_of_two(m as int)
    ensures x & (m - 1) as usize == x % m 
    decreases x, m
{
    bit_mask_is_mod_for_pow2_u64(x as u64, m as u64);
}

proof fn lemma_pow2_u64_width(x: u64, n: nat)
    requires x == pow2(n)
    ensures 0 <= n < u64::BITS
{
    assert(0 <= x <= u64::MAX);
    vstd::arithmetic::logarithm::lemma_log_is_ordered(2, pow2(n) as int, u64::MAX as int);
    vstd::arithmetic::logarithm::lemma_log_pow(2, n);
    vstd::arithmetic::power2::lemma_pow2(n);
    assert(n <= log(2, u64::MAX as int));
    assert(log(2, u64::MAX as int) < u64::BITS) by (compute);
}

proof fn bit_mask_is_mod_for_pow2_u64(x: u64, m: u64)
    requires m > 0, is_power_of_two(m as int)
    ensures x & (m - 1) as u64 == x % m
    //decreases x, m
{
    let n = choose|n: nat| m == pow2(n);
    lemma_pow2_u64_width(m, n);
    vstd::bits::lemma_u64_low_bits_mask_is_mod(x, n);
    lemma_low_mask_pow2_pred(m as int, n);
}

pub proof fn lemma_pow2_log2_div_is_one(x: int)
    requires 0 < x
    ensures x / pow2(log(2, x) as nat) as int == 1
    decreases x
{
    vstd::arithmetic::logarithm::lemma_log_nonnegative(2, x);
    if x == 1 {
        reveal(pow2);
        reveal(log);
        assert(1int / pow2(log(2, 1) as nat) as int == 1) by (compute);
    } else {
        assert(x > 1);
        assert(x / pow2(log(2, x) as nat) as int
            == x / pow2((1 + log(2, x / 2)) as nat) as int) by {
            vstd::arithmetic::logarithm::lemma_log_s(2, x);
        };
        assert(x / (pow2((1 + log(2, x / 2)) as nat) as int)
            == x / (2 * pow2(log(2, x / 2) as nat) as int)) by {

            assert(1 + log(2, x / 2) > 0) by {
                assert(2 <= x);
                vstd::arithmetic::logarithm::lemma_log_is_ordered(2, 2, x);
                vstd::arithmetic::logarithm::lemma_log_s(2, x);
                assert(log(2, 2) == 1) by (compute);
            };

            vstd::arithmetic::power2::lemma_pow2_unfold((1 + log(2, x / 2)) as nat);
            assert(pow2((1 + log(2, x / 2)) as nat) == 2 * pow2(log(2, x / 2) as nat));

        }
        assert(x / (2 * pow2(log(2, x / 2) as nat) as int)
            == (x / 2) / (pow2(log(2, x / 2) as nat) as int)) by {
            vstd::arithmetic::power2::lemma_pow2_pos(log(2, x / 2) as nat);
            vstd::arithmetic::div_mod::lemma_div_denominator(x, 2, pow2(log(2, x / 2) as nat) as int);
        };
        lemma_pow2_log2_div_is_one(x / 2);
        vstd::arithmetic::power2::lemma_pow2_unfold(x as nat);
    }
}

pub proof fn log2_power_in_range(p: int)
    requires 0 < p
    ensures pow2(log(2, p) as nat) <= p < pow2(log(2, p) as nat + 1)
    decreases p
{
    if 1 == p {
        assert(p + 1 == 2);
        assert(pow2(log(2, 1) as nat) <= 1 < pow2(log(2, 1) as nat + 1)) by (compute);
    } else {
        log2_power_in_range(p / 2);
        assert(log(2, p) == 1 + log(2, p / 2)) by {
            vstd::arithmetic::logarithm::lemma_log_s(2, p);
        };
        assert(pow2(log(2, p) as nat) == pow2(1 + log(2, p / 2) as nat)) by {
            vstd::arithmetic::logarithm::lemma_log_nonnegative(2, p);
            vstd::arithmetic::logarithm::lemma_log_nonnegative(2, p / 2);
            assert(log(2, p) as nat == 1 + log(2, p / 2) as nat);
        };
        assert(pow2(1 + log(2, (p / 2)) as nat) == 2 * pow2(log(2, p / 2) as nat)) by {
            vstd::arithmetic::power2::lemma_pow2_unfold(1 + log(2, (p / 2)) as nat);
        };
        assert(p / 2 < pow2(log(2, p / 2) as nat + 1));
        assert(p < 2*pow2(log(2, p / 2) as nat + 1));
        assert(p < 2*pow2((log(2, p) - 1) as nat + 1));
        assert(p < pow2((log(2, p) - 1) as nat + 1 + 1)) by {
            assert(2*pow2((log(2, p) - 1) as nat + 1) == pow2((log(2, p) - 1) as nat + 1 + 1)) by {
                vstd::arithmetic::power2::lemma_pow2_unfold((log(2, p) - 1) as nat + 1 + 1);
            };
        };
        assert(pow2((log(2, p) - 1) as nat + 1 + 1) == pow2(log(2, p) as nat + 1)) by {
            assert(p > 1);
            vstd::arithmetic::logarithm::lemma_log_is_ordered(2, 2, p);
            assert(log(2, 2) == 1) by (compute);
            assert(log(2, p) > 0);
            assert(log(2, p) - 1 >= 0);
            assert((log(2, p) - 1) as nat + 1 + 1 == log(2, p) as nat + 1);
        };
    }
}

pub proof fn lemma_mod_by_multiple(x: int, y: int, z: int) by (integer_ring)
    requires x % (y * z) == 0
    ensures x % z == 0
{}

pub proof fn lemma_log2_sn(x: int, n: nat)
    requires 0 < x, x % pow2(n) as int == 0
    ensures log(2, x) == n + log(2, x / pow2(n) as int)
    decreases n
{
    if n == 0 {
        assert(pow2(0) == 1) by (compute);
        assert(log(2, x) == 0 + log(2, x / 1));
    } else {
        assert(n > 0);
        assert(x % pow2((n - 1) as nat) as int == 0) by {
            assert(pow2(n) == 2 * pow2((n - 1) as nat)) by {
                vstd::arithmetic::power2::lemma_pow2_unfold(n);
            };
            assert(x % pow2(n) as int == 0);
            assert(0 != pow2((n - 1) as nat)) by {
                vstd::arithmetic::power2::lemma_pow2_pos((n - 1) as nat);
            };
            assert(x % (2 * pow2((n - 1) as nat) as int) == 0);
            lemma_mod_by_multiple(x as int, 2, pow2((n - 1) as nat) as int);
        };
        lemma_log2_sn(x, (n - 1) as nat);
        assert(log(2, x / pow2((n - 1) as nat) as int) == 1 + log(2, x / pow2(n) as int)) by {
            assert(1 + log(2, x / pow2(n) as int) == log(2, 2 * (x / pow2(n) as int))) by {
                vstd::arithmetic::power2::lemma_pow2_pos(n);
                lemma_mod_zeros_and_pos(x, pow2(n) as int);
                lemma_log_mul_base(x / pow2(n) as int, 2);
            };
            assert(2 * (x / pow2(n) as int) == x / pow2((n - 1) as nat) as int) by {
                vstd::arithmetic::power2::lemma_pow2_pos(n);
                vstd::arithmetic::power2::lemma_pow2_pos((n - 1) as nat);
                assert(pow2(n) == 2 * pow2((n - 1) as nat)) by {
                    vstd::arithmetic::power2::lemma_pow2_unfold(n);
                };
                lemma_div_by_multiple_fancy(x, pow2(n) as int, pow2((n - 1) as nat) as int);
            };
        };
    }
}

pub proof fn lemma_mod_zeros_and_pos(x: int, y: int) by (nonlinear_arith)
    requires x > 0, y > 0, x % y == 0
    ensures x / y > 0
{
}

pub proof fn lemma_div_by_multiple_fancy(b: int, c: int, d: int) by (nonlinear_arith)
    requires b > 0, c > 0, d > 0, c == 2 * d, b % c == 0
    ensures 2 * (b / c) == b / d
{}

pub proof fn lemma_log_mul_base(x: int, b: int)
    requires b > 1, x > 0
    ensures log(b, b * x) == 1 + log(b, x)
{
    assert(b <= b * x) by {
        vstd::arithmetic::mul::lemma_mul_ordering(x, b);
    };
    vstd::arithmetic::logarithm::lemma_log_s(b, b * x);
    assert(b * x / b == x) by {
        vstd::arithmetic::div_mod::lemma_div_multiples_vanish(x, b);
    };
}

pub proof fn lemma_pow2_mod(x: int, n: nat)
    requires 0 < n, x % pow2(n) as int == 0
    ensures x % pow2((n - 1) as nat) as int == 0
{}



pub proof fn lemma_log2_distributes(b1: int, b2: int)
    requires b1 % b2 == 0, b1 > 0, b2 > 0, is_power_of_two(b2)
    ensures log(2, b1 / b2) == log(2, b1) - log(2, b2)
{
    // log2(size) = 1 + log2(size / 2)
    //            = 1 + 1 + log2(size / 4)
    //            = 1 + ... + 1 + log2(size / 2^log2(G))
    //              +---------+
    //                  = log2(G)
    //            = log2(G) + log2(size / G)
    assert(exists|i: nat| pow2(i) == b2);
    let log2b2 = choose|i: nat| pow2(i) == b2;
    assert(log(2, b2) == log2b2) by {
        assert(b2 == pow2(log2b2));
        vstd::arithmetic::power2::lemma_pow2(log2b2);
        vstd::arithmetic::logarithm::lemma_log_pow(2, log2b2);
    };
    assert(log(2, b1 / pow2(log2b2) as int) + log(2, b2) == log(2, b1)) by {
        lemma_log2_sn(b1, log2b2);
    };
}

pub proof fn lemma_mask_dup_idemp(x: usize, m: nat, n: nat)
    requires m <= n
    ensures x & low_mask_usize(n) & low_mask_usize(m) == x & low_mask_usize(m)
{
    admit();
    let n_mask = low_mask_usize(n);
    let m_mask = low_mask_usize(m);
    assume(m_mask < n_mask);
    assert(x & n_mask & m_mask == x & m_mask);
}


pub proof fn lemma_div_by_powlog(x: int, y: int, z: int) by (nonlinear_arith)
    requires x > 0, y > 0, z > 0, x < y
    ensures z / pow2(log(2, x) as nat) as int > z / y
{
    lemma_pow2_log2_div_is_one(x);
}

pub proof fn lemma_powlog_leq(x: int) by (nonlinear_arith)
    requires x > 0
    ensures pow2(log(2, x) as nat) <= x
{
    lemma_pow2_log2_div_is_one(x);
    assert(x / pow2(log(2, x) as nat) as int == 1);
    assume(1 <= x / pow2(log(2, x) as nat) as int);
}

pub proof fn log2_power_ordered(x: int, y: int)
    requires 0 < x, 1 < y,
        log(2, x) < log(2, y)
    ensures x < y
    decreases x, y
{
    if x == 1 {
        assert(log(2, 1) == 0) by (compute);
        assert(0 < log(2, y));
        assert(1 < y);
        assert(x < y);
    } else {
        assert(1 < x);
        assert(log(2, x) >= 1) by {
            assert(log(2, 2) == 1) by (compute);
            vstd::arithmetic::logarithm::lemma_log_is_ordered(2, 2, x);
        };
        assert(log(2, y) >= 1) by {
            log2_power_ordered(x / 2, y / 2);
            assert(log(2, x / 2) < log(2, y / 2) ==> x / 2 < y / 2);
            assert(log(2, x / 2) < log(2, y / 2) <==> log(2, x) < log(2, y)) by {
                vstd::arithmetic::logarithm::lemma_log_s(2, x);
                vstd::arithmetic::logarithm::lemma_log_s(2, y);
            };
        };
    }
}

pub proof fn log2_is_strictly_ordered_if_rhs_is_pow2(x: int, y: int)
    requires 0 < x < y, is_power_of_two(y)
    ensures log(2, x) < log(2, y)
    decreases x, y
{
    if x == 1 {
        assert(1 < y);
        assert(log(2, y) >= 1) by {
            vstd::arithmetic::logarithm::lemma_log_is_ordered(2, 2, y);
            assert(log(2, 2) == 1) by (compute);
        };
        assert(log(2, 1) == 0) by (compute);
        assert(log(2, x) < log(2, y));
    } else {
        assert(2 < y);
        let log2y = choose|i: nat| y == pow2(i);
        assert(log2y > 1) by {
            assert(pow2(1) == 2) by (compute);
            vstd::arithmetic::power2::lemma_pow2(1);
            vstd::arithmetic::power2::lemma_pow2(log2y);
            vstd::arithmetic::power::lemma_pow_strictly_increases_converse(2, 1, log2y);
        };
        assert(y / 2 == pow2(log2y as nat) / 2 == pow2((log2y - 1) as nat)) by {
            vstd::arithmetic::power2::lemma_pow2_unfold(log2y);
        };
        assert(x / 2 < x || x / 2 == 0);
        assert(x / 2 < y / 2) by {
            if x / 2 == 0 {
                vstd::arithmetic::power2::lemma_pow2_pos(log2y);
            } else {
                assert(y != 0);
                vstd::arithmetic::power2::lemma_pow2_pos((log2y - 1) as nat);
                assert(0 < y / 2);
                assert(y == 2 * pow2((log2y - 1) as nat)) by {
                    assert(pow2(1) == 2) by (compute);
                    vstd::arithmetic::power2::lemma_pow2_adds(1, (log2y - 1) as nat);
                };
                vstd::arithmetic::div_mod::lemma_div_by_multiple_is_strongly_ordered(
                    x,
                    y,
                    pow2((log2y - 1) as nat) as int,
                    2);
            }
        };
        assert(is_power_of_two(y / 2));
        log2_is_strictly_ordered_if_rhs_is_pow2(x / 2, y / 2);
        // log2(x / 2) < log2(y / 2)
        // log2(x) - 1 < log2(y) - 1
        vstd::arithmetic::logarithm::lemma_log_s(2, x);
        vstd::arithmetic::logarithm::lemma_log_s(2, y);
    }
}

pub proof fn lemma_div_by_multiple_silly(x: int, y: int, z: int) by (nonlinear_arith)
    requires x == z * y, 0 < y <= x
    ensures x / y * y == x
{}

pub proof fn lemma_div_before_mult_pow2(p: int, q: int)
    requires 0 <= q <= p
    ensures pow2(p as nat) / pow2(q as nat) * pow2(q as nat) == pow2(p as nat)
    decreases p, q
{
    let p = p as nat;
    let q = q as nat;
    assert(pow2(p) == pow2((p - q) as nat) * pow2(q)) by {
        vstd::arithmetic::power2::lemma_pow2_adds((p - q) as nat, q);
    };
    
    vstd::arithmetic::power2::lemma_pow2_pos(p);
    vstd::arithmetic::power2::lemma_pow2_pos(q);
    vstd::arithmetic::power2::lemma_pow2_pos((p - q) as nat);
    assert(pow2(q) as int <= pow2(p) as int) by {
        vstd::arithmetic::power2::lemma_pow2(p);
        vstd::arithmetic::power2::lemma_pow2(q);
        vstd::arithmetic::power::lemma_pow_increases(2, q, p);
    };
    lemma_div_by_multiple_silly(pow2(p) as int, pow2(q) as int, pow2((p - q) as nat) as int);
}

#[cfg(target_pointer_width = "64")]
pub proof fn lemma_usize_shr_is_div(x: usize, shift: usize)
    requires 0 <= shift < usize::BITS
        ensures (x >> shift) == x as nat / pow2(shift as nat)
{
    vstd::bits::lemma_u64_shr_is_div(x as u64, shift as u64);
}

pub proof fn lemma_pow2_div_sub(x: nat, y: nat)
    requires x <= y
    ensures pow2((y - x) as nat) == pow2(y) / pow2(x)
{
    vstd::arithmetic::power2::lemma_pow2(x);
    vstd::arithmetic::power2::lemma_pow2(y);
    vstd::arithmetic::power2::lemma_pow2((y - x) as nat);
    vstd::arithmetic::power::lemma_pow_subtracts(2, x, y);
}

pub proof fn u64_leading_zeros_ineq(x: u64, y: u64)
    requires x < y
    ensures u64_leading_zeros(y) <= u64_leading_zeros(x)
{}

pub proof fn lemma_u64_add_leading_and_trailing_zeros(x: u64)
    requires x > 0
    ensures u64_leading_zeros(x) + u64_trailing_zeros(x) < u64::BITS
{}

pub proof fn lemma_u64_trailing_zeros_same(x: u64, y: u64)
    requires x % y == 0, 0 < x, 2 <= y, is_power_of_two(y as int)
    ensures u64_trailing_zeros(x) == u64_trailing_zeros(y)
    decreases x, y
{
    lemma_high_mask_u64_values();
    let logy = choose|i: nat| pow2(i) == y;
    assert(pow2(logy) == y);
    assume(logy < u64::BITS);
    vstd::bits::lemma_u64_low_bits_mask_is_mod(x, logy);
    assert(x % pow2(logy) as u64 == x & low_mask_u64(logy));
    let mask: u64 = high_mask_u64(logy);
    assume(x & mask == x);
    assume(y & mask == y);
    lemma_u64_trailing_zeros_mask(x, logy);
    lemma_u64_trailing_zeros_mask(y, logy);
}

pub proof fn lemma_u64_trailing_zeros_mask(x: u64, n: nat)
    ensures
        u64_trailing_zeros(x & high_mask_u64(n)) == n
{
    lemma_high_mask_u64_values();
}

#[cfg(target_pointer_width = "64")]
pub proof fn lemma_usize_trailing_zero_be_log2(x: usize, n: nat, m: nat)
    requires x as nat == n * pow2(m)
    ensures
        usize_trailing_zeros(x) >= m
{
    lemma_u64_trailing_zero_be_log2(x as u64, n, m);
}

// TODO: this may be last lemma for map_floor
pub proof fn lemma_u64_trailing_zero_be_log2(x: u64, n: nat, m: nat)
    requires 0 < n, x as nat == n * pow2(m)
    ensures
        u64_trailing_zeros(x) >= m
    decreases x,m
{
    // Sketch:
    // u64_trailing_zeros(x) == 1 + u64_trailing_zeros(x / 2)
    //                       == 1 + 1 + u64_trailing_zeros(x / 2 / 2)
    //                          ...
    //                       == 1 + ... + 1 + u64_trailing_zeros(x / pow2(j))
    //                          +---------+
    //                              j-times
    //                       == 1 + ... + 1 + u64_trailing_zeros((n * pow2(j)) / pow2(j))
    //                       == j + u64_trailing_zeros(n)
    //                       >= j

    vstd::arithmetic::power2::lemma_pow2_pos(m);
    assert(n > 0 && pow2(m) > 0);
    vstd::arithmetic::mul::lemma_mul_ordering(pow2(m) as int, n as int);
    assert(0 < n * pow2(m) <= u64::MAX);
    assert(pow2(m) <= u64::MAX) by {
        assert(pow2(m) <= n * pow2(m));
    };
    assert(n <= u64::MAX) by {
        assert(n <= n * pow2(m));
    };
    if x == n * pow2(0) && m == 0 {
        assert(m == 0);
        assert(n >= 0);
    } else {
        assert(x / 2 == n * pow2((m - 1) as nat)) by {
            assert(x == n * pow2(m));
            assert((n * pow2(m)) / 2 == n * pow2((m - 1) as nat)) by {
                vstd::arithmetic::power2::lemma_pow2_unfold(m);
                broadcast use vstd::arithmetic::mul::group_mul_properties;
            };
        };
        lemma_u64_trailing_zero_be_log2(x / 2, n, (m - 1) as nat);

        assert(forall|x: u64, y: u64| x & 1 == 0 ==> ((x * y) as u64) & 1 == 0) by (bit_vector);
        {
            let n = n as u64;
            let pow = pow2((m - 1) as nat) as u64;
            assert(x == 2 * n * pow) by {
                vstd::arithmetic::power2::lemma_pow2_unfold(m);
                broadcast use vstd::arithmetic::mul::group_mul_properties;
            };
            assert(x & 1 == 0) by (bit_vector)
                requires x == 2 * n * pow;
        }
        assert(x != 0);
        reveal(u64_trailing_zeros);
        assert(1 + u64_trailing_zeros(x / 2) == u64_trailing_zeros(x));
        assert(u64_trailing_zeros(x / 2) >= m - 1);
    }
}

proof fn lemma_u64_last_bit_zero_iff_mul_of_two(x: u64, e: nat)
    requires x as nat == pow2(e), 0 < e
    ensures x & 1 == 0
{
    vstd::arithmetic::power2::lemma_pow2_pos(e);
    vstd::arithmetic::power2::lemma_pow2_pos((e - 1) as nat);
    assert(x as nat <= u64::MAX);
    assert(x as nat == pow2(e));
    assert(0 < pow2(e) <= u64::MAX) by {
    };
    assert(pow2((e - 1) as nat) < pow2(e)) by {
        vstd::arithmetic::power2::lemma_pow2_strictly_increases((e - 1) as nat, e);
    };
    assert(0 < pow2((e - 1) as nat) <= u64::MAX);
    let pow = pow2((e - 1) as nat) as u64;
    assert(x == 2 * pow) by {
        vstd::arithmetic::power2::lemma_pow2_unfold(e);
    };
    assert(x & 1 == 0) by (bit_vector)
        requires x == 2 * pow;
}

//pub proof fn usize_leading_trailing_zeros_diff(x)
    //requires x !=

} // verus!
