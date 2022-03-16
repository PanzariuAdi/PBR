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
  (not(stop))
  =>
  (printout t "Introduceti elementul : " crlf)
  (assert (elem (read)))
)

(defrule addElem 
?b<-(elem $? ?z)
?a<-(lista $?values)
?c<-(optiune 3)
=> 
(assert (stop))
(retract ?a)
(retract ?b)
(assert(lista $?values ?z))
(printout t "Element adaugat !" crlf)
)

(defrule afiseazaElementAdaugat
?c<-(optiune 3)
(stop)
 (lista $? ?x $?)
 =>
 (printout t ?x crlf)
)

(defrule iesire3
?b<-(optiune 3)
(stop)
 =>
(retract ?b)
(assert (meniu))
)



;-------------------------------------------------------------------------------------------------

(deffacts fapte
    (rev)
)

(defrule createCopiesPalindrome 
?a<-(lista $?val)
?b<-(optiune 4)
=> 
(assert(copy01 $?val))
(assert(copy02 $?val))
)



(defrule reverseList 
?a<-(copy01 $?before ?u)
?b<-(rev $? $?after)
?c<-(optiune 4)
=> 
(retract ?a)
(retract ?b)
(assert(copy01 $?before))
(assert(rev $?after ?u)) 
) 

(defrule checkPalindrome
 ?a<-(copy02 ?val1 $?afterc)
 ?b<-(rev ?val2 $?after)
 ?c<-(optiune 4)
 (test(= ?val1 ?val2))
 =>
 (retract ?a)
 (retract ?b)
 (assert (copy02 $?afterc))
 (assert (rev $?after))
)

(defrule isPalindrome
 ?a<-(optiune 4)
 (copy02)
 (rev)
 =>
 (assert (palindrome))
 (printout t "Palindrome" crlf)
)

(defrule notPalindrome
 ?a<-(optiune 4)
 (not(palindrome))
 =>
 (printout t "Not Palindrome" crlf)
)

(defrule iesire4
?b<-(optiune 4)
 =>
(retract ?b)
(assert (meniu))
)
;-------------------------------------------------------------------------------------------------

(defrule createCopies 
?a<-(lista $?values)
?b<-(optiune 5)
=> 
(assert(list $?values))
)


(defrule sortare_lista1
?b<-(list $?before ?x ?y $?after &:(< ?y ?x))
?a<-(optiune 5)
=>
(retract ?b)
(assert (list $?before ?y ?x $?after))
)

(defrule afisareMinim
 ?a<-(optiune 5)
 (list ?x $?) 
 =>
 (printout t "Cel mai mic numar este : " ?x crlf)
)

(defrule afisareMaxim
 ?a<-(optiune 5)
 (list $? ?x) 
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
