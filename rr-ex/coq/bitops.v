From refinedrust Require Import typing.
From QuickChick Require Import QuickChick.
Require Import FunInd Recdef.

(*Definition type_of_ptr_add `{!typeGS Σ} (T_rt : Type) (T_st : syn_type) :=*)
  (*fn(∀ () : 0 | ( *[T_ty]) : [(T_rt, T_st)] | (l, offset) : loc * Z, (λ ϝ, []); l :@: alias_ptr_t, (offset) :@: int usize_t; λ π,*)
    (*⌜l `has_layout_loc` (use_layout_alg' T_st)⌝ ∗*)
    (*⌜(offset * size_of_st T_st)%Z ∈ isize_t⌝ ∗*)
    (*loc_in_bounds l 0 ((Z.to_nat offset) * size_of_st T_st)*)
  (*) →*)
  (*∃ () : unit, (l, offset) @ offset_ptr_t T_st; λ π, £ (S (num_laters_per_step 1)) ∗ atime 1.*)

(*Definition saturating_add_spec `{!LayoutAlg} (T_st : syn_type) : function := {|*)
  (*f_args := [("lhs", usize_t : layout); ("rhs", usize_t : layout)];*)
  (*[>f_local_vars<]*)
  (*f_code :=*)
    (*<["_bb0" :=*)
      (*return zst_val*)
    (*]>%E $*)
    (*∅;*)
  (*f_init := "_bb0";*)
(*|}.*)

Definition int_bitwidth (it: int_type) := 8*2^it_byte_size_log it.
(* `ws` is the bitwidth of the target
   `x` is the target integer
   `n` is the shift amount
 *)
Definition Zrotate_right ws x n := Z.land (Z.ones ws)
  $ Z.lor (Z.shiftr x n) (Z.shiftl x (ws - n)).
Definition rotate_right_usize x n := Zrotate_right (int_bitwidth usize_t) x n.

Search Z.testbit.
(* `m` is 0-indexed bit position *)
Lemma Zrotate_right_spec: forall ws x n m,
  0 < ws ->
  0 ≤ m < ws ->
  Z.testbit x m -> Z.testbit (Zrotate_right ws x n) ((m - n + ws) `mod` ws).
Proof.
  Check Z.testbit_neg_r.
Admitted.
(*Compute Zrotate_right 8 1 1.*)
Compute Z.shiftl 1 3.
Check Z.to_nat.
(*Function msb_enabled (n: Z) {measure Z.to_nat} : Z :=*)
  (*if decide (n ≤ 0) then 0 else 1+(msb_enabled (Z.shiftr n 1)).*)
(*Proof.*)
  (*intros. rewrite Z.shiftr_div_pow2; lia.*)
(*Defined.*)

Lemma Zinduction: forall  (P: Z -> Prop),
  P 0 ->
  (forall i, 0 < i -> P (i-1) -> P i) ->
  forall n, 0 <= n -> P n.
Proof.
intros.
rewrite <- (Z2Nat.id n) in * by lia.
set (j := Z.to_nat n) in *. clearbody j.
induction j.
- simpl. apply H.
- apply (H0 (Z.of_nat (S j))).
  + rewrite inj_S. unfold Z.succ. lia.
  + rewrite inj_S. unfold Z.succ. rewrite Z.add_simpl_r.
    apply IHj. lia.
Qed.

Lemma ZinductionSucc: forall  (P: Z -> Prop),
  P 0 ->
  (forall i, 0 < i -> P i -> P (i + 1)) ->
  forall n, 0 <= n -> P n.
Proof.
intros.
rewrite <- (Z2Nat.id n) in * by lia.
set (j := Z.to_nat n) in *. clearbody j.
induction j.
- simpl. apply H.
- apply (H0 (S $ Z.of_nat j)).
  + rewrite inj_S. unfold Z.succ. lia.
  + rewrite inj_S. unfold Z.succ. rewrite Z.add_simpl_r.
    apply IHj. lia.
Qed.


Compute Z.testbit 4 3.
 Print positive.
 Check (xI xH).
Print Pos.size.

(* Searching for enabled bit bitween [msb_idx, 0] bits.
 * Returns 1-indexed position from LSB for the highest bit which is 1.
 * Returns 0 for input 0b0.
 * i.e. clz b = bitwidth - msb_enabled bitwidth b
 *
 * Example 1:
     n = 0b00010000
     msb_enabled 8 n = 5
*)
Fixpoint msb_enabled (msb_idx: nat) (n: Z) : Z :=
  match msb_idx with
  | O => if Z.testbit n 0 then 1 else 0
  | S x => if Z.testbit n msb_idx
           then msb_idx + 1 (* convert to 1-indexed result *)
           else msb_enabled x n
  end.


Lemma msb_enabled_0: forall idx, msb_enabled idx 0 = 0.
Proof.
  intros.
  induction idx.
  - reflexivity.
  - unfold msb_enabled.
    rewrite Z.bits_0.
    fold msb_enabled.
    assumption.
Qed.

Definition count_leading_zeros (it: int_type) (i: Z) :=
  bits_per_int it - msb_enabled (Z.to_nat $ bits_per_int it - 1) i.

Compute msb_enabled 63 4.

Definition msb_enabled_64bitP (n: Z) :=
  orb (negb (bool_decide (0 < n)%Z)) $
  bool_decide (0 ≤  msb_enabled 63 n < 64).

QuickChick msb_enabled_64bitP.

Definition clz_itP (n: Z) : bool := 
  orb (negb (bool_decide (0 < n < 2^64)%Z)) $
  bool_decide (Z.log2 n = msb_enabled 63 n - 1).

QuickChick clz_itP.

Search "Odd".
Lemma msb_enabled_log2_nbits_odd: forall m ws,
  0 < ws ->
  0 < m < 2^ws ->
  Z.log2 m = msb_enabled (Z.to_nat (ws - 1)) m - 1.
Proof.
  intros m ws Hws.
  pattern m ; apply Zinduction ; intros.
  - inversion H. inversion H0.
  - destruct (Z.Even_or_Odd i).
    + admit.
    Search (Z.log2 (_ + _)).
    Search Nat.Odd_Even_ind.
    + Search Z.Odd. unfold Z.Odd in H2. Check Z.log2_succ_double.

Abort.

Lemma count_leading_zeros_spec: forall it m,
  it_signed it = false -> m∈  it
  (* to avoid log2 0 = -1 *)
   -> 0 < m
   -> Z.log2 m = (bits_per_int it) - count_leading_zeros it m - 1.
Proof.
  intros it m Hsigned Hit_range.
  unfold count_leading_zeros.
  pattern m ; apply Zinduction ; intros ; ring_simplify.
  - inversion H.
  - 
Abort.
