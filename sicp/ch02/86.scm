;; Exercise 2.86. Suppose we want to handle complex numbers whose real parts,
;; imaginary parts, magnitudes, and angles can be either ordinary numbers,
;; rational numbers, or other numbers we might wish to add to the
;; system. Describe and implement the changes to the system needed to
;; accommodate this. You will have to define operations such as sine and cosine
;; that are generic over ordinary numbers and rational numbers.

;; In order to achive this goal we have to modify polar, rectangular and complex
;; packages to use generic operations such add, mul, sine, cosine, etc defined
;; by us instead of the builtin ones

;; The modifications are in numbers.scm(everything prefixed with "ex.86") as
;; well as changes in the complex packages to use the new functions.
;;
;; I will add support for rational numbers within the complex package. Adding
;; support for real number should be analogous. (best to check the commit diff
;; for what is necessary)

;; Implemented:
;; add
;; sub
;; mul
;; div
;; equ?

;; To implement:
;; cos
;; sin
;; square
;; atan
;; sqrt

;;;; examples
;; scheme-number
(define cr (make-complex-from-real-imag 3 4))
(real-part cr)
(imag-part cr)

(magnitude cr)
(sqrt (+ (square (real-part cr))
         (square (imag-part cr))))

(angle cr)
(atan (imag-part cr) (real-part cr))
(equ? cr cr)
(=zero? cr)

(define cp (make-complex-from-mag-ang 3 4))
(real-part cp)
(* (magnitude cp) (cos (angle cp)))

(imag-part cp)
(* (magnitude cp) (sin (angle cp)))

(magnitude cp)
(angle cp)

(equ? cp cp)
(=zero? cp)

;; rational
(define crr (make-complex-from-real-imag (make-rational 3 1) (make-rational 4 1)))
(real-part crr)
(imag-part crr)

(magnitude crr)
(sqrt (+ (square (project (real-part crr)))
         (square (project (imag-part crr)))))

(angle crr)
(atan (project (imag-part crr)) (project (real-part crr)))
(equ? crr crr)
(=zero? crr)

(define cpr (make-complex-from-mag-ang (make-rational 3 1) (make-rational 4 1)))
(real-part cpr)
(* (project (magnitude cpr)) (cos (project (angle cpr))))
;; in my implementation I have a 'rational and a 'scheme-number and I try to
;; raise the scheme-number to the rational, as a result I get a different result
;; its like:
(mul (make-rational 3 1) -.65)
(* 3/1 -.65)

(imag-part cpr) ;; same here
(* (project (magnitude cpr)) (sin (project (angle cpr))))

(magnitude cpr)
(angle cpr)

(equ? cpr cpr)
(=zero? cpr)

;; non-droppable rational
;; rational
(define cr-nondrop (make-complex-from-real-imag (make-rational 5 3) (make-rational 8 5)))
(real-part cr-nondrop)
(imag-part cr-nondrop)

(magnitude cr-nondrop)
(sqrt (+ (square (project (real-part cr-nondrop)))
         (square (project (imag-part cr-nondrop)))))

(angle cr-nondrop)
(atan (project (imag-part cr-nondrop)) (project (real-part cr-nondrop)))

(equ? cr-nondrop cr-nondrop)
(=zero? cr-nondrop)
