(defrule pnp_question 
  (not (pnp ?))
  =>
  (printout t "Printer does print ? (y/n)" crlf)
  (assert (pnp (read)))
)

(defrule rlf_question 
  (not (rlf ?))
  =>
  (printout t "Is red light flashing ? (y/n)" crlf)
  (assert (rlf (read)))
)
 
(defrule pun_question 
  (not (pun ?))
  =>
  (printout t "Is printer unrecognized ? (y/n)" crlf)
  (assert (pun (read)))
)

(defrule power_cable
  (or 
    (and (pnp y) (rlf y) (pun n)) 
    (and (pnp n) (rlf n) (pun n))
  )
  =>
  (printout t "Check the power cable !" crlf)
)


(defrule printer_computer_cable
  (or 
    (and (pnp y) (rlf y) (pun y)) 
    (and (pnp y) (rlf n) (pun y)) 
    (and (pnp n) (rlf y) (pun y))
    (and (pnp n) (rlf n) (pun y))
  )
  =>
  (printout t "Check the printer-computer cable !" crlf)
)


(defrule software 
  (or 
    (and (pnp y) (rlf n) (pun y))
    (and (pnp n) (rlf y) (pun n))
  )
  =>
  (printout t "Ensure printer software is installed !" crlf)
)


(defrule ink 
  (or 
    (and (pnp y) (rlf y) (pun y))
    (and (pnp y) (rlf y) (pun n))
    (and (pnp n) (rlf y) (pun y))
    (and (pnp n) (rlf y) (pun n))
    (and (pnp n) (rlf n) (pun y))
  )
  =>
  (printout t "Check/Replace ink !" crlf)
)


(defrule jam 
  (or 
    (and (pnp y) (rlf y) (pun n))
    (and (pnp y) (rlf n) (pun n))
    (and (pnp n) (rlf y) (pun n))
    (and (pnp n) (rlf n) (pun n))
  )
  =>
  (printout t "Check for paper jam !" crlf)
)
