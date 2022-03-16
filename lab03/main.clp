(deffacts fapte_initiale
 (meniu)
)

(defrule afiseaza_meniu
?a<-(meniu)
(not (optiune 7))
=>
(retract ?a)
(printout t "1. Citeste o lista cu valori numerice." crlf)
(printout t "2. Afiseaza lista sortata crescator cu BubbleSort." crlf)
(printout t "3. Adauga un element intr-o lista." crlf)
(printout t "4. Verifica daca lista este palindrom." crlf)
(printout t "5. Afiseaza cel mai mic si cel mai mare element dintr-o lista." crlf)
(printout t "6. Afiseaza elementele care apar o singura data intr-o lista." crlf)
(printout t "7. Iesire." crlf)
(printout t "Dati optiunea:")
(assert (optiune (read)))
)

;--------------------------------------------------------------------------------------------

(defrule citire_lista
?a<-(optiune 1)
=>
(retract ?a)
(printout t "Dati lista:")
(assert (lista (explode$ (readline))))
(assert (meniu))
)

;----------------------------------------------------------------------------------------------
(defrule sortare_lista
?a<-(optiune 2)
?b<-(lista $?before ?x ?y $?after &:(< ?y ?x))
=>
(retract ?b)
(assert (lista $?before ?y ?x $?after))
)


(defrule afiseazaSortate
 (not(lista $?before ?x ?y $?after &:(< ?y ?x)))
 (lista $? ?z $?)
 ?b<-(optiune 2)
 =>
 (printout t ?z crlf)
)

(defrule iesire2
?b<-(optiune 2)
 =>
(retract ?b)
(assert (meniu))
)

;------------------------------------------------------------------------------------------------


(defrule citire 
  ?a<-(optiune 3)
  (not (elem ?))
  =>
  (printout t "Introduceti elementul : " crlf)
  (assert (elem (read)))
)


(defrule addElem 
?b<-(elem $? ?z)
?a<-(lista $?before ?x&:(!= ?x ?z))
=> 
(retract ?a)
(assert(lista $?before ?x ?z))
(printout t "Element adaugat !" crlf)
)

(defrule afiseazaElementAdaugat
 ?b<-(optiune 3)
 (lista $? ?x $?)
 =>
 (printout t ?x crlf)
)

(defrule iesire3
?b<-(optiune 3)
 =>
(retract ?b)
(assert (meniu))
)



;-------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------

(defrule sortare_lista1
?b<-(lista $?before ?x ?y $?after &:(< ?y ?x))
?a<-(optiune 5)
=>
(retract ?b)
(assert (lista $?before ?y ?x $?after))
)

(defrule afisareMinim
 ?a<-(optiune 5)
 (lista ?x $?) 
 =>
 (printout t "Cel mai mic numar este : " ?x crlf)
)

(defrule afisareMaxim
 ?a<-(optiune 5)
 (lista $? ?x) 
 =>
 (printout t "Cel mai mare numar este : " ?x crlf)
)

(defrule iesire5
?b<-(optiune 5)
 =>
(retract ?b)
(assert (meniu))
)


;-------------------------------------------------------------------------------------------------


(defrule elemUniceImpare
  ?a<-(lista $?before ?x $?middle ?y $?middle2 ?z $?after &:(= ?x ?y ?z))
  ?b<-(optiune 6)
  =>
  (retract ?a)
  (assert (lista $?before $?middle $?middle2 $?after))
)


(defrule elemUnicePare
  ?a<-(lista $?before ?x $?middle ?y $?after &:(= ?x ?y))
  ?b<-(optiune 6)
  =>
  (retract ?a)
  (assert (lista $?before $?middle $?after))
)

(defrule afiseazaUnice
 (lista $? ?x $?)
  ?b<-(optiune 6)
 =>
 (printout t ?x crlf)
)

(defrule iesire6
 ?b<-(optiune 6)
 => 
 (assert (meniu))
 (retract ?b)
)



;-------------------------------------------------------------------------------------------------
(defrule iesireMeniu
?a<-(meniu)
?b<-(optiune 7)
=>
(retract ?a)
)
