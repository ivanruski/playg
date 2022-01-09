;; Exercise 1.7.  The good-enough? test used in computing square roots will not be
;; very effective for finding the square roots of very small numbers. Also, in real
;; computers, arithmetic operations are almost always performed with limited
;; precision. This makes our test inadequate for very large numbers. Explain these
;; statements, with examples showing how the test fails for small and large
;; numbers. An alternative strategy for implementing good-enough? is to watch how
;; guess changes from one iteration to the next and to stop when the change is a
;; very small fraction of the guess. Design a square-root procedure that uses this
;; kind of end test. Does this work better for small and large numbers?

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-iter guess x)
  (if (good-enough? guess (improve guess x))
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

;; One example where sqrt fails for large numbers is 10000000000033 because at some
;; point guess stops improving and it's not good enough which leads to endless
;; loop.
;;
;; Another example where sqrt fails for small numbers is 0.0004 because the
;; tolerance is not small enough and it yields good-enough value too early.
;; It's like having tolerance of 100 and trying to find the (sqrt 1024)


(define (good-enough? old-guess new-guess)
  (< (abs (- old-guess new-guess)) 0.0000000000001))
