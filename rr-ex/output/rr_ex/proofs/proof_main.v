From caesium Require Import lang notation.
From refinedrust Require Import typing shims.
From refinedrust.examples.rr_ex.generated Require Import generated_code_rr_ex generated_specs_rr_ex generated_template_main.

Set Default Proof Using "Type".

Section proof.
Context `{!refinedrustGS Σ}.

Lemma main_proof (π : thread_id) :
  main_lemma π.
Proof.
  main_prelude.

  repeat liRStep; liShow.

  all: print_remaining_goal.
  Unshelve. all: sidecond_solver.
  Unshelve. all: sidecond_hammer.
  Unshelve. all: print_remaining_sidecond.
Admitted.
End proof.
