;; Exercise 3.8. When we defined the evaluation model in section 1.1.3, we said
;; that the first step in evaluating an expression is to evaluate its
;; subexpressions. But we never specified the order in which the subexpressions
;; should be evaluated (e.g., left to right or right to left). When we introduce
;; assignment, the order in which the arguments to a procedure are evaluated can
;; make a difference to the result. Define a simple procedure f such that
;; evaluating (+ (f 0) (f 1)) will return 0 if the arguments to + are evaluated
;; from left to right but will return 1 if the arguments are evaluated from
;; right to left.

(define bit 1)

(define (f num)
  (set! bit (bitwise-and num bit))
  bit)

(+ (f 0) (f 1))
;Value: 1
;; Based on the result I can say that the expression is evaluated right to left.


;; Simulating left to right
(define bit 1)
(define l (f 0))
(define r (f 0))
(+ l r)
