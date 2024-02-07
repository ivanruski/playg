;; Exercise 2.80. Define a generic predicate =zero? that tests if its argument
;; is zero, and install it in the generic arithmetic package. This operation
;; should work for ordinary numbers, rational numbers, and complex numbers.

;; Everything with a ";; ex.80" comment in the number.scm was added as part of
;; this exercise
(load "numbers.scm")

;; scheme numbers
(=zero? (make-scheme-number 0))
(=zero? (make-scheme-number 1))

;; rational numbers
(=zero? (make-rational 0 1))
(=zero? (make-rational 1 1))
(=zero? (make-rational 1 0))

;;;; complex
;; polar
(=zero? (make-complex-from-mag-ang 0 0))
(=zero? (make-complex-from-mag-ang 1 0))
(=zero? (make-complex-from-mag-ang 0 1))

;; rectangular
(=zero? (make-complex-from-real-imag 0 0))
(=zero? (make-complex-from-real-imag 1 0))
(=zero? (make-complex-from-real-imag 0 1))
