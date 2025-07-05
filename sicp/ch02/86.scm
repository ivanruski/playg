;; Exercise 2.86. Suppose we want to handle complex numbers whose real parts,
;; imaginary parts, magnitudes, and angles can be either ordinary numbers,
;; rational numbers, or other numbers we might wish to add to the
;; system. Describe and implement the changes to the system needed to
;; accommodate this. You will have to define operations such as sine and cosine
;; that are generic over ordinary numbers and rational numbers.

;; Part 1:
;;
;; As stated in the description we'll have to use the mathematical operations
;; that we've defined(add, sub, div, etc) throughout the whole complex numbers
;; package(s). In this way when we say for example (magnitude <complex-rect>)
;; instead of using the built in 'sqrt', '+', 'square', we'll use the ones which can
;; make the difference between scheme-numbers and rational numbers.
;;
;; Currently some of the following operations that are failing with the code
;; from ex. 2.85 are:
(angle (make-complex-from-real-imag (make-rational 3 1) 3))

(magnitude (make-complex-from-real-imag (make-rational 3 1) 3))

(add (make-complex-from-real-imag (make-rational 3 2) 3)
     (make-complex-from-real-imag (make-rational 3 2) 3))

(sub (make-complex-from-real-imag (make-rational 3 2) 3)
     (make-complex-from-real-imag (make-rational 3 2) 3))

