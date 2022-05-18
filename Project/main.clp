;######################## INPUT_MENU ###########################

(defmodule MAIN
    (export deftemplate ?ALL))


(deftemplate MAIN::user
    (slot id)
    (multislot events)  
)

(deftemplate MAIN::var
    (slot name)
    (slot level (default 0))
    (multislot possible-values)
    (slot value)
)

(deftemplate MAIN::restrictions
    (slot user_id)
    (multislot days)
    (multislot hours)
    (multislot rooms)
)

(deftemplate MAIN::pb
    (slot state (default start))
    (slot level (default 0))
    (slot current-hypothesis (default no))
)


(deftemplate MAIN::solution
    (slot number (default 1))
    (multislot var-val)
)

(defglobal
    ?*auto_increment_id* = 0
)

(deffacts MAIN::initial_facts
    (menu)
    
    ; (days_all Mon Tue Wed Thu Fri)
    ; (hours_all 8:00 9:00 10:00 11:00 12:00 13:00)
    ; (rooms_all R1 R2 R3 R4 R5)
)

(defrule MAIN::print_menu
    ?a<-(menu)
    =>
    (retract ?a)
    (printout t crlf crlf "1. Add new user" crlf)
    (printout t "2. Print all users" crlf)
    (printout t "3. Get restriction codes for events" crlf)
    (printout t "4. Get timetable" crlf)

    (printout t crlf "Option: ")
    (assert (optiune (read)))
    (printout t crlf)
)

(defrule MAIN::opt_1
    ?a <- (optiune 1)
    =>
    (retract ?a)
    (bind ?*auto_increment_id* (+ ?*auto_increment_id* 1))
    (printout t "User " ?*auto_increment_id* " events: ")
    (assert (user (id ?*auto_increment_id*) (events  (explode$ (readline))) ))
    (printout t "User " ?*auto_increment_id* " restrictions: " crlf " - days: ")
    (bind $?days (explode$ (readline)))
    (printout t " - hours: ")
    (bind $?hours (explode$ (readline)))
    (printout t " - rooms: ")
    (bind $?rooms (explode$ (readline)))
    (assert (restrictions (user_id ?*auto_increment_id*) (days $?days) (hours $?hours) (rooms $?rooms)))
    (assert (menu))
)

(defrule MAIN::opt_2 (declare (salience 10))
    (optiune 2)
    (user (id ?id) (events $?events))
    (restrictions (user_id ?id) (days $?days) (hours $?hours) (rooms $?rooms))
    =>
    (printout t "User " ?id ": " crlf " - events: " $?events crlf " - days: " $?days crlf " - hours " $?hours crlf " - rooms " $?rooms crlf crlf)
)

(defrule MAIN::opt_2_cleanup
    ?opt <- (optiune 2)
    =>
    (retract ?opt)
    (assert (menu))
)

(defrule MAIN::opt_3_pre (declare (salience 10))
    (optiune 3)
    (user (id ?id) (events $?events))
=>
    (printout t crlf "User ID " ?id ": ")
)


(defrule MAIN::opt_3 (declare (salience 10))
    (optiune 3)
    ?user <- (user (id ?id) (events $?events))
    (restrictions (user_id ?id) (days $?before_day ?day $?after_day) (hours $?before_hours ?hour $?after_hours) (rooms $?before_room ?room $?after_room))

    =>
    (bind ?day_index (member$ ?day (create$ Mon Tue Wed Thu Fri)))
    (bind ?hour_index (member$ ?hour (create$ 8:00 9:00 10:00 11:00 12:00 13:00)))
    (bind ?room_index (member$ ?room (create$ R1 R2 R3 R4 R5)))

    (bind ?code (+ (* ?day_index 100) (+ (* ?hour_index 10) ?room_index))) 
    (printout t ?code " ")
)


(defrule MAIN::opt_3_cleanup
    ?opt <- (optiune 3)
    =>
    (retract ?opt)
    (assert (menu))
)


(defrule MAIN::opt_4 (declare (salience 10))
    (optiune 4)
    (user (id ?id) (events $?event_before ?event $?event_after))
=>
    (printout t "User " ?id " - event " ?event " codes: ")
    ; (assert (event_codes (explode$ (readline))))
    ; (var (name E1) (possible-values (create$ 123, 245, 141, 345)))
    (assert (var (name ?event) (possible-values (explode$ (readline)))))
)

(defrule MAIN::opt_4_post 
    ?opt <- (optiune 4)
=>
    (retract ?opt)
    (assert (pb))
    (assert (solution))
    (assert (level_search 0))
)


;######################## PB ###########################




; (deffacts MAIN::initial-pb
;     (pb)
;     (solution)
;     (level_search 0)
; )
    

(defrule MAIN::all-solutions?
    ?pb<- (pb (state start))
=>
    (build
            "(defrule MAIN::pb-solved
                ?f <- (pb (state solved))
                ?sol <- (solution (number ?nb))
            =>
                (printout t crlf \"Solution found.\" crlf)
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
    (forall (var (name ?x)) (var (name ?x)(value ?v&~nil)))
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
; converts a string to a list of chars

    (bind ?rv (create$))
    (loop-for-count 
        (?i (str-length ?string))
        (bind ?rv (create$ ?rv (sub-string ?i ?i ?string)))
    )
    ?rv
)


(defrule MAIN::print-solution
; the default printing method

    (pb (state blocked) (level 0))
    (solution (number ?n) (var-val $?list&:(> (length$ $?list) 0)))
=>
    (printout t "Solution : " crlf)
    (bind ?length (length$ $?list))
    (bind ?i 1)
    (bind ?days (explode$ "Mon Tue Wed Thu Fri"))
    (bind ?hours (explode$ "8:00 9:00 10:00 11:00 12:00 13:00"))
    (bind ?rooms (explode$ "R1 R2 R3 R4 R5"))
    (while (< ?i ?length) 
        (bind ?var (nth$ ?i $?list))
        (bind ?val (str-cat (nth$ (+ ?i 1) $?list)))

        (bind ?arr (char-explode$ ?val))

        (bind ?day_index (string-to-field (nth$ 1 $?arr)))
        (bind ?hour_index (string-to-field  (nth$ 2 $?arr)))
        (bind ?room_index (string-to-field  (nth$ 3 $?arr)))

        (bind ?day (nth$ ?day_index $?days))
        (bind ?hour (nth$ ?hour_index $?hours))
        (bind ?room (nth$ ?room_index $?rooms))

        (printout t ?var " : " ?day " " ?hour " " ?room crlf) 

        (bind ?i (+ ?i 2))
    )
)


;################# MODULE SEARCH ####################################

(defmodule SEARCH (import MAIN deftemplate ?ALL))

(defrule SEARCH::generate-new-depth
    (level_search ?n)
    (not (level_search ?n1&:(> ?n1 ?n)))
    ?f <- (pb (level ?n) (state new-depth))
=>
    (duplicate ?f (level (+ ?n 1)) (state choice-var)(current-hypothesis nil))
    (assert (level_search (+ ?n 1)))
)


(defrule SEARCH::choice-var-val
; make an hypothesis at a new level of the search. Choose the most constrained
; variable (i.e. the ones which has the less possible values) and choose a value among
; its possible values (the first available in the list)
 
    (logical (level_search ?n))
    ?g <- (pb (level ?n)(state choice-var)(current-hypothesis nil))
    ?f <- (var (name ?x) (level ?x1) (value nil) (possible-values $?nb1))
    (not (var (name ?x) (level ?x2&:(> ?x2 ?x1))))
    (forall (and (var (name ?y&~?x) (value nil)(level ?m))
                 (not (var (name ?y) (level ?m1&:(> ?m1 ?m)))))
            (var (name ?y)(level ?m)(possible-values $?nb2&:(>=(length$ ?nb2) (length$ $?nb1)))))
=>
    (modify ?g (state in-progress) (current-hypothesis ?x))
    (duplicate ?f (level ?n) (value (nth$ 1 $?nb1))(possible-values (rest$ $?nb1)))
    (focus PROPAG)
)


;.Examine the current state : forced instanciation or impasse or backtrack

(defrule SEARCH::instanciation
; if a not yet instanciated variable has only one possible value then provide it with this value
; then set the focus to PROPAG for evaluating the consequences of this forced instanciation
; then return to SEARCH
    (logical (level_search ?n))
    ?f <- (var (name ?x) (level ?n) (value nil) (possible-values $?list&:(= (length$ $?list) 1)))
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
    ?var <- (var (name ?x) (level ?n) (value ?v&~nil) (possible-values $?list&:(<> (length$ $?list) 0)))
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
    ?var <- (var (name ?x) (level ?n) (possible-values $?list&:(= (length$ $?list) 0)))
=>
    (retract ?s)
    (retract ?pb)
    (retract ?var)
    (modify ?pbbis (state blocked))
)



(defmodule PROPAG
 (import MAIN deftemplate ?ALL))

;########################## Possible values for the variables ##########################
; The possible values (domain) for the variables are codes with the following meaning:
; code: xyz, where
; x - the index of the day from possible values of the days (days[1] = Mon, days[2] = Tue etc.)
; y - the index of the hour from possible values of the hours (hours[1] = 08:00, hours[2] = 09:00, hours[3] = 10:00, hours[4] = 11:00, hours[5] = 12:00, hours[6] = 13:00)
; z - the index of the room from possible values of the rooms (rooms[1] = R1, rooms[2] = R2 etc.)
; for examle, if we want an event to take place on tuesday, at 10:00, in room 1, the code for that event would be: 231;


; alegem opt rulare 
;   daca -> no solution -> rulam din nou, dar fara restrictiile unui user
;       daca -> solutie -> afisam userul care afecta solutia anterioara (userul a carui restricii le-am eliminat mai sus)
;   daca -> solutie -> afisam




; (deffacts PROPAG::events
;  (var (name E1) (possible-values (create$ 123, 245, 141, 345)))
;  (var (name E2) (possible-values (create$ 123, 245, 141, 345)))
;  (var (name E3) (possible-values (create$ 123, 245, 141, 345)))
;  (var (name E4) (possible-values (create$ 123, 245, 141, 345)))
; )

;########################## Constraints ##########################

(defrule PROPAG::propagation-1
; Here we implement a constraint such that we get a forward-checking algorithm
; Two separate events are not possible if they take place in the same day, at same hour, in the same room; 
; therefore, two events are in conflict if they have identical codes;
; We do forward-checking by eliminating the value (code) of the current hypothesis (current chosen variable) 
; from the domains of all the other unassigned variables
    (declare (salience 2))
    (logical (level_search ?n))
    (not (level_search ?n1&:(> ?n1 ?n)))
    (var (name ?x) (value ?v&~nil)(level ?n))
    ?f <- (var (name ?y) (value nil) (level ?m) (possible-values $?list&:(member$ ?v ?list)))
    (not (var (name ?y) (level ?m1&:(> ?m1 ?m))))
=>
    (bind ?var (member$ ?v ?list))
    (if (= ?m ?n) then 
        (modify ?f (possible-values (delete$ ?list ?var ?var )))
    else 
        (duplicate ?f (level ?n) (possible-values (delete$ ?list ?var ?var))))
)
