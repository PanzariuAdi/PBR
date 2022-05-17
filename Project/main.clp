;######################## MODULE MAIN ###########################


(defmodule MAIN
    (export deftemplate ?ALL))

(deftemplate MAIN::pb
    (slot state (default start))
    (slot level (default 0))
    (slot current-hypothesis (default no))
)

(deftemplate MAIN::var
    (slot name)
    (slot level (default 0))
    (multislot possible-values)
    (slot value)
)

(deftemplate MAIN::solution
    (slot number (default 1))
    (multislot var-val)
)

(deffacts MAIN::initial-pb
    (pb)
    (solution)
    (level_search 0)
)
    

(defrule MAIN::all-solutions?
    ?pb<- (pb (state start))
    =>
    (build
            "(defrule MAIN::pb-solved
                ?f <- (pb (state solved))
                ?sol <- (solution (number ?nb))
                =>
                (printout t \"The problem is solved.\" crlf)
                (duplicate ?sol (number (+ ?nb 1))(var-val))
                (modify ?f (level 0) (state blocked)) )
            ")
 (modify ?pb (state in-progress))
)

(defrule MAIN::analysis
    ?f <- (pb (state in-progress))
    =>
    (modify ?f (state new-depth))
    (focus SEARCH PROPAG SEARCH MAIN)
)

(defrule MAIN::save-solution

; if all the variables have got a value at the deapest level of the search
; then save the solution in a list of bindings (<variable> <value>)
    
        (declare (salience 10))
        (level_search ?n)
        (not (level_search ?n1&:(> ?n1 ?n)))
        (forall (var (name ?x))
            (var (name ?x)(value ?v&~nil)))
        
        (var (name ?x) (value ?val&~nil))
    ?s <- (solution (var-val $?list&:(not (member$ ?x $?list))))
    ?f <- (pb (level ?n))
=>
    (modify ?s (var-val (insert$ $?list 1 (create$ ?x ?val))))
    (modify ?f (state solved))
)

(defrule MAIN::no-more-solution
    (declare (salience 10))
    (level_search 0)
    ?f <- (solution (number ?nb) (var-val))
    (pb (state blocked) (level 0))
=>
    (if (= ?nb 1) then (printout t "I found no solution" crlf)
                   else (printout t "" crlf)
                        (retract ?f)
    )  
)


(deffunction char-explode$ (?string)
   (bind ?rv (create$))
   (loop-for-count (?i (str-length ?string))
      (bind ?rv (create$ ?rv (sub-string ?i ?i ?string))))
   ?rv)

(defrule MAIN::print-solution
; the default printing method

    (pb (state blocked) (level 0))
    (solution (number ?n) (var-val $?list&:(> (length$ $?list) 0)))
=>
    (printout t crlf "Solution : " crlf)
    (bind ?length (length$ $?list))
    (bind ?i 1)
    (while (< ?i ?length) 
        (bind ?var (nth$ ?i $?list))
        (bind ?val (str-cat (nth$ (+ ?i 1) $?list)))

        (bind ?arr (char-explode$ ?val))

        (bind ?day_i (string-to-field (nth$ 1 $?arr)))
        (bind ?hour_i (string-to-field  (nth$ 2 $?arr)))
        (bind ?room_i (string-to-field  (nth$ 3 $?arr)))


        (bind ?days (explode$ "Mon Tue Wed Thu Fri"))
        (bind ?hours (explode$ "8:00 9:00 10:00 11:00 12:00 13:00"))
        (bind ?rooms (explode$ "R1 R2 R3 R4 R5"))

        (bind ?day (nth$ ?day_i $?days))
        (bind ?hour (nth$ ?hour_i $?hours))
        (bind ?room (nth$ ?room_i $?rooms))

        (printout t ?var " : " ?day " " ?hour " " ?room crlf) 
        (bind ?i (+ ?i 2))
    )
)


;################# MODULE SEARCH ####################################

(defmodule SEARCH
    (import MAIN deftemplate ?ALL))

(defrule SEARCH::generate-new-depth
        (level_search ?n)
        (not (level_search ?n1&:(> ?n1 ?n)))
 ?f <- (pb (level ?n) (state new-depth))
=>
 (duplicate ?f (level (+ ?n 1)) (state choice-var)(current-hypothesis
nil))
 (assert (level_search (+ ?n 1)))
)

(defrule SEARCH::choice-var-val
; make an hypothesis at a new level of the search. Choose the most constrained
; variable (i.e. the ones which has the less possible values) and choose a value among
; its possible values (the first available in the list...we should improve this choice !!)
 
        (logical (level_search ?n))
    ?g <- (pb (level ?n)(state choice-var)(current-hypothesis nil))
    ?f <- (var (name ?x) (level ?x1) (value nil) (possible-values $?nb1))
        (not (var (name ?x) (level ?x2&:(> ?x2 ?x1))) )
        (forall (and (var (name ?y&~?x) (value nil)(level ?m))
                (not (var (name ?y) (level ?m1&:(> ?m1 ?m)))))
            (var (name ?y)(level ?m)(possible-values $?nb2&:(>=
    (length$ ?nb2) (length$ $?nb1)))))
=>
    (modify ?g (state in-progress) (current-hypothesis ?x))
    (duplicate ?f (level ?n) (value (nth$ 1 $?nb1))(possible-values (rest$
$?nb1)))
    (focus PROPAG)
)

;.Examine the current state : forced instanciation or impasse or backtrack

(defrule SEARCH::instanciation
; if a not yet instanciated variable has only one possible value then provide it with this value
; then set the focus to PROPAG for evaluating the consequences of this forced instanciation
; then return to SEARCH
        (logical (level_search ?n))
    ?f <- (var (name ?x) (level ?n) (value nil) (possible-values $?list&:(=
(length$ $?list) 1)))
        (pb (state in-progress) (level ?n))
=>
    (modify ?f (value (nth$ 1 $?list))(possible-values))
    (focus PROPAG SEARCH)
)


(defrule SEARCH::impasse
; if there exists a not yet instanciated variable which has no more possible values then you got an impasse
        (declare (salience 10))
        (logical (level_search ?n))
    ?pb <- (pb (level ?n) (state in-progress))
        (exists (var (level ?n)(value nil) (possible-values)))
=>
    (modify ?pb (state blocked))
)


(defrule SEARCH::backtrack-on-value
; if the problem solving process is blocked with the current hypothesis ?x
; or if we are looking for another solution, we have to choose another value for
; the hypothesis.
; We stay at the same level of search but BE CAREFUL !!! we have to delete all the facts
; depending on the current value of the hypothesis ?x
; thanks to the logical dependencies it suffices to retract the fact ?s
; then to restore it (with a new time-tag)
 
    ?s <- (level_search ?n)
    ?pb <- (pb (level ?n) (state blocked|solved) (current-hypothesis ?x))
    ?var <- (var (name ?x) (level ?n) (value ?v&~nil) (possible-values
$?list&:(<> (length$ $?list) 0)))
 =>
    (retract ?s)
    (assert (level_search ?n))
    (modify ?var (value (nth$ 1 $?list))(possible-values (rest$ $?list)))
    (modify ?pb (state in-progress))
    (focus PROPAG)
)

(defrule SEARCH::backtrack-on-variable
; if the problem solving process is blocked and no other value is available for the
; current hypothesis then we have to return to a previous level of the search
; where the problem solving process was not blocked. The next step will be the choice of another
; value for the current hypothesis of this previous level
    ?s <- (level_search ?n)
    ?pb <- (pb (level ?n) (state blocked|solved)(current-hypothesis ?x))
    ?pbbis <- (pb (level ?m&:(= ?m (- ?n 1))) (state ~blocked))
    ?var <- (var (name ?x) (level ?n) (possible-values $?list&:(= (length$
$?list) 0)))
=>
    (retract ?s)
    (retract ?pb)
    (retract ?var)
    (modify ?pbbis (state blocked))
)

;#################### the N-events Problem ##########################
; Place N events on a NxN chessboard in such a way that no one event
; could take another event. We have chosen N = 12. Greater N is feasible
; but the time of computation grows exponentially !
;###################################################################
;#################### Modeling ##########################################
; A variable represents a event in a row. For example, x1 represents
; the event placed on the first row. We have to define a bijection of
; the set of rows {x1, x2,...x12} onto the set of columns {1, 2, ...12}
; In this modeling some constraints are implicit : only one variable
; is called x1 implies that only one event will be placed on the first row
;##########################################################################

(defmodule PROPAG
 (import MAIN deftemplate ?ALL))

;################## possible values for the variables ################

;xyz
;x - the day (1-Mon, 2-Tue, 3-Wed, etc.) 
;y - the hour (1-9, 2-10, 3-11, etc.)
;z - the room (1-R1, 2-R2, 3-R3, etc.)


(deffacts PROPAG::events
 (var (name E1) (possible-values (create$ 123, 245, 141, 345)))
 (var (name E2) (possible-values (create$ 123, 245, 141, 345)))
 (var (name E3) (possible-values (create$ 123, 245, 141, 345)))
 (var (name E4) (possible-values (create$ 123, 245, 141, 345)))
)

;########################## Constraints propagation ##################

(defrule PROPAG::propagation-1
; if the column ?v has been chosen for the event ?x then remove ?v
; from the list of possible values of the other events not yet placed
    (declare (salience 2))
    (logical (level_search ?n))
    (not (level_search ?n1&:(> ?n1 ?n)))
    (var (name ?x) (value ?v&~nil)(level ?n))
    ?f <- (var (name ?y) (value nil) (level ?m)
            (possible-values $?liste&:(member$ ?v ?liste)))
    (not (var (name ?y) (level ?m1&:(> ?m1 ?m))))
=>
    (bind ?var (member$ ?v ?liste))
    (if (= ?m ?n)
    then (modify ?f (possible-values (delete$ ?liste ?var ?var )))
    else (duplicate ?f (level ?n) (possible-values (delete$ ?liste ?var ?var))))
)
