(deffacts fapte
    (list 1 2 3 2 5)
    (reversed)
    (copy1)
    (copy2)
)

(defrule createCopies 
?a<-(list $?before ?u)
?b<-(copy1 $? $?after)
?c<-(copy2 $? $?after)
=> 
(retract ?a)
(retract ?b)
(retract ?c)
(assert(list $?before))
(assert(copy1 ?u $?after))
(assert(copy2 ?u $?after))
)


(defrule reverseList 
?a<-(copy1 $?before ?u)
?b<-(reversed $? $?after)
=> 
(retract ?a)
(retract ?b)
(assert(copy1 $?before))
(assert(reversed $?after ?u)) 
) 

(defrule checkPalindrome
 ?a<-(copy2 $?val1)
 ?b<-(reversed $?val2)
 =>
 (printout t $?val1)
 (printout t $?val2 crlf)
 (printout t (eq $?val1 $?val2) crlf)
)

