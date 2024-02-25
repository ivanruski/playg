;; Exercise 2.83. Suppose you are designing a generic arithmetic system for
;; dealing with the tower of types shown in figure 2.25: integer, rational,
;; real, complex. For each type (except complex), design a procedure that raises
;; objects of that type one level in the tower. Show how to install a generic
;; raise operation that will work for each type (except complex).

;; Everything in numbers.scm prefixed with ex.83 is part of this exercise.
;;
;; We have a raise procedure defined in every package and a generic raise proc
;; which calls apply-generic.

(define (raise arg)
  (apply-generic 'raise arg))

;; With this approach if we want to coerce scheme-number to complex number we
;; can't do that directly. We would have to do successive coercions.

;; attach-tag ignores the type when the type is scheme-number
(make-real (make-scheme-number 5))

(make-real (make-rational 5 5))

(raise (make-scheme-number 5))
(raise (make-rational 5 5))
(raise (make-real (make-rational 5 5)))
(raise (make-complex-from-real-imag 5 5))

(raise (make-scheme-number 5))
(raise (raise (make-scheme-number 5)))
(raise (raise (raise (make-scheme-number 5))))
(raise (raise (raise (raise (make-scheme-number 5)))))
