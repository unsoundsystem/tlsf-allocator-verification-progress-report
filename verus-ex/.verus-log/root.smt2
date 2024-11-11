(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const CHAR Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'root module'

;; Fuel
(declare-const fuel%vstd!map.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!map.axiom_map_index_decreases_finite. FuelId)
(declare-const fuel%vstd!map.axiom_map_index_decreases_infinite. FuelId)
(declare-const fuel%vstd!map.axiom_map_ext_equal. FuelId)
(declare-const fuel%vstd!map.axiom_map_ext_equal_deep. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%2.arrow_0. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%7.is_init. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%7.is_uninit. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%7.value. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!set.axiom_set_ext_equal. FuelId)
(declare-const fuel%vstd!set.axiom_set_ext_equal_deep. FuelId)
(declare-const fuel%vstd!simple_pptr.impl&%1.pptr. FuelId)
(declare-const fuel%vstd!simple_pptr.impl&%1.is_init. FuelId)
(declare-const fuel%vstd!simple_pptr.impl&%1.is_uninit. FuelId)
(declare-const fuel%vstd!simple_pptr.impl&%1.value. FuelId)
(declare-const fuel%singly_linked_list_trivial!impl&%3.view. FuelId)
(declare-const fuel%singly_linked_list_trivial!impl&%3.next_of. FuelId)
(declare-const fuel%singly_linked_list_trivial!impl&%3.wf_node. FuelId)
(declare-const fuel%singly_linked_list_trivial!impl&%3.wf. FuelId)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_axioms. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!map.impl&%0.spec_index. fuel%vstd!map.axiom_map_index_decreases_finite.
  fuel%vstd!map.axiom_map_index_decreases_infinite. fuel%vstd!map.axiom_map_ext_equal.
  fuel%vstd!map.axiom_map_ext_equal_deep. fuel%vstd!raw_ptr.impl&%2.arrow_0. fuel%vstd!raw_ptr.impl&%7.is_init.
  fuel%vstd!raw_ptr.impl&%7.is_uninit. fuel%vstd!raw_ptr.impl&%7.value. fuel%vstd!seq.impl&%0.spec_index.
  fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!set.axiom_set_ext_equal.
  fuel%vstd!set.axiom_set_ext_equal_deep. fuel%vstd!simple_pptr.impl&%1.pptr. fuel%vstd!simple_pptr.impl&%1.is_init.
  fuel%vstd!simple_pptr.impl&%1.is_uninit. fuel%vstd!simple_pptr.impl&%1.value. fuel%singly_linked_list_trivial!impl&%3.view.
  fuel%singly_linked_list_trivial!impl&%3.next_of. fuel%singly_linked_list_trivial!impl&%3.wf_node.
  fuel%singly_linked_list_trivial!impl&%3.wf. fuel%vstd!array.group_array_axioms. fuel%vstd!map.group_map_axioms.
  fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_seq_lib_default. fuel%vstd!set.group_set_axioms.
  fuel%vstd!set_lib.group_set_lib_axioms. fuel%vstd!slice.group_slice_axioms. fuel%vstd!string.group_string_axioms.
  fuel%vstd!std_specs.bits.group_bits_axioms. fuel%vstd!std_specs.control_flow.group_control_flow_axioms.
  fuel%vstd!std_specs.range.group_range_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!map.group_map_axioms.)
  (and
   (fuel_bool_default fuel%vstd!map.axiom_map_index_decreases_finite.)
   (fuel_bool_default fuel%vstd!map.axiom_map_index_decreases_infinite.)
   (fuel_bool_default fuel%vstd!map.axiom_map_ext_equal.)
   (fuel_bool_default fuel%vstd!map.axiom_map_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!set.group_set_axioms.)
  (and
   (fuel_bool_default fuel%vstd!set.axiom_set_ext_equal.)
   (fuel_bool_default fuel%vstd!set.axiom_set_ext_equal_deep.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
)))

;; Datatypes
(declare-sort vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
 0
)
(declare-sort vstd!seq.Seq<usize.>. 0)
(declare-sort vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
 0
)
(declare-sort vstd!set.Set<nat.>. 0)
(declare-sort vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. 0)
(declare-datatypes ((core!option.Option. 0) (core!marker.PhantomData. 0) (vstd!raw_ptr.MemContents.
   0
  ) (vstd!simple_pptr.PPtr. 0) (singly_linked_list_trivial!Node. 0) (singly_linked_list_trivial!LList.
   0
  ) (tuple%0. 0) (tuple%2. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((core!marker.PhantomData./PhantomData)) ((vstd!raw_ptr.MemContents./Uninit) (vstd!raw_ptr.MemContents./Init
    (vstd!raw_ptr.MemContents./Init/?0 Poly)
   )
  ) ((vstd!simple_pptr.PPtr./PPtr (vstd!simple_pptr.PPtr./PPtr/?0 Int) (vstd!simple_pptr.PPtr./PPtr/?1
     core!marker.PhantomData.
   ))
  ) ((singly_linked_list_trivial!Node./Node (singly_linked_list_trivial!Node./Node/?next
     core!option.Option.
    ) (singly_linked_list_trivial!Node./Node/?x Int)
   )
  ) ((singly_linked_list_trivial!LList./LList (singly_linked_list_trivial!LList./LList/?first
     core!option.Option.
    ) (singly_linked_list_trivial!LList./LList/?perms vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.)
    (singly_linked_list_trivial!LList./LList/?ptrs vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.)
   )
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
)))))
(declare-fun core!option.Option./Some/0 (core!option.Option.) Poly)
(declare-fun vstd!raw_ptr.MemContents./Init/0 (vstd!raw_ptr.MemContents.) Poly)
(declare-fun vstd!simple_pptr.PPtr./PPtr/0 (vstd!simple_pptr.PPtr.) Int)
(declare-fun vstd!simple_pptr.PPtr./PPtr/1 (vstd!simple_pptr.PPtr.) core!marker.PhantomData.)
(declare-fun singly_linked_list_trivial!Node./Node/next (singly_linked_list_trivial!Node.)
 core!option.Option.
)
(declare-fun singly_linked_list_trivial!Node./Node/x (singly_linked_list_trivial!Node.)
 Int
)
(declare-fun singly_linked_list_trivial!LList./LList/first (singly_linked_list_trivial!LList.)
 core!option.Option.
)
(declare-fun singly_linked_list_trivial!LList./LList/perms (singly_linked_list_trivial!LList.)
 vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
)
(declare-fun singly_linked_list_trivial!LList./LList/ptrs (singly_linked_list_trivial!LList.)
 vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%core!marker.PhantomData. (Dcr Type) Type)
(declare-fun TYPE%vstd!map.Map. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%vstd!raw_ptr.MemContents. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun TYPE%vstd!set.Set. (Dcr Type) Type)
(declare-fun TYPE%vstd!simple_pptr.PPtr. (Dcr Type) Type)
(declare-fun TYPE%vstd!simple_pptr.PointsTo. (Dcr Type) Type)
(declare-const TYPE%singly_linked_list_trivial!Node. Type)
(declare-const TYPE%singly_linked_list_trivial!LList. Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
 (vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.)
 Poly
)
(declare-fun %Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
 (Poly) vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
)
(declare-fun Poly%vstd!seq.Seq<usize.>. (vstd!seq.Seq<usize.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<usize.>. (Poly) vstd!seq.Seq<usize.>.)
(declare-fun Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
 (vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.) Poly
)
(declare-fun %Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
 (Poly) vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
)
(declare-fun Poly%vstd!set.Set<nat.>. (vstd!set.Set<nat.>.) Poly)
(declare-fun %Poly%vstd!set.Set<nat.>. (Poly) vstd!set.Set<nat.>.)
(declare-fun Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. (vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 Poly
)
(declare-fun %Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. (Poly)
 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%core!marker.PhantomData. (core!marker.PhantomData.) Poly)
(declare-fun %Poly%core!marker.PhantomData. (Poly) core!marker.PhantomData.)
(declare-fun Poly%vstd!raw_ptr.MemContents. (vstd!raw_ptr.MemContents.) Poly)
(declare-fun %Poly%vstd!raw_ptr.MemContents. (Poly) vstd!raw_ptr.MemContents.)
(declare-fun Poly%vstd!simple_pptr.PPtr. (vstd!simple_pptr.PPtr.) Poly)
(declare-fun %Poly%vstd!simple_pptr.PPtr. (Poly) vstd!simple_pptr.PPtr.)
(declare-fun Poly%singly_linked_list_trivial!Node. (singly_linked_list_trivial!Node.)
 Poly
)
(declare-fun %Poly%singly_linked_list_trivial!Node. (Poly) singly_linked_list_trivial!Node.)
(declare-fun Poly%singly_linked_list_trivial!LList. (singly_linked_list_trivial!LList.)
 Poly
)
(declare-fun %Poly%singly_linked_list_trivial!LList. (Poly) singly_linked_list_trivial!LList.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.))
  (!
   (= x (%Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
     (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
      x
   )))
   :pattern ((Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
     x
   ))
   :qid internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!map.Map. $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)))
    (= x (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
      (%Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!map.Map. $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $
       TYPE%singly_linked_list_trivial!Node.
   ))))
   :qid internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.))
  (!
   (has_type (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
     x
    ) (TYPE%vstd!map.Map. $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.))
   )
   :pattern ((has_type (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
      x
     ) (TYPE%vstd!map.Map. $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.))
   ))
   :qid internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__map__Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<usize.>.)) (!
   (= x (%Poly%vstd!seq.Seq<usize.>. (Poly%vstd!seq.Seq<usize.>. x)))
   :pattern ((Poly%vstd!seq.Seq<usize.>. x))
   :qid internal_vstd__seq__Seq<usize.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<usize.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT SZ)))
    (= x (Poly%vstd!seq.Seq<usize.>. (%Poly%vstd!seq.Seq<usize.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT SZ))))
   :qid internal_vstd__seq__Seq<usize.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<usize.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<usize.>.)) (!
   (has_type (Poly%vstd!seq.Seq<usize.>. x) (TYPE%vstd!seq.Seq. $ (UINT SZ)))
   :pattern ((has_type (Poly%vstd!seq.Seq<usize.>. x) (TYPE%vstd!seq.Seq. $ (UINT SZ))))
   :qid internal_vstd__seq__Seq<usize.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<usize.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.))
  (!
   (= x (%Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
     (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. x)
   ))
   :pattern ((Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
     x
   ))
   :qid internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.)))
    (= x (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
      (%Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. x)
   )))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))))
   :qid internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.))
  (!
   (has_type (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
     x
    ) (TYPE%vstd!seq.Seq. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))
   )
   :pattern ((has_type (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
      x
     ) (TYPE%vstd!seq.Seq. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))
   ))
   :qid internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!set.Set<nat.>.)) (!
   (= x (%Poly%vstd!set.Set<nat.>. (Poly%vstd!set.Set<nat.>. x)))
   :pattern ((Poly%vstd!set.Set<nat.>. x))
   :qid internal_vstd__set__Set<nat.>_box_axiom_definition
   :skolemid skolem_internal_vstd__set__Set<nat.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!set.Set. $ NAT))
    (= x (Poly%vstd!set.Set<nat.>. (%Poly%vstd!set.Set<nat.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!set.Set. $ NAT)))
   :qid internal_vstd__set__Set<nat.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__set__Set<nat.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!set.Set<nat.>.)) (!
   (has_type (Poly%vstd!set.Set<nat.>. x) (TYPE%vstd!set.Set. $ NAT))
   :pattern ((has_type (Poly%vstd!set.Set<nat.>. x) (TYPE%vstd!set.Set. $ NAT)))
   :qid internal_vstd__set__Set<nat.>_has_type_always_definition
   :skolemid skolem_internal_vstd__set__Set<nat.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)) (!
   (= x (%Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
      x
   )))
   :pattern ((Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. x))
   :qid internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_box_axiom_definition
   :skolemid skolem_internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.))
    (= x (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. (%Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)))
   :qid internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)) (!
   (has_type (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. x) (TYPE%vstd!simple_pptr.PointsTo.
     $ TYPE%singly_linked_list_trivial!Node.
   ))
   :pattern ((has_type (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
      x
     ) (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)
   ))
   :qid internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_has_type_always_definition
   :skolemid skolem_internal_vstd__simple_pptr__PointsTo<singly_linked_list_trivial!Node.>_has_type_always_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (= x (%Poly%core!option.Option. (Poly%core!option.Option. x)))
   :pattern ((Poly%core!option.Option. x))
   :qid internal_core__option__Option_box_axiom_definition
   :skolemid skolem_internal_core__option__Option_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (= x (Poly%core!option.Option. (%Poly%core!option.Option. x)))
   )
   :pattern ((has_type x (TYPE%core!option.Option. V&. V&)))
   :qid internal_core__option__Option_unbox_axiom_definition
   :skolemid skolem_internal_core__option__Option_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
     V&. V&
   ))
   :pattern ((has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./None_constructor_definition
   :skolemid skolem_internal_core!option.Option./None_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Poly)) (!
   (=>
    (has_type _0! V&)
    (has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :pattern ((has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some_constructor_definition
   :skolemid skolem_internal_core!option.Option./Some_constructor_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (= (core!option.Option./Some/0 x) (core!option.Option./Some/?0 x))
   :pattern ((core!option.Option./Some/0 x))
   :qid internal_core!option.Option./Some/0_accessor_definition
   :skolemid skolem_internal_core!option.Option./Some/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (has_type (core!option.Option./Some/0 (%Poly%core!option.Option. x)) V&)
   )
   :pattern ((core!option.Option./Some/0 (%Poly%core!option.Option. x)) (has_type x (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some/0_invariant_definition
   :skolemid skolem_internal_core!option.Option./Some/0_invariant_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (height_lt (height (core!option.Option./Some/0 x)) (height (Poly%core!option.Option.
       x
   ))))
   :pattern ((height (core!option.Option./Some/0 x)))
   :qid prelude_datatype_height_core!option.Option./Some/0
   :skolemid skolem_prelude_datatype_height_core!option.Option./Some/0
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./None (%Poly%core!option.Option. x))
     (is-core!option.Option./None (%Poly%core!option.Option. y))
    )
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./None_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./None_ext_equal_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./Some (%Poly%core!option.Option. x))
     (is-core!option.Option./Some (%Poly%core!option.Option. y))
     (ext_eq deep V& (core!option.Option./Some/0 (%Poly%core!option.Option. x)) (core!option.Option./Some/0
       (%Poly%core!option.Option. y)
    )))
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./Some_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./Some_ext_equal_definition
)))
(assert
 (forall ((x core!marker.PhantomData.)) (!
   (= x (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. x)))
   :pattern ((Poly%core!marker.PhantomData. x))
   :qid internal_core__marker__PhantomData_box_axiom_definition
   :skolemid skolem_internal_core__marker__PhantomData_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!marker.PhantomData. V&. V&))
    (= x (Poly%core!marker.PhantomData. (%Poly%core!marker.PhantomData. x)))
   )
   :pattern ((has_type x (TYPE%core!marker.PhantomData. V&. V&)))
   :qid internal_core__marker__PhantomData_unbox_axiom_definition
   :skolemid skolem_internal_core__marker__PhantomData_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!marker.PhantomData.)) (!
   (has_type (Poly%core!marker.PhantomData. x) (TYPE%core!marker.PhantomData. V&. V&))
   :pattern ((has_type (Poly%core!marker.PhantomData. x) (TYPE%core!marker.PhantomData.
      V&. V&
   )))
   :qid internal_core__marker__PhantomData_has_type_always_definition
   :skolemid skolem_internal_core__marker__PhantomData_has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.MemContents.)) (!
   (= x (%Poly%vstd!raw_ptr.MemContents. (Poly%vstd!raw_ptr.MemContents. x)))
   :pattern ((Poly%vstd!raw_ptr.MemContents. x))
   :qid internal_vstd__raw_ptr__MemContents_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__MemContents_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.MemContents. T&. T&))
    (= x (Poly%vstd!raw_ptr.MemContents. (%Poly%vstd!raw_ptr.MemContents. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.MemContents. T&. T&)))
   :qid internal_vstd__raw_ptr__MemContents_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__MemContents_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (has_type (Poly%vstd!raw_ptr.MemContents. vstd!raw_ptr.MemContents./Uninit) (TYPE%vstd!raw_ptr.MemContents.
     T&. T&
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.MemContents. vstd!raw_ptr.MemContents./Uninit)
     (TYPE%vstd!raw_ptr.MemContents. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.MemContents./Uninit_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.MemContents./Uninit_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T&)
    (has_type (Poly%vstd!raw_ptr.MemContents. (vstd!raw_ptr.MemContents./Init _0!)) (TYPE%vstd!raw_ptr.MemContents.
      T&. T&
   )))
   :pattern ((has_type (Poly%vstd!raw_ptr.MemContents. (vstd!raw_ptr.MemContents./Init _0!))
     (TYPE%vstd!raw_ptr.MemContents. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.MemContents./Init_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.MemContents./Init_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.MemContents.)) (!
   (= (vstd!raw_ptr.MemContents./Init/0 x) (vstd!raw_ptr.MemContents./Init/?0 x))
   :pattern ((vstd!raw_ptr.MemContents./Init/0 x))
   :qid internal_vstd!raw_ptr.MemContents./Init/0_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.MemContents./Init/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.MemContents. T&. T&))
    (has_type (vstd!raw_ptr.MemContents./Init/0 (%Poly%vstd!raw_ptr.MemContents. x)) T&)
   )
   :pattern ((vstd!raw_ptr.MemContents./Init/0 (%Poly%vstd!raw_ptr.MemContents. x)) (
     has_type x (TYPE%vstd!raw_ptr.MemContents. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.MemContents./Init/0_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.MemContents./Init/0_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.MemContents.)) (!
   (=>
    (is-vstd!raw_ptr.MemContents./Init x)
    (height_lt (height (vstd!raw_ptr.MemContents./Init/0 x)) (height (Poly%vstd!raw_ptr.MemContents.
       x
   ))))
   :pattern ((height (vstd!raw_ptr.MemContents./Init/0 x)))
   :qid prelude_datatype_height_vstd!raw_ptr.MemContents./Init/0
   :skolemid skolem_prelude_datatype_height_vstd!raw_ptr.MemContents./Init/0
)))
(assert
 (forall ((x vstd!simple_pptr.PPtr.)) (!
   (= x (%Poly%vstd!simple_pptr.PPtr. (Poly%vstd!simple_pptr.PPtr. x)))
   :pattern ((Poly%vstd!simple_pptr.PPtr. x))
   :qid internal_vstd__simple_pptr__PPtr_box_axiom_definition
   :skolemid skolem_internal_vstd__simple_pptr__PPtr_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!simple_pptr.PPtr. V&. V&))
    (= x (Poly%vstd!simple_pptr.PPtr. (%Poly%vstd!simple_pptr.PPtr. x)))
   )
   :pattern ((has_type x (TYPE%vstd!simple_pptr.PPtr. V&. V&)))
   :qid internal_vstd__simple_pptr__PPtr_unbox_axiom_definition
   :skolemid skolem_internal_vstd__simple_pptr__PPtr_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Int) (_1! core!marker.PhantomData.)) (!
   (=>
    (uInv SZ _0!)
    (has_type (Poly%vstd!simple_pptr.PPtr. (vstd!simple_pptr.PPtr./PPtr _0! _1!)) (TYPE%vstd!simple_pptr.PPtr.
      V&. V&
   )))
   :pattern ((has_type (Poly%vstd!simple_pptr.PPtr. (vstd!simple_pptr.PPtr./PPtr _0! _1!))
     (TYPE%vstd!simple_pptr.PPtr. V&. V&)
   ))
   :qid internal_vstd!simple_pptr.PPtr./PPtr_constructor_definition
   :skolemid skolem_internal_vstd!simple_pptr.PPtr./PPtr_constructor_definition
)))
(assert
 (forall ((x vstd!simple_pptr.PPtr.)) (!
   (= (vstd!simple_pptr.PPtr./PPtr/0 x) (vstd!simple_pptr.PPtr./PPtr/?0 x))
   :pattern ((vstd!simple_pptr.PPtr./PPtr/0 x))
   :qid internal_vstd!simple_pptr.PPtr./PPtr/0_accessor_definition
   :skolemid skolem_internal_vstd!simple_pptr.PPtr./PPtr/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!simple_pptr.PPtr. V&. V&))
    (uInv SZ (vstd!simple_pptr.PPtr./PPtr/0 (%Poly%vstd!simple_pptr.PPtr. x)))
   )
   :pattern ((vstd!simple_pptr.PPtr./PPtr/0 (%Poly%vstd!simple_pptr.PPtr. x)) (has_type
     x (TYPE%vstd!simple_pptr.PPtr. V&. V&)
   ))
   :qid internal_vstd!simple_pptr.PPtr./PPtr/0_invariant_definition
   :skolemid skolem_internal_vstd!simple_pptr.PPtr./PPtr/0_invariant_definition
)))
(assert
 (forall ((x vstd!simple_pptr.PPtr.)) (!
   (= (vstd!simple_pptr.PPtr./PPtr/1 x) (vstd!simple_pptr.PPtr./PPtr/?1 x))
   :pattern ((vstd!simple_pptr.PPtr./PPtr/1 x))
   :qid internal_vstd!simple_pptr.PPtr./PPtr/1_accessor_definition
   :skolemid skolem_internal_vstd!simple_pptr.PPtr./PPtr/1_accessor_definition
)))
(assert
 (forall ((x vstd!simple_pptr.PPtr.)) (!
   (=>
    (is-vstd!simple_pptr.PPtr./PPtr x)
    (height_lt (height (Poly%core!marker.PhantomData. (vstd!simple_pptr.PPtr./PPtr/1 x)))
     (height (Poly%vstd!simple_pptr.PPtr. x))
   ))
   :pattern ((height (Poly%core!marker.PhantomData. (vstd!simple_pptr.PPtr./PPtr/1 x))))
   :qid prelude_datatype_height_vstd!simple_pptr.PPtr./PPtr/1
   :skolemid skolem_prelude_datatype_height_vstd!simple_pptr.PPtr./PPtr/1
)))
(assert
 (forall ((x singly_linked_list_trivial!Node.)) (!
   (= x (%Poly%singly_linked_list_trivial!Node. (Poly%singly_linked_list_trivial!Node.
      x
   )))
   :pattern ((Poly%singly_linked_list_trivial!Node. x))
   :qid internal_singly_linked_list_trivial__Node_box_axiom_definition
   :skolemid skolem_internal_singly_linked_list_trivial__Node_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%singly_linked_list_trivial!Node.)
    (= x (Poly%singly_linked_list_trivial!Node. (%Poly%singly_linked_list_trivial!Node.
       x
   ))))
   :pattern ((has_type x TYPE%singly_linked_list_trivial!Node.))
   :qid internal_singly_linked_list_trivial__Node_unbox_axiom_definition
   :skolemid skolem_internal_singly_linked_list_trivial__Node_unbox_axiom_definition
)))
(assert
 (forall ((_next! core!option.Option.) (_x! Int)) (!
   (=>
    (and
     (has_type (Poly%core!option.Option. _next!) (TYPE%core!option.Option. $ (TYPE%vstd!simple_pptr.PPtr.
        $ TYPE%singly_linked_list_trivial!Node.
     )))
     (uInv SZ _x!)
    )
    (has_type (Poly%singly_linked_list_trivial!Node. (singly_linked_list_trivial!Node./Node
       _next! _x!
      )
     ) TYPE%singly_linked_list_trivial!Node.
   ))
   :pattern ((has_type (Poly%singly_linked_list_trivial!Node. (singly_linked_list_trivial!Node./Node
       _next! _x!
      )
     ) TYPE%singly_linked_list_trivial!Node.
   ))
   :qid internal_singly_linked_list_trivial!Node./Node_constructor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!Node./Node_constructor_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!Node.)) (!
   (= (singly_linked_list_trivial!Node./Node/next x) (singly_linked_list_trivial!Node./Node/?next
     x
   ))
   :pattern ((singly_linked_list_trivial!Node./Node/next x))
   :qid internal_singly_linked_list_trivial!Node./Node/next_accessor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!Node./Node/next_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%singly_linked_list_trivial!Node.)
    (has_type (Poly%core!option.Option. (singly_linked_list_trivial!Node./Node/next (%Poly%singly_linked_list_trivial!Node.
        x
      ))
     ) (TYPE%core!option.Option. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))
   ))
   :pattern ((singly_linked_list_trivial!Node./Node/next (%Poly%singly_linked_list_trivial!Node.
      x
     )
    ) (has_type x TYPE%singly_linked_list_trivial!Node.)
   )
   :qid internal_singly_linked_list_trivial!Node./Node/next_invariant_definition
   :skolemid skolem_internal_singly_linked_list_trivial!Node./Node/next_invariant_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!Node.)) (!
   (= (singly_linked_list_trivial!Node./Node/x x) (singly_linked_list_trivial!Node./Node/?x
     x
   ))
   :pattern ((singly_linked_list_trivial!Node./Node/x x))
   :qid internal_singly_linked_list_trivial!Node./Node/x_accessor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!Node./Node/x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%singly_linked_list_trivial!Node.)
    (uInv SZ (singly_linked_list_trivial!Node./Node/x (%Poly%singly_linked_list_trivial!Node.
       x
   ))))
   :pattern ((singly_linked_list_trivial!Node./Node/x (%Poly%singly_linked_list_trivial!Node.
      x
     )
    ) (has_type x TYPE%singly_linked_list_trivial!Node.)
   )
   :qid internal_singly_linked_list_trivial!Node./Node/x_invariant_definition
   :skolemid skolem_internal_singly_linked_list_trivial!Node./Node/x_invariant_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!Node.)) (!
   (=>
    (is-singly_linked_list_trivial!Node./Node x)
    (height_lt (height (Poly%core!option.Option. (singly_linked_list_trivial!Node./Node/next
        x
      ))
     ) (height (Poly%singly_linked_list_trivial!Node. x))
   ))
   :pattern ((height (Poly%core!option.Option. (singly_linked_list_trivial!Node./Node/next
       x
   ))))
   :qid prelude_datatype_height_singly_linked_list_trivial!Node./Node/next
   :skolemid skolem_prelude_datatype_height_singly_linked_list_trivial!Node./Node/next
)))
(assert
 (forall ((x singly_linked_list_trivial!LList.)) (!
   (= x (%Poly%singly_linked_list_trivial!LList. (Poly%singly_linked_list_trivial!LList.
      x
   )))
   :pattern ((Poly%singly_linked_list_trivial!LList. x))
   :qid internal_singly_linked_list_trivial__LList_box_axiom_definition
   :skolemid skolem_internal_singly_linked_list_trivial__LList_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%singly_linked_list_trivial!LList.)
    (= x (Poly%singly_linked_list_trivial!LList. (%Poly%singly_linked_list_trivial!LList.
       x
   ))))
   :pattern ((has_type x TYPE%singly_linked_list_trivial!LList.))
   :qid internal_singly_linked_list_trivial__LList_unbox_axiom_definition
   :skolemid skolem_internal_singly_linked_list_trivial__LList_unbox_axiom_definition
)))
(assert
 (forall ((_first! core!option.Option.) (_perms! vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.)
   (_ptrs! vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.)
  ) (!
   (=>
    (has_type (Poly%core!option.Option. _first!) (TYPE%core!option.Option. $ (TYPE%vstd!simple_pptr.PPtr.
       $ TYPE%singly_linked_list_trivial!Node.
    )))
    (has_type (Poly%singly_linked_list_trivial!LList. (singly_linked_list_trivial!LList./LList
       _first! _perms! _ptrs!
      )
     ) TYPE%singly_linked_list_trivial!LList.
   ))
   :pattern ((has_type (Poly%singly_linked_list_trivial!LList. (singly_linked_list_trivial!LList./LList
       _first! _perms! _ptrs!
      )
     ) TYPE%singly_linked_list_trivial!LList.
   ))
   :qid internal_singly_linked_list_trivial!LList./LList_constructor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!LList./LList_constructor_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!LList.)) (!
   (= (singly_linked_list_trivial!LList./LList/first x) (singly_linked_list_trivial!LList./LList/?first
     x
   ))
   :pattern ((singly_linked_list_trivial!LList./LList/first x))
   :qid internal_singly_linked_list_trivial!LList./LList/first_accessor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!LList./LList/first_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%singly_linked_list_trivial!LList.)
    (has_type (Poly%core!option.Option. (singly_linked_list_trivial!LList./LList/first (
        %Poly%singly_linked_list_trivial!LList. x
      ))
     ) (TYPE%core!option.Option. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))
   ))
   :pattern ((singly_linked_list_trivial!LList./LList/first (%Poly%singly_linked_list_trivial!LList.
      x
     )
    ) (has_type x TYPE%singly_linked_list_trivial!LList.)
   )
   :qid internal_singly_linked_list_trivial!LList./LList/first_invariant_definition
   :skolemid skolem_internal_singly_linked_list_trivial!LList./LList/first_invariant_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!LList.)) (!
   (= (singly_linked_list_trivial!LList./LList/perms x) (singly_linked_list_trivial!LList./LList/?perms
     x
   ))
   :pattern ((singly_linked_list_trivial!LList./LList/perms x))
   :qid internal_singly_linked_list_trivial!LList./LList/perms_accessor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!LList./LList/perms_accessor_definition
)))
(assert
 (forall ((x singly_linked_list_trivial!LList.)) (!
   (= (singly_linked_list_trivial!LList./LList/ptrs x) (singly_linked_list_trivial!LList./LList/?ptrs
     x
   ))
   :pattern ((singly_linked_list_trivial!LList./LList/ptrs x))
   :qid internal_singly_linked_list_trivial!LList./LList/ptrs_accessor_definition
   :skolemid skolem_internal_singly_linked_list_trivial!LList./LList/ptrs_accessor_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))

;; Traits
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!clone.Clone. Self%&. Self%&))
   :qid internal_core__clone__Clone_trait_type_bounds_definition
   :skolemid skolem_internal_core__clone__Clone_trait_type_bounds_definition
)))

;; Function-Decl vstd::map::impl&%0::dom
(declare-fun vstd!map.impl&%0.dom.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::set::impl&%0::contains
(declare-fun vstd!set.impl&%0.contains.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::map::impl&%0::index
(declare-fun vstd!map.impl&%0.index.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::set::impl&%0::finite
(declare-fun vstd!set.impl&%0.finite.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::map::impl&%0::spec_index
(declare-fun vstd!map.impl&%0.spec_index.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::simple_pptr::impl&%1::addr
(declare-fun vstd!simple_pptr.impl&%1.addr.? (Dcr Type Poly) Int)

;; Function-Decl vstd::simple_pptr::impl&%1::mem_contents
(declare-fun vstd!simple_pptr.impl&%1.mem_contents.? (Dcr Type Poly) vstd!raw_ptr.MemContents.)

;; Function-Decl vstd::simple_pptr::impl&%1::pptr
(declare-fun vstd!simple_pptr.impl&%1.pptr.? (Dcr Type Poly) vstd!simple_pptr.PPtr.)

;; Function-Decl vstd::raw_ptr::impl&%7::is_uninit
(declare-fun vstd!raw_ptr.impl&%7.is_uninit.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::simple_pptr::impl&%1::is_uninit
(declare-fun vstd!simple_pptr.impl&%1.is_uninit.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::raw_ptr::impl&%2::arrow_0
(declare-fun vstd!raw_ptr.impl&%2.arrow_0.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::impl&%7::is_init
(declare-fun vstd!raw_ptr.impl&%7.is_init.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::raw_ptr::impl&%7::value
(declare-fun vstd!raw_ptr.impl&%7.value.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::simple_pptr::impl&%1::is_init
(declare-fun vstd!simple_pptr.impl&%1.is_init.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::simple_pptr::impl&%1::value
(declare-fun vstd!simple_pptr.impl&%1.value.? (Dcr Type Poly) Poly)

;; Function-Decl singly_linked_list_trivial::LList::view
(declare-fun singly_linked_list_trivial!impl&%3.view.? (Poly) vstd!seq.Seq<usize.>.)

;; Function-Decl singly_linked_list_trivial::LList::next_of
(declare-fun singly_linked_list_trivial!impl&%3.next_of.? (Poly Poly) core!option.Option.)

;; Function-Decl singly_linked_list_trivial::LList::wf_node
(declare-fun singly_linked_list_trivial!impl&%3.wf_node.? (Poly Poly) Bool)

;; Function-Decl singly_linked_list_trivial::LList::wf
(declare-fun singly_linked_list_trivial!impl&%3.wf.? (Poly) Bool)

;; Function-Specs core::clone::Clone::clone
(declare-fun ens%core!clone.Clone.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (%return! Poly)) (!
   (= (ens%core!clone.Clone.clone. Self%&. Self%& self! %return!) (has_type %return! Self%&))
   :pattern ((ens%core!clone.Clone.clone. Self%&. Self%& self! %return!))
   :qid internal_ens__core!clone.Clone.clone._definition
   :skolemid skolem_internal_ens__core!clone.Clone.clone._definition
)))

;; Function-Specs core::clone::impls::impl&%5::clone
(declare-fun ens%core!clone.impls.impl&%5.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%5.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT SZ) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%5.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__5.clone._definition
)))

;; Function-Specs core::clone::impls::impl&%21::clone
(declare-fun ens%core!clone.impls.impl&%21.clone. (Poly Poly) Bool)
(assert
 (forall ((b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%21.clone. b! res!) (and
     (ens%core!clone.Clone.clone. $ BOOL b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%21.clone. b! res!))
   :qid internal_ens__core!clone.impls.impl&__21.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__21.clone._definition
)))

;; Function-Specs core::clone::impls::impl&%3::clone
(declare-fun ens%core!clone.impls.impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (REF T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__core!clone.impls.impl&__3.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__3.clone._definition
)))

;; Function-Specs builtin::impl&%4::clone
(declare-fun ens%builtin!impl&%4.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%builtin!impl&%4.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (TRACKED T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%builtin!impl&%4.clone. T&. T& b! res!))
   :qid internal_ens__builtin!impl&__4.clone._definition
   :skolemid skolem_internal_ens__builtin!impl&__4.clone._definition
)))

;; Function-Specs builtin::impl&%2::clone
(declare-fun ens%builtin!impl&%2.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%builtin!impl&%2.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (GHOST T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%builtin!impl&%2.clone. T&. T& b! res!))
   :qid internal_ens__builtin!impl&__2.clone._definition
   :skolemid skolem_internal_ens__builtin!impl&__2.clone._definition
)))

;; Function-Axioms vstd::map::impl&%0::dom
(assert
 (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!map.Map. K&. K& V&. V&))
    (has_type (vstd!map.impl&%0.dom.? K&. K& V&. V& self!) (TYPE%vstd!set.Set. K&. K&))
   )
   :pattern ((vstd!map.impl&%0.dom.? K&. K& V&. V& self!))
   :qid internal_vstd!map.impl&__0.dom.?_pre_post_definition
   :skolemid skolem_internal_vstd!map.impl&__0.dom.?_pre_post_definition
)))

;; Function-Specs vstd::map::impl&%0::index
(declare-fun req%vstd!map.impl&%0.index. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly) (key! Poly)) (!
   (= (req%vstd!map.impl&%0.index. K&. K& V&. V& self! key!) (=>
     %%global_location_label%%0
     (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& self!) key!)
   ))
   :pattern ((req%vstd!map.impl&%0.index. K&. K& V&. V& self! key!))
   :qid internal_req__vstd!map.impl&__0.index._definition
   :skolemid skolem_internal_req__vstd!map.impl&__0.index._definition
)))

;; Function-Axioms vstd::map::impl&%0::index
(assert
 (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly) (key! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!map.Map. K&. K& V&. V&))
     (has_type key! K&)
    )
    (has_type (vstd!map.impl&%0.index.? K&. K& V&. V& self! key!) V&)
   )
   :pattern ((vstd!map.impl&%0.index.? K&. K& V&. V& self! key!))
   :qid internal_vstd!map.impl&__0.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!map.impl&__0.index.?_pre_post_definition
)))

;; Function-Specs vstd::map::impl&%0::spec_index
(declare-fun req%vstd!map.impl&%0.spec_index. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly) (key! Poly)) (!
   (= (req%vstd!map.impl&%0.spec_index. K&. K& V&. V& self! key!) (=>
     %%global_location_label%%1
     (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& self!) key!)
   ))
   :pattern ((req%vstd!map.impl&%0.spec_index. K&. K& V&. V& self! key!))
   :qid internal_req__vstd!map.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!map.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::map::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!map.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!map.impl&%0.spec_index.)
  (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly) (key! Poly)) (!
    (= (vstd!map.impl&%0.spec_index.? K&. K& V&. V& self! key!) (vstd!map.impl&%0.index.?
      K&. K& V&. V& self! key!
    ))
    :pattern ((vstd!map.impl&%0.spec_index.? K&. K& V&. V& self! key!))
    :qid internal_vstd!map.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!map.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (self! Poly) (key! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!map.Map. K&. K& V&. V&))
     (has_type key! K&)
    )
    (has_type (vstd!map.impl&%0.spec_index.? K&. K& V&. V& self! key!) V&)
   )
   :pattern ((vstd!map.impl&%0.spec_index.? K&. K& V&. V& self! key!))
   :qid internal_vstd!map.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!map.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::map::axiom_map_index_decreases_finite
(assert
 (=>
  (fuel_bool fuel%vstd!map.axiom_map_index_decreases_finite.)
  (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (m! Poly) (key! Poly)) (!
    (=>
     (and
      (has_type m! (TYPE%vstd!map.Map. K&. K& V&. V&))
      (has_type key! K&)
     )
     (=>
      (and
       (vstd!set.impl&%0.finite.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& m!))
       (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& m!) key!)
      )
      (height_lt (height (vstd!map.impl&%0.index.? K&. K& V&. V& m! key!)) (height m!))
    ))
    :pattern ((height (vstd!map.impl&%0.index.? K&. K& V&. V& m! key!)))
    :qid user_vstd__map__axiom_map_index_decreases_finite_0
    :skolemid skolem_user_vstd__map__axiom_map_index_decreases_finite_0
))))

;; Broadcast vstd::map::axiom_map_index_decreases_infinite
(assert
 (=>
  (fuel_bool fuel%vstd!map.axiom_map_index_decreases_infinite.)
  (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (m! Poly) (key! Poly)) (!
    (=>
     (and
      (has_type m! (TYPE%vstd!map.Map. K&. K& V&. V&))
      (has_type key! K&)
     )
     (=>
      (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& m!) key!)
      (height_lt (height (vstd!map.impl&%0.index.? K&. K& V&. V& m! key!)) (height (fun_from_recursive_field
         m!
    )))))
    :pattern ((height (vstd!map.impl&%0.index.? K&. K& V&. V& m! key!)))
    :qid user_vstd__map__axiom_map_index_decreases_infinite_1
    :skolemid skolem_user_vstd__map__axiom_map_index_decreases_infinite_1
))))

;; Broadcast vstd::map::axiom_map_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!map.axiom_map_ext_equal.)
  (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (m1! Poly) (m2! Poly)) (!
    (=>
     (and
      (has_type m1! (TYPE%vstd!map.Map. K&. K& V&. V&))
      (has_type m2! (TYPE%vstd!map.Map. K&. K& V&. V&))
     )
     (= (ext_eq false (TYPE%vstd!map.Map. K&. K& V&. V&) m1! m2!) (and
       (ext_eq false (TYPE%vstd!set.Set. K&. K&) (vstd!map.impl&%0.dom.? K&. K& V&. V& m1!)
        (vstd!map.impl&%0.dom.? K&. K& V&. V& m2!)
       )
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ K&)
          (=>
           (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& m1!) k$)
           (= (vstd!map.impl&%0.index.? K&. K& V&. V& m1! k$) (vstd!map.impl&%0.index.? K&. K&
             V&. V& m2! k$
         ))))
         :pattern ((vstd!map.impl&%0.index.? K&. K& V&. V& m1! k$))
         :pattern ((vstd!map.impl&%0.index.? K&. K& V&. V& m2! k$))
         :qid user_vstd__map__axiom_map_ext_equal_2
         :skolemid skolem_user_vstd__map__axiom_map_ext_equal_2
    )))))
    :pattern ((ext_eq false (TYPE%vstd!map.Map. K&. K& V&. V&) m1! m2!))
    :qid user_vstd__map__axiom_map_ext_equal_3
    :skolemid skolem_user_vstd__map__axiom_map_ext_equal_3
))))

;; Broadcast vstd::map::axiom_map_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!map.axiom_map_ext_equal_deep.)
  (forall ((K&. Dcr) (K& Type) (V&. Dcr) (V& Type) (m1! Poly) (m2! Poly)) (!
    (=>
     (and
      (has_type m1! (TYPE%vstd!map.Map. K&. K& V&. V&))
      (has_type m2! (TYPE%vstd!map.Map. K&. K& V&. V&))
     )
     (= (ext_eq true (TYPE%vstd!map.Map. K&. K& V&. V&) m1! m2!) (and
       (ext_eq true (TYPE%vstd!set.Set. K&. K&) (vstd!map.impl&%0.dom.? K&. K& V&. V& m1!)
        (vstd!map.impl&%0.dom.? K&. K& V&. V& m2!)
       )
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ K&)
          (=>
           (vstd!set.impl&%0.contains.? K&. K& (vstd!map.impl&%0.dom.? K&. K& V&. V& m1!) k$)
           (ext_eq true V& (vstd!map.impl&%0.index.? K&. K& V&. V& m1! k$) (vstd!map.impl&%0.index.?
             K&. K& V&. V& m2! k$
         ))))
         :pattern ((vstd!map.impl&%0.index.? K&. K& V&. V& m1! k$))
         :pattern ((vstd!map.impl&%0.index.? K&. K& V&. V& m2! k$))
         :qid user_vstd__map__axiom_map_ext_equal_deep_4
         :skolemid skolem_user_vstd__map__axiom_map_ext_equal_deep_4
    )))))
    :pattern ((ext_eq true (TYPE%vstd!map.Map. K&. K& V&. V&) m1! m2!))
    :qid user_vstd__map__axiom_map_ext_equal_deep_5
    :skolemid skolem_user_vstd__map__axiom_map_ext_equal_deep_5
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%2
     (and
      (<= 0 (%I i!))
      (< (%I i!) (vstd!seq.Seq.len.? A&. A& self!))
   )))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%3
     (and
      (<= 0 (%I i!))
      (< (%I i!) (vstd!seq.Seq.len.? A&. A& self!))
   )))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (<= 0 (%I i!))
       (< (%I i!) (vstd!seq.Seq.len.? A&. A& s!))
      )
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_6
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_6
))))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
        len! f!
       )
      ) (%I len!)
    ))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_7
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_7
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (<= 0 (%I i!))
       (< (%I i!) (%I len!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_8
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_8
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
       (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (and
            (<= 0 (%I i$))
            (< (%I i$) (vstd!seq.Seq.len.? A&. A& s1!))
           )
           (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
         ))
         :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
         :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
         :qid user_vstd__seq__axiom_seq_ext_equal_9
         :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_9
    )))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_10
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_10
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
       (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (and
            (<= 0 (%I i$))
            (< (%I i$) (vstd!seq.Seq.len.? A&. A& s1!))
           )
           (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
         :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
         :qid user_vstd__seq__axiom_seq_ext_equal_deep_11
         :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_11
    )))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_12
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_12
))))

;; Broadcast vstd::set::axiom_set_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!set.axiom_set_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!set.Set. A&. A&))
      (has_type s2! (TYPE%vstd!set.Set. A&. A&))
     )
     (= (ext_eq false (TYPE%vstd!set.Set. A&. A&) s1! s2!) (forall ((a$ Poly)) (!
        (=>
         (has_type a$ A&)
         (= (vstd!set.impl&%0.contains.? A&. A& s1! a$) (vstd!set.impl&%0.contains.? A&. A&
           s2! a$
        )))
        :pattern ((vstd!set.impl&%0.contains.? A&. A& s1! a$))
        :pattern ((vstd!set.impl&%0.contains.? A&. A& s2! a$))
        :qid user_vstd__set__axiom_set_ext_equal_13
        :skolemid skolem_user_vstd__set__axiom_set_ext_equal_13
    ))))
    :pattern ((ext_eq false (TYPE%vstd!set.Set. A&. A&) s1! s2!))
    :qid user_vstd__set__axiom_set_ext_equal_14
    :skolemid skolem_user_vstd__set__axiom_set_ext_equal_14
))))

;; Broadcast vstd::set::axiom_set_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!set.axiom_set_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!set.Set. A&. A&))
      (has_type s2! (TYPE%vstd!set.Set. A&. A&))
     )
     (= (ext_eq true (TYPE%vstd!set.Set. A&. A&) s1! s2!) (ext_eq false (TYPE%vstd!set.Set.
        A&. A&
       ) s1! s2!
    )))
    :pattern ((ext_eq true (TYPE%vstd!set.Set. A&. A&) s1! s2!))
    :qid user_vstd__set__axiom_set_ext_equal_deep_15
    :skolemid skolem_user_vstd__set__axiom_set_ext_equal_deep_15
))))

;; Function-Axioms vstd::simple_pptr::impl&%1::addr
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!simple_pptr.PointsTo. V&. V&))
    (uInv SZ (vstd!simple_pptr.impl&%1.addr.? V&. V& self!))
   )
   :pattern ((vstd!simple_pptr.impl&%1.addr.? V&. V& self!))
   :qid internal_vstd!simple_pptr.impl&__1.addr.?_pre_post_definition
   :skolemid skolem_internal_vstd!simple_pptr.impl&__1.addr.?_pre_post_definition
)))

;; Function-Axioms vstd::simple_pptr::impl&%1::mem_contents
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!simple_pptr.PointsTo. V&. V&))
    (has_type (Poly%vstd!raw_ptr.MemContents. (vstd!simple_pptr.impl&%1.mem_contents.? V&.
       V& self!
      )
     ) (TYPE%vstd!raw_ptr.MemContents. V&. V&)
   ))
   :pattern ((vstd!simple_pptr.impl&%1.mem_contents.? V&. V& self!))
   :qid internal_vstd!simple_pptr.impl&__1.mem_contents.?_pre_post_definition
   :skolemid skolem_internal_vstd!simple_pptr.impl&__1.mem_contents.?_pre_post_definition
)))

;; Function-Specs vstd::simple_pptr::impl&%2::clone
(declare-fun ens%vstd!simple_pptr.impl&%2.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly) (res! Poly)) (!
   (= (ens%vstd!simple_pptr.impl&%2.clone. V&. V& self! res!) (and
     (ens%core!clone.Clone.clone. $ (TYPE%vstd!simple_pptr.PPtr. V&. V&) self! res!)
     (= res! self!)
   ))
   :pattern ((ens%vstd!simple_pptr.impl&%2.clone. V&. V& self! res!))
   :qid internal_ens__vstd!simple_pptr.impl&__2.clone._definition
   :skolemid skolem_internal_ens__vstd!simple_pptr.impl&__2.clone._definition
)))

;; Function-Axioms vstd::simple_pptr::impl&%1::pptr
(assert
 (fuel_bool_default fuel%vstd!simple_pptr.impl&%1.pptr.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!simple_pptr.impl&%1.pptr.)
  (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
    (= (vstd!simple_pptr.impl&%1.pptr.? V&. V& self!) (vstd!simple_pptr.PPtr./PPtr (%I (
        I (vstd!simple_pptr.impl&%1.addr.? V&. V& self!)
       )
      ) (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
    ))
    :pattern ((vstd!simple_pptr.impl&%1.pptr.? V&. V& self!))
    :qid internal_vstd!simple_pptr.impl&__1.pptr.?_definition
    :skolemid skolem_internal_vstd!simple_pptr.impl&__1.pptr.?_definition
))))
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!simple_pptr.PointsTo. V&. V&))
    (has_type (Poly%vstd!simple_pptr.PPtr. (vstd!simple_pptr.impl&%1.pptr.? V&. V& self!))
     (TYPE%vstd!simple_pptr.PPtr. V&. V&)
   ))
   :pattern ((vstd!simple_pptr.impl&%1.pptr.? V&. V& self!))
   :qid internal_vstd!simple_pptr.impl&__1.pptr.?_pre_post_definition
   :skolemid skolem_internal_vstd!simple_pptr.impl&__1.pptr.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%7::is_uninit
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%7.is_uninit.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%7.is_uninit.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!raw_ptr.impl&%7.is_uninit.? T&. T& self!) (is-vstd!raw_ptr.MemContents./Uninit
      (%Poly%vstd!raw_ptr.MemContents. self!)
    ))
    :pattern ((vstd!raw_ptr.impl&%7.is_uninit.? T&. T& self!))
    :qid internal_vstd!raw_ptr.impl&__7.is_uninit.?_definition
    :skolemid skolem_internal_vstd!raw_ptr.impl&__7.is_uninit.?_definition
))))

;; Function-Axioms vstd::simple_pptr::impl&%1::is_uninit
(assert
 (fuel_bool_default fuel%vstd!simple_pptr.impl&%1.is_uninit.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!simple_pptr.impl&%1.is_uninit.)
  (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
    (= (vstd!simple_pptr.impl&%1.is_uninit.? V&. V& self!) (is-vstd!raw_ptr.MemContents./Uninit
      (vstd!simple_pptr.impl&%1.mem_contents.? V&. V& self!)
    ))
    :pattern ((vstd!simple_pptr.impl&%1.is_uninit.? V&. V& self!))
    :qid internal_vstd!simple_pptr.impl&__1.is_uninit.?_definition
    :skolemid skolem_internal_vstd!simple_pptr.impl&__1.is_uninit.?_definition
))))

;; Function-Specs vstd::simple_pptr::impl&%4::empty
(declare-fun ens%vstd!simple_pptr.impl&%4.empty. (Dcr Type tuple%2.) Bool)
(assert
 (forall ((V&. Dcr) (V& Type) (pt! tuple%2.)) (!
   (= (ens%vstd!simple_pptr.impl&%4.empty. V&. V& pt!) (and
     (has_type (Poly%tuple%2. pt!) (TYPE%tuple%2. $ (TYPE%vstd!simple_pptr.PPtr. V&. V&)
       (TRACKED $) (TYPE%vstd!simple_pptr.PointsTo. V&. V&)
     ))
     (= (vstd!simple_pptr.PPtr./PPtr (%I (I (vstd!simple_pptr.impl&%1.addr.? V&. V& (tuple%2./tuple%2/1
           (%Poly%tuple%2. (Poly%tuple%2. pt!))
        )))
       ) (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
      ) (%Poly%vstd!simple_pptr.PPtr. (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. pt!))))
     )
     (is-vstd!raw_ptr.MemContents./Uninit (vstd!simple_pptr.impl&%1.mem_contents.? V&. V&
       (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pt!)))
   ))))
   :pattern ((ens%vstd!simple_pptr.impl&%4.empty. V&. V& pt!))
   :qid internal_ens__vstd!simple_pptr.impl&__4.empty._definition
   :skolemid skolem_internal_ens__vstd!simple_pptr.impl&__4.empty._definition
)))

;; Function-Specs vstd::simple_pptr::impl&%4::write
(declare-fun req%vstd!simple_pptr.impl&%4.write. (Dcr Type vstd!simple_pptr.PPtr. Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((V&. Dcr) (V& Type) (self! vstd!simple_pptr.PPtr.) (pre%perm! Poly) (in_v!
    Poly
   )
  ) (!
   (= (req%vstd!simple_pptr.impl&%4.write. V&. V& self! pre%perm! in_v!) (=>
     %%global_location_label%%4
     (= (vstd!simple_pptr.PPtr./PPtr (%I (I (vstd!simple_pptr.impl&%1.addr.? V&. V& pre%perm!)))
       (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
      ) self!
   )))
   :pattern ((req%vstd!simple_pptr.impl&%4.write. V&. V& self! pre%perm! in_v!))
   :qid internal_req__vstd!simple_pptr.impl&__4.write._definition
   :skolemid skolem_internal_req__vstd!simple_pptr.impl&__4.write._definition
)))
(declare-fun ens%vstd!simple_pptr.impl&%4.write. (Dcr Type vstd!simple_pptr.PPtr. Poly
  Poly Poly
 ) Bool
)
(assert
 (forall ((V&. Dcr) (V& Type) (self! vstd!simple_pptr.PPtr.) (pre%perm! Poly) (perm!
    Poly
   ) (in_v! Poly)
  ) (!
   (= (ens%vstd!simple_pptr.impl&%4.write. V&. V& self! pre%perm! perm! in_v!) (and
     (has_type perm! (TYPE%vstd!simple_pptr.PointsTo. V&. V&))
     (= (vstd!simple_pptr.PPtr./PPtr (%I (I (vstd!simple_pptr.impl&%1.addr.? V&. V& perm!)))
       (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
      ) (vstd!simple_pptr.PPtr./PPtr (%I (I (vstd!simple_pptr.impl&%1.addr.? V&. V& pre%perm!)))
       (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
     ))
     (= (vstd!simple_pptr.impl&%1.mem_contents.? V&. V& perm!) (vstd!raw_ptr.MemContents./Init
       in_v!
   ))))
   :pattern ((ens%vstd!simple_pptr.impl&%4.write. V&. V& self! pre%perm! perm! in_v!))
   :qid internal_ens__vstd!simple_pptr.impl&__4.write._definition
   :skolemid skolem_internal_ens__vstd!simple_pptr.impl&__4.write._definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%2::arrow_0
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%2.arrow_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%2.arrow_0.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!raw_ptr.impl&%2.arrow_0.? T&. T& self!) (vstd!raw_ptr.MemContents./Init/0
      (%Poly%vstd!raw_ptr.MemContents. self!)
    ))
    :pattern ((vstd!raw_ptr.impl&%2.arrow_0.? T&. T& self!))
    :qid internal_vstd!raw_ptr.impl&__2.arrow_0.?_definition
    :skolemid skolem_internal_vstd!raw_ptr.impl&__2.arrow_0.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!raw_ptr.MemContents. T&. T&))
    (has_type (vstd!raw_ptr.impl&%2.arrow_0.? T&. T& self!) T&)
   )
   :pattern ((vstd!raw_ptr.impl&%2.arrow_0.? T&. T& self!))
   :qid internal_vstd!raw_ptr.impl&__2.arrow_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.impl&__2.arrow_0.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%7::is_init
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%7.is_init.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%7.is_init.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!raw_ptr.impl&%7.is_init.? T&. T& self!) (is-vstd!raw_ptr.MemContents./Init
      (%Poly%vstd!raw_ptr.MemContents. self!)
    ))
    :pattern ((vstd!raw_ptr.impl&%7.is_init.? T&. T& self!))
    :qid internal_vstd!raw_ptr.impl&__7.is_init.?_definition
    :skolemid skolem_internal_vstd!raw_ptr.impl&__7.is_init.?_definition
))))

;; Function-Axioms vstd::raw_ptr::impl&%7::value
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%7.value.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%7.value.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!raw_ptr.impl&%7.value.? T&. T& self!) (vstd!raw_ptr.MemContents./Init/0 (%Poly%vstd!raw_ptr.MemContents.
       self!
    )))
    :pattern ((vstd!raw_ptr.impl&%7.value.? T&. T& self!))
    :qid internal_vstd!raw_ptr.impl&__7.value.?_definition
    :skolemid skolem_internal_vstd!raw_ptr.impl&__7.value.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!raw_ptr.MemContents. T&. T&))
    (has_type (vstd!raw_ptr.impl&%7.value.? T&. T& self!) T&)
   )
   :pattern ((vstd!raw_ptr.impl&%7.value.? T&. T& self!))
   :qid internal_vstd!raw_ptr.impl&__7.value.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.impl&__7.value.?_pre_post_definition
)))

;; Function-Axioms vstd::simple_pptr::impl&%1::is_init
(assert
 (fuel_bool_default fuel%vstd!simple_pptr.impl&%1.is_init.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!simple_pptr.impl&%1.is_init.)
  (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
    (= (vstd!simple_pptr.impl&%1.is_init.? V&. V& self!) (is-vstd!raw_ptr.MemContents./Init
      (vstd!simple_pptr.impl&%1.mem_contents.? V&. V& self!)
    ))
    :pattern ((vstd!simple_pptr.impl&%1.is_init.? V&. V& self!))
    :qid internal_vstd!simple_pptr.impl&__1.is_init.?_definition
    :skolemid skolem_internal_vstd!simple_pptr.impl&__1.is_init.?_definition
))))

;; Function-Specs vstd::simple_pptr::impl&%1::value
(declare-fun req%vstd!simple_pptr.impl&%1.value. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
   (= (req%vstd!simple_pptr.impl&%1.value. V&. V& self!) (=>
     %%global_location_label%%5
     (is-vstd!raw_ptr.MemContents./Init (vstd!simple_pptr.impl&%1.mem_contents.? V&. V&
       self!
   ))))
   :pattern ((req%vstd!simple_pptr.impl&%1.value. V&. V& self!))
   :qid internal_req__vstd!simple_pptr.impl&__1.value._definition
   :skolemid skolem_internal_req__vstd!simple_pptr.impl&__1.value._definition
)))

;; Function-Axioms vstd::simple_pptr::impl&%1::value
(assert
 (fuel_bool_default fuel%vstd!simple_pptr.impl&%1.value.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!simple_pptr.impl&%1.value.)
  (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
    (= (vstd!simple_pptr.impl&%1.value.? V&. V& self!) (vstd!raw_ptr.MemContents./Init/0
      (%Poly%vstd!raw_ptr.MemContents. (Poly%vstd!raw_ptr.MemContents. (vstd!simple_pptr.impl&%1.mem_contents.?
         V&. V& self!
    )))))
    :pattern ((vstd!simple_pptr.impl&%1.value.? V&. V& self!))
    :qid internal_vstd!simple_pptr.impl&__1.value.?_definition
    :skolemid skolem_internal_vstd!simple_pptr.impl&__1.value.?_definition
))))
(assert
 (forall ((V&. Dcr) (V& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!simple_pptr.PointsTo. V&. V&))
    (has_type (vstd!simple_pptr.impl&%1.value.? V&. V& self!) V&)
   )
   :pattern ((vstd!simple_pptr.impl&%1.value.? V&. V& self!))
   :qid internal_vstd!simple_pptr.impl&__1.value.?_pre_post_definition
   :skolemid skolem_internal_vstd!simple_pptr.impl&__1.value.?_pre_post_definition
)))

;; Function-Axioms singly_linked_list_trivial::LList::view
(assert
 (fuel_bool_default fuel%singly_linked_list_trivial!impl&%3.view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type Poly Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    Poly
   ) (%%hole%%5 Dcr) (%%hole%%6 Type) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5
      %%hole%%6
     ) i$
    ) (I (singly_linked_list_trivial!Node./Node/x (%Poly%singly_linked_list_trivial!Node.
       (vstd!raw_ptr.MemContents./Init/0 (%Poly%vstd!raw_ptr.MemContents. (Poly%vstd!raw_ptr.MemContents.
          (vstd!simple_pptr.impl&%1.mem_contents.? %%hole%%5 %%hole%%6 (vstd!map.impl&%0.index.?
            %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 (I (nClip (%I i$)))
   )))))))))
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4
      %%hole%%5 %%hole%%6
     ) i$
)))))
(assert
 (=>
  (fuel_bool fuel%singly_linked_list_trivial!impl&%3.view.)
  (forall ((self! Poly)) (!
    (= (singly_linked_list_trivial!impl&%3.view.? self!) (%Poly%vstd!seq.Seq<usize.>. (
       vstd!seq.Seq.new.? $ (UINT SZ) $ (TYPE%fun%1. $ INT $ (UINT SZ)) (I (vstd!seq.Seq.len.?
         $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.) (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>.
          (singly_linked_list_trivial!LList./LList/ptrs (%Poly%singly_linked_list_trivial!LList.
            self!
        ))))
       ) (Poly%fun%1. (mk_fun (%%lambda%%0 $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)
          (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
           (singly_linked_list_trivial!LList./LList/perms (%Poly%singly_linked_list_trivial!LList.
             self!
           ))
          ) $ TYPE%singly_linked_list_trivial!Node.
    ))))))
    :pattern ((singly_linked_list_trivial!impl&%3.view.? self!))
    :qid internal_singly_linked_list_trivial!impl&__3.view.?_definition
    :skolemid skolem_internal_singly_linked_list_trivial!impl&__3.view.?_definition
))))

;; Function-Axioms singly_linked_list_trivial::LList::next_of
(assert
 (fuel_bool_default fuel%singly_linked_list_trivial!impl&%3.next_of.)
)
(assert
 (=>
  (fuel_bool fuel%singly_linked_list_trivial!impl&%3.next_of.)
  (forall ((self! Poly) (i! Poly)) (!
    (= (singly_linked_list_trivial!impl&%3.next_of.? self! i!) (ite
      (= (nClip (Add (%I i!) 1)) (vstd!seq.Seq.len.? $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.)
        (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. (singly_linked_list_trivial!LList./LList/ptrs
          (%Poly%singly_linked_list_trivial!LList. self!)
      ))))
      core!option.Option./None
      (core!option.Option./Some (vstd!seq.Seq.index.? $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.)
        (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. (singly_linked_list_trivial!LList./LList/ptrs
          (%Poly%singly_linked_list_trivial!LList. self!)
         )
        ) (I (Add (%I i!) 1))
    ))))
    :pattern ((singly_linked_list_trivial!impl&%3.next_of.? self! i!))
    :qid internal_singly_linked_list_trivial!impl&__3.next_of.?_definition
    :skolemid skolem_internal_singly_linked_list_trivial!impl&__3.next_of.?_definition
))))
(assert
 (forall ((self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! TYPE%singly_linked_list_trivial!LList.)
     (has_type i! NAT)
    )
    (has_type (Poly%core!option.Option. (singly_linked_list_trivial!impl&%3.next_of.? self!
       i!
      )
     ) (TYPE%core!option.Option. $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.))
   ))
   :pattern ((singly_linked_list_trivial!impl&%3.next_of.? self! i!))
   :qid internal_singly_linked_list_trivial!impl&__3.next_of.?_pre_post_definition
   :skolemid skolem_internal_singly_linked_list_trivial!impl&__3.next_of.?_pre_post_definition
)))

;; Function-Axioms singly_linked_list_trivial::LList::wf_node
(assert
 (fuel_bool_default fuel%singly_linked_list_trivial!impl&%3.wf_node.)
)
(assert
 (=>
  (fuel_bool fuel%singly_linked_list_trivial!impl&%3.wf_node.)
  (forall ((self! Poly) (i! Poly)) (!
    (= (singly_linked_list_trivial!impl&%3.wf_node.? self! i!) (and
      (and
       (vstd!set.impl&%0.contains.? $ NAT (vstd!map.impl&%0.dom.? $ NAT $ (TYPE%vstd!simple_pptr.PointsTo.
          $ TYPE%singly_linked_list_trivial!Node.
         ) (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
          (singly_linked_list_trivial!LList./LList/perms (%Poly%singly_linked_list_trivial!LList.
            self!
         )))
        ) i!
       )
       (= (vstd!simple_pptr.PPtr./PPtr (%I (I (vstd!simple_pptr.impl&%1.addr.? $ TYPE%singly_linked_list_trivial!Node.
            (vstd!map.impl&%0.index.? $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)
             (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
              (singly_linked_list_trivial!LList./LList/perms (%Poly%singly_linked_list_trivial!LList.
                self!
              ))
             ) i!
          )))
         ) (%Poly%core!marker.PhantomData. (Poly%core!marker.PhantomData. core!marker.PhantomData./PhantomData))
        ) (%Poly%vstd!simple_pptr.PPtr. (vstd!seq.Seq.index.? $ (TYPE%vstd!simple_pptr.PPtr.
           $ TYPE%singly_linked_list_trivial!Node.
          ) (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. (singly_linked_list_trivial!LList./LList/ptrs
            (%Poly%singly_linked_list_trivial!LList. self!)
           )
          ) i!
      ))))
      (let
       ((tmp%%$ (vstd!simple_pptr.impl&%1.mem_contents.? $ TYPE%singly_linked_list_trivial!Node.
          (vstd!map.impl&%0.index.? $ NAT $ (TYPE%vstd!simple_pptr.PointsTo. $ TYPE%singly_linked_list_trivial!Node.)
           (Poly%vstd!map.Map<nat./vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.>.
            (singly_linked_list_trivial!LList./LList/perms (%Poly%singly_linked_list_trivial!LList.
              self!
            ))
           ) i!
       ))))
       (and
        (is-vstd!raw_ptr.MemContents./Init tmp%%$)
        (let
         ((node$ (%Poly%singly_linked_list_trivial!Node. (vstd!raw_ptr.MemContents./Init/0 (%Poly%vstd!raw_ptr.MemContents.
              (Poly%vstd!raw_ptr.MemContents. tmp%%$)
         )))))
         (= (singly_linked_list_trivial!Node./Node/next (%Poly%singly_linked_list_trivial!Node.
            (Poly%singly_linked_list_trivial!Node. node$)
           )
          ) (singly_linked_list_trivial!impl&%3.next_of.? self! i!)
    ))))))
    :pattern ((singly_linked_list_trivial!impl&%3.wf_node.? self! i!))
    :qid internal_singly_linked_list_trivial!impl&__3.wf_node.?_definition
    :skolemid skolem_internal_singly_linked_list_trivial!impl&__3.wf_node.?_definition
))))

;; Function-Axioms singly_linked_list_trivial::LList::wf
(assert
 (fuel_bool_default fuel%singly_linked_list_trivial!impl&%3.wf.)
)
(assert
 (=>
  (fuel_bool fuel%singly_linked_list_trivial!impl&%3.wf.)
  (forall ((self! Poly)) (!
    (= (singly_linked_list_trivial!impl&%3.wf.? self!) (forall ((i$ Poly)) (!
       (=>
        (has_type i$ NAT)
        (=>
         (and
          (<= 0 (%I i$))
          (<= (%I i$) (vstd!seq.Seq.len.? $ (TYPE%vstd!simple_pptr.PPtr. $ TYPE%singly_linked_list_trivial!Node.)
            (Poly%vstd!seq.Seq<vstd!simple_pptr.PPtr<singly_linked_list_trivial!Node.>.>. (singly_linked_list_trivial!LList./LList/ptrs
              (%Poly%singly_linked_list_trivial!LList. self!)
         )))))
         (singly_linked_list_trivial!impl&%3.wf_node.? self! i$)
       ))
       :pattern ((singly_linked_list_trivial!impl&%3.wf_node.? self! i$))
       :qid user_singly_linked_list_trivial__LList__wf_16
       :skolemid skolem_user_singly_linked_list_trivial__LList__wf_16
    )))
    :pattern ((singly_linked_list_trivial!impl&%3.wf.? self!))
    :qid internal_singly_linked_list_trivial!impl&__3.wf.?_definition
    :skolemid skolem_internal_singly_linked_list_trivial!impl&__3.wf.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (tr_bound%core!clone.Clone. $ (TYPE%vstd!simple_pptr.PPtr. V&. V&))
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%vstd!simple_pptr.PPtr. V&. V&)))
   :qid internal_vstd__simple_pptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__simple_pptr__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT SZ))
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. $ (TYPE%core!marker.PhantomData. T&. T&))
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!marker.PhantomData. T&. T&)))
   :qid internal_core__marker__impl&__13_trait_impl_definition
   :skolemid skolem_internal_core__marker__impl&__13_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (REF T&.) T&)
   :pattern ((tr_bound%core!clone.Clone. (REF T&.) T&))
   :qid internal_core__clone__impls__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!clone.Clone. T&. T&)
    (tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (tr_bound%core!clone.Clone. (TRACKED A&.) A&)
   :pattern ((tr_bound%core!clone.Clone. (TRACKED A&.) A&))
   :qid internal_builtin__impl&__4_trait_impl_definition
   :skolemid skolem_internal_builtin__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (tr_bound%core!clone.Clone. (GHOST A&.) A&)
   :pattern ((tr_bound%core!clone.Clone. (GHOST A&.) A&))
   :qid internal_builtin__impl&__2_trait_impl_definition
   :skolemid skolem_internal_builtin__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%singly_linked_list_trivial!Node.)
)

;; Function-Specs singly_linked_list_trivial::LList::push_front
(declare-fun req%singly_linked_list_trivial!impl&%3.push_front. (singly_linked_list_trivial!LList.
  Int
 ) Bool
)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((pre%self! singly_linked_list_trivial!LList.) (v! Int)) (!
   (= (req%singly_linked_list_trivial!impl&%3.push_front. pre%self! v!) (=>
     %%global_location_label%%6
     (singly_linked_list_trivial!impl&%3.wf.? (Poly%singly_linked_list_trivial!LList. pre%self!))
   ))
   :pattern ((req%singly_linked_list_trivial!impl&%3.push_front. pre%self! v!))
   :qid internal_req__singly_linked_list_trivial!impl&__3.push_front._definition
   :skolemid skolem_internal_req__singly_linked_list_trivial!impl&__3.push_front._definition
)))
(declare-fun ens%singly_linked_list_trivial!impl&%3.push_front. (singly_linked_list_trivial!LList.
  singly_linked_list_trivial!LList. Int
 ) Bool
)
(assert
 (forall ((pre%self! singly_linked_list_trivial!LList.) (self! singly_linked_list_trivial!LList.)
   (v! Int)
  ) (!
   (= (ens%singly_linked_list_trivial!impl&%3.push_front. pre%self! self! v!) (and
     (has_type (Poly%singly_linked_list_trivial!LList. self!) TYPE%singly_linked_list_trivial!LList.)
     (singly_linked_list_trivial!impl&%3.wf.? (Poly%singly_linked_list_trivial!LList. self!))
   ))
   :pattern ((ens%singly_linked_list_trivial!impl&%3.push_front. pre%self! self! v!))
   :qid internal_ens__singly_linked_list_trivial!impl&__3.push_front._definition
   :skolemid skolem_internal_ens__singly_linked_list_trivial!impl&__3.push_front._definition
)))

;; Function-Def singly_linked_list_trivial::LList::push_front
;; ./singly_linked_list_trivial.rs:48:9: 48:43 (#0)
(get-info :all-statistics)
(push)
 (declare-const self!@0 singly_linked_list_trivial!LList.)
 (declare-const v! Int)
 (declare-const tmp%1 Poly)
 (declare-const tmp%2 singly_linked_list_trivial!Node.)
 (declare-const old_first@ vstd!simple_pptr.PPtr.)
 (declare-const tmp%3 singly_linked_list_trivial!Node.)
 (declare-const tmp%4 core!option.Option.)
 (declare-const tmp%%$1@ core!option.Option.)
 (declare-const tmp%%@ tuple%2.)
 (declare-const node@ vstd!simple_pptr.PPtr.)
 (declare-const verus_tmp_perm@ vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const perm@0 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%singly_linked_list_trivial!LList. self!@0) TYPE%singly_linked_list_trivial!LList.)
 )
 (assert
  (uInv SZ v!)
 )
 (assert
  (singly_linked_list_trivial!impl&%3.wf.? (Poly%singly_linked_list_trivial!LList. self!@0))
 )
 (declare-const perm@1 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const perm@2 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const self!@1 singly_linked_list_trivial!LList.)
 (declare-const %%switch_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%2 Bool)
 (assert
  (not (=>
    (ens%vstd!simple_pptr.impl&%4.empty. $ TYPE%singly_linked_list_trivial!Node. tmp%%@)
    (=>
     (= node@ (%Poly%vstd!simple_pptr.PPtr. (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2.
          tmp%%@
     )))))
     (=>
      (= verus_tmp_perm@ (%Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
        (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%@)))
      ))
      (=>
       (= perm@1 verus_tmp_perm@)
       (=>
        (= tmp%%$1@ (singly_linked_list_trivial!LList./LList/first (%Poly%singly_linked_list_trivial!LList.
           (Poly%singly_linked_list_trivial!LList. self!@0)
        )))
        (or
         (and
          (=>
           (is-core!option.Option./Some tmp%%$1@)
           (=>
            (= old_first@ (%Poly%vstd!simple_pptr.PPtr. (core!option.Option./Some/0 (%Poly%core!option.Option.
                (Poly%core!option.Option. tmp%%$1@)
            ))))
            (=>
             (ens%vstd!simple_pptr.impl&%2.clone. $ TYPE%singly_linked_list_trivial!Node. (Poly%vstd!simple_pptr.PPtr.
               old_first@
              ) tmp%1
             )
             (=>
              (= tmp%2 (singly_linked_list_trivial!Node./Node (%Poly%core!option.Option. (Poly%core!option.Option.
                  (core!option.Option./Some tmp%1)
                 )
                ) (%I (I v!))
              ))
              (and
               (=>
                %%location_label%%0
                (req%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
                 (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%singly_linked_list_trivial!Node.
                  tmp%2
               )))
               (=>
                (ens%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
                 (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
                  perm@2
                 ) (Poly%singly_linked_list_trivial!Node. tmp%2)
                )
                (=>
                 (= self!@1 self!@0)
                 %%switch_label%%0
          )))))))
          (=>
           (not (is-core!option.Option./Some tmp%%$1@))
           (=>
            (= tmp%3 (singly_linked_list_trivial!Node./Node (%Poly%core!option.Option. (Poly%core!option.Option.
                core!option.Option./None
               )
              ) (%I (I v!))
            ))
            (and
             (=>
              %%location_label%%1
              (req%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
               (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%singly_linked_list_trivial!Node.
                tmp%3
             )))
             (=>
              (ens%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
               (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
                perm@2
               ) (Poly%singly_linked_list_trivial!Node. tmp%3)
              )
              (=>
               (= tmp%4 (core!option.Option./Some (Poly%vstd!simple_pptr.PPtr. node@)))
               (=>
                (= (singly_linked_list_trivial!LList./LList/first (%Poly%singly_linked_list_trivial!LList.
                   (Poly%singly_linked_list_trivial!LList. self!@1)
                  )
                 ) tmp%4
                )
                (=>
                 (and
                  (= (singly_linked_list_trivial!LList./LList/perms self!@0) (singly_linked_list_trivial!LList./LList/perms
                    self!@1
                  ))
                  (= (singly_linked_list_trivial!LList./LList/ptrs self!@0) (singly_linked_list_trivial!LList./LList/ptrs
                    self!@1
                 )))
                 %%switch_label%%0
         ))))))))
         (and
          (not %%switch_label%%0)
          (=>
           %%location_label%%2
           (singly_linked_list_trivial!impl&%3.wf.? (Poly%singly_linked_list_trivial!LList. self!@1))
 ))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
 (get-info :reason-unknown)
 (get-model)
 (assert
  (not %%location_label%%2)
 )
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)

;; Function-Recommends singly_linked_list_trivial::LList::push_front
;; ./singly_linked_list_trivial.rs:48:9: 48:43 (#0)
(get-info :all-statistics)
(push)
 (declare-const self!@0 singly_linked_list_trivial!LList.)
 (declare-const v! Int)
 (declare-const tmp%1 Poly)
 (declare-const tmp%2 singly_linked_list_trivial!Node.)
 (declare-const old_first@ vstd!simple_pptr.PPtr.)
 (declare-const tmp%3 singly_linked_list_trivial!Node.)
 (declare-const tmp%4 core!option.Option.)
 (declare-const tmp%%$1@ core!option.Option.)
 (declare-const tmp%%@ tuple%2.)
 (declare-const node@ vstd!simple_pptr.PPtr.)
 (declare-const verus_tmp_perm@ vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const perm@0 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%singly_linked_list_trivial!LList. self!@0) TYPE%singly_linked_list_trivial!LList.)
 )
 (assert
  (uInv SZ v!)
 )
 (declare-const perm@1 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const perm@2 vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.)
 (declare-const self!@1 singly_linked_list_trivial!LList.)
 (declare-const %%switch_label%%0 Bool)
 (assert
  (not (=>
    (singly_linked_list_trivial!impl&%3.wf.? (Poly%singly_linked_list_trivial!LList. self!@0))
    (=>
     (ens%vstd!simple_pptr.impl&%4.empty. $ TYPE%singly_linked_list_trivial!Node. tmp%%@)
     (=>
      (= node@ (%Poly%vstd!simple_pptr.PPtr. (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2.
           tmp%%@
      )))))
      (=>
       (= verus_tmp_perm@ (%Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
         (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%@)))
       ))
       (=>
        (= perm@1 verus_tmp_perm@)
        (=>
         (= tmp%%$1@ (singly_linked_list_trivial!LList./LList/first (%Poly%singly_linked_list_trivial!LList.
            (Poly%singly_linked_list_trivial!LList. self!@0)
         )))
         (or
          (and
           (=>
            (is-core!option.Option./Some tmp%%$1@)
            (=>
             (= old_first@ (%Poly%vstd!simple_pptr.PPtr. (core!option.Option./Some/0 (%Poly%core!option.Option.
                 (Poly%core!option.Option. tmp%%$1@)
             ))))
             (=>
              (ens%vstd!simple_pptr.impl&%2.clone. $ TYPE%singly_linked_list_trivial!Node. (Poly%vstd!simple_pptr.PPtr.
                old_first@
               ) tmp%1
              )
              (=>
               (= tmp%2 (singly_linked_list_trivial!Node./Node (%Poly%core!option.Option. (Poly%core!option.Option.
                   (core!option.Option./Some tmp%1)
                  )
                 ) (%I (I v!))
               ))
               (=>
                (ens%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
                 (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
                  perm@2
                 ) (Poly%singly_linked_list_trivial!Node. tmp%2)
                )
                (=>
                 (= self!@1 self!@0)
                 %%switch_label%%0
           ))))))
           (=>
            (not (is-core!option.Option./Some tmp%%$1@))
            (=>
             (= tmp%3 (singly_linked_list_trivial!Node./Node (%Poly%core!option.Option. (Poly%core!option.Option.
                 core!option.Option./None
                )
               ) (%I (I v!))
             ))
             (=>
              (ens%vstd!simple_pptr.impl&%4.write. $ TYPE%singly_linked_list_trivial!Node. node@
               (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>. perm@1) (Poly%vstd!simple_pptr.PointsTo<singly_linked_list_trivial!Node.>.
                perm@2
               ) (Poly%singly_linked_list_trivial!Node. tmp%3)
              )
              (=>
               (= tmp%4 (core!option.Option./Some (Poly%vstd!simple_pptr.PPtr. node@)))
               (=>
                (= (singly_linked_list_trivial!LList./LList/first (%Poly%singly_linked_list_trivial!LList.
                   (Poly%singly_linked_list_trivial!LList. self!@1)
                  )
                 ) tmp%4
                )
                (=>
                 (and
                  (= (singly_linked_list_trivial!LList./LList/perms self!@0) (singly_linked_list_trivial!LList./LList/perms
                    self!@1
                  ))
                  (= (singly_linked_list_trivial!LList./LList/ptrs self!@0) (singly_linked_list_trivial!LList./LList/ptrs
                    self!@1
                 )))
                 %%switch_label%%0
          )))))))
          (not %%switch_label%%0)
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)

;; Function-Def singly_linked_list_trivial::main
;; ./singly_linked_list_trivial.rs:65:5: 65:14 (#0)
(get-info :all-statistics)
(push)
 (declare-const no%param Int)
 (assert
  fuel_defaults
 )
 (assert
  (not true)
 )
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
