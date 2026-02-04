;; Exercise 3.34. Louis Reasoner wants to build a squarer, a constraint device
;; with two terminals such that the value of connector b on the second terminal
;; will always be the square of the value a on the first terminal. He proposes
;; the following simple device made from a multiplier:

(define (squarer a b)
  (multiplier a a b))

;; There is a serious flaw in this idea. Explain.

;; If he sets, a first, the squarer will work as expected, because the
;; multiplier will chech has-value for a & b(which is a) and it will compute
;; c(which is b).
;;
;; However if he sets, b, the multiplier won't compute anything because a & b
;; won't have value.
;;
;; (in order for the examples below to work, import 33.scm)

(define a (make-connector))
(define b (make-connector))

(squarer a b)

(set-value! a 4 'user)
(get-value b)
;; 16

(define a (make-connector))
(define b (make-connector))

(squarer a b)

(set-value! b 16 'user)
(get-value a)
;; #f
