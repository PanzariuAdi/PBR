(defrule pbr_chestionar 
  (not (pbr ?))
  =>
  (printout t "Are you an AI enthusiast (y/n)?" crlf)
  (assert (pbr (read)))
)

(defrule gd_chestionar
  (pbr n)
  (not (gd ?))
  =>
  (printout t "Do you like games ? (y/n)" crlf)
  (assert (gd (read)))
)

(defrule tppm_chestionar
  (pbr n)
  (gd n)
  (not (tppm ?))
  =>
  (printout t "Would you like to create mobile apps ? (y/n)" crlf)
  (assert (tppm (read)))

)

(defrule actn_chestionar 
  (pbr n)
  (gd n)
  (tppm n)
  (not (actn ?))
  =>
  (printout t "Are you a math-guy ? (y/n)" crlf)
  (assert (actn (read)))
)

(defrule go_to_pbr
  (pbr y)
  =>
  (printout t "GO TO PBR !" crlf)
)

(defrule go_to_gd
  (pbr n)
  (gd y)
  =>
  (printout t "GO TO GD!" crlf)
)

(defrule go_to_tppm
  (pbr n)
  (gd n)
  (tppm y)
  =>
  (printout t "GO TO TPPM!" crlf)
)

(defrule go_to_actn
  (pbr n)
  (gd n)
  (tppm n)
  (actn y)
  =>
  (printout t "GO TO ACTN!" crlf)
)





(defrule hci_chestionar 
  (not (hci ?))
  =>
  (printout t "Do you like to design  (y/n)?" crlf)
  (assert (hci (read)))
)

(defrule pcpit_chestionar
  (hci n)
  (not (pcpit ?))
  =>
  (printout t "Do you like psychology ? (y/n)" crlf)
  (assert (pcpit (read)))
)

(defrule arms_chestionar
  (hci n)
  (pcpit n)
  (not (arms ?))
  =>
  (printout t "Do you like social media ? (y/n)" crlf)
  (assert (arms (read)))

)

(defrule cc_chestionar 
  (design n)
  (psyho n)
  (arms n)
  (not (cc ?))
  =>
  (printout t "Would you like to work in a field involving Cloud Computing ? (y/n)" crlf)
  (assert (cc (read)))
)

(defrule go_to_hci
  (hci y)
  =>
  (printout t "GO TO HCI !" crlf)
)

(defrule go_to_pcpit
  (hci n)
  (pcpit y)
  =>
  (printout t "GO TO PCPIT!" crlf)
)

(defrule go_to_arms
  (hci n)
  (pcpit n)
  (arms y)
  =>
  (printout t "GO TO ARMS!" crlf)
)

(defrule go_to_cc
  (hci n)
  (pcpit n)
  (arms n) 
  (cc y)
  =>
  (printout t "GO TO CC!" crlf)
)





(defrule rpa_chestionar 
  (not (rpa ?))
  =>
  (printout t "Do you like LFAC (y/n)?" crlf) 
  (assert (rpa (read)))
)

(defrule sca_chestionar
  (rpa n)
  (not (sca ?))
  =>
  (printout t "Do you like Java and bank system ? (y/n)" crlf)
  (assert (sca (read)))
)

(defrule mds_chestionar
  (rpa n)
  (sca n)
  (not (mds ?))
  =>
  (printout t "Do you digital systems ? (y/n)" crlf)
  (assert (mds (read)))
)

(defrule issa_chestionar 
  (rpa n)
  (sca n)
  (mds n)
  (not (issa ?))
  =>
  (printout t "Do you want to work at Continental ? (y/n)" crlf)
  (assert (issa (read)))
)

(defrule go_to_rpa
  (rpa y)
  =>
  (printout t "GO TO RPA !" crlf)
)

(defrule go_to_sca
  (rpa n)
  (sca y)
  =>
  (printout t "GO TO SCA!" crlf)
)

(defrule go_to_mds
  (rpa n)
  (sca n)
  (mds y)
  =>
  (printout t "GO TO MDS!" crlf)
)

(defrule go_to_issa
  (rpa n)
  (sca n)
  (mds n)
  (issa y)
  =>
  (printout t "GO TO ISSA!" crlf)
)

