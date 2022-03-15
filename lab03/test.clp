(deffacts fapte
    (lista 7 8 9 2 8 7 8 3)
)


(defrule elemUniceImpare
  ?a<-(lista $?before ?x $?middle ?y $?middle2 ?z $?after &:(= ?x ?y ?z))
  =>
  (retract ?a)
  (assert (lista $?before $?middle $?middle2 $?after))
)


(defrule elemUnicePare
  ?a<-(lista $?before ?x $?middle ?y $?after &:(= ?x ?y))
  =>
  (retract ?a)
  (assert (lista $?before $?middle $?after))
)

(defrule afiseazaUnice
 (lista $? ?x $?)
 =>
 (printout t ?x crlf)
)
