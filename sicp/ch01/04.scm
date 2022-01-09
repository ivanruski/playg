;; Exercise 1.4.  Observe that our model of evaluation allows for combinations
;; whose operators are compound expressions. Use this observation to describe the
;; behavior of the following procedure:

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

(a-plus-abs-b 5 5)

;; 5 and 5 are replaced with a and b in the body of a-plus-abs-b then
;; (if (> 5 0) + -) 5 5) is evaluated.
;; The operands (5 and 5) and the oprator (if..)  are evaluated then and
;; the result of the latter is applied to 5 and 5
