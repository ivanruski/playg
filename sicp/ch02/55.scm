;; Exercise 2.55. Eva Lu Ator types to the interpreter the expression

(car ''abracadabra)

;; To her surprise, the interpreter prints back quote. Explain.
;;
;; Her expression is equivalent to (car (quote (quote abracadabra))). She has a
;; list with two elements (quote abracadabra), the first is literrally quote.
