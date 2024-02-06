;; Exercise 2.79. Define a generic equality predicate equ? that tests the
;; equality of two numbers, and install it in the generic arithmetic
;; package. This operation should work for ordinary numbers, rational numbers,
;; and complex numbers.

;; Everything with a ";; ex.79" comment in the number.scm was added as part of
;; this exercise
(load "numbers.scm")

;; scheme numbers
(equ? (make-scheme-number 5) (make-scheme-number 5))
(equ? (make-scheme-number 5) (make-scheme-number 4))
(equ? (make-scheme-number 3) (make-scheme-number 4))

;; rational numbers
(equ? (make-rational 5 5) (make-rational 5 5))
(equ? (make-rational 5 5) (make-rational 5 3))
(equ? (make-rational 3 5) (make-rational 5 3))

;; complex numbers
(equ? (make-complex-from-real-imag 5 3) (make-complex-from-real-imag 5 3))
(equ? (make-complex-from-real-imag 3 3) (make-complex-from-real-imag 5 3))

(equ? (make-complex-from-mag-ang 5 3) (make-complex-from-mag-ang 5 3))
(equ? (make-complex-from-mag-ang 3 3) (make-complex-from-mag-ang 5 3))

(equ? (make-complex-from-mag-ang 5 3) (make-complex-from-real-imag 5 3))
