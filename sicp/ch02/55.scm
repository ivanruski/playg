;; Exercise 2.55. Eva Lu Ator types to the interpreter the expression
;;
;; (car ''abracadabra)
;;
;; To her surprise, the interpreter prints back quote. Explain.
;;
;; (car ''abracadabra) is the same as (car (list 'quote 'abracadabra))

(equal? ''abracadabra (list 'quote 'abracadabra))
(car (list 'quote 'abracadabra))
(car ''abracadabra)
