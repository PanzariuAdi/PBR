(deffacts fapte_initiale
 (meniu)
)

(defrule afiseaza_meniu
?a<-(meniu)
=>
(retract ?a)
(printout t "1. Citeste o lista cu valori numerice." crlf)
(printout t "2. Afiseaza lista sortata crescator cu BubbleSort." crlf)
(printout t "3. Adaua un element intr-o lista." crlf)
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
(facts)
)

(defrule next_2

(not(lista $?before ?x ?y $?after &:(< ?y ?x)))
=>
(assert (meniu))
)

;TO DO : afisare lista o singura data

;------------------------------------------------------------------------------------------------