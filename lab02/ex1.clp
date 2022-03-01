(defrule outlook_questionnaire
  (not (Outlook ?))
  =>
  (printout t "How is the outlook ? (Sunny / Overcast / Rain)" crlf)
  (assert (Outlook (read)))
)

(defrule sunny_questionnaire
  (Outlook Sunny) 
  (not (Humidity ?))
  =>
  (printout t "How is the humidity ? (High / Normal)" crlf)
  (assert (Humidity (read)))
)

(defrule rain_questionnaire
  (Outlook Rain)
  (not (Wind ?))
  =>
  (printout t "How is the wind ? (Strong / Weak)" crlf)
  (assert (Wind (read)))
)

(defrule stay_home 
  (or (and (Outlook Sunny) (Humidity High)) 
      (and (Outlook Rain) (Wind Strong))
  )
  =>
  (printout t "Stay home ! Weather is not good !" crlf)
)

(defrule go_outside
  (or (Outlook Overcast) 
      (and (Outlook Sunny) (Humidity Normal)) 
      (and (Outlook Rain) (Wind Weak))
  )
  =>
  (printout t "Go outside ! Weather is very good !" crlf)
)

