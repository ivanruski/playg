;; Exercise 1.46. Several of the numerical methods described in this chapter are
;; instances of an extremely general computational strategy known as iterative
;; improvement. Iterative improvement says that, to compute something, we start
;; with an initial guess for the answer, test if the guess is good enough, and
;; otherwise improve the guess and continue the process using the improved guess as
;; the new guess.
;;
;; Write a procedure iterative-improve that takes two procedures as arguments:
;; a method for telling whether a guess is good enough and a method for improving
;; a guess. Iterative-improve should return as its value a procedure that takes
;; a guess as argument and keeps improving the guess until it is good enough.
;;
;; Rewrite the sqrt procedure of section 1.1.7 and the fixed-point procedure of
;; section 1.3.3 in terms of iterative-improve.

(define (average a b) (/ (+ a b) 2))

(define (iterative-improve good-enough? improve)
  (define (improve-iter guess)
    (let ((next-guess (improve guess)))
      ;; good-enough would work with one argument
      ;; however for fixed-point it's more precise if accepts 2 args
      (if (good-enough? guess next-guess)
          next-guess
          (improve-iter next-guess))))
  (lambda (guess)
    (improve-iter guess)))

;; sqrt of 1.1.7
;; guess quotient(x/guess) avg (guess quatient)
(define tolerance 0.000000001)

(define (sqrt-1.1.7 x)
  (define (good-enough? guess next-guess)
    (< (abs (- guess next-guess)) tolerance))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (let ((next-guess (improve guess)))
      (if (good-enough? guess next-guess)
          next-guess
          (sqrt-iter next-guess))))
  (sqrt-iter 1.0))

;; sqrt in terms of iterative-improve
(define (sqrt x)      
  ((iterative-improve
    (lambda (guess next) (< (abs (- guess next)) tolerance))
    (lambda (guess) (average guess (/ x guess))))
   1.0))

;; fixed-point of 1.3.3
(define (fixed-point-1.3.3 f first-guess)
  (define (good-enough? guess next-guess)
    (< (abs (- guess next-guess)) tolerance))
  (define (try guess)
    (let ((next-guess (f guess)))
      (if (good-enough? guess next-guess)
          next-guess
          (try next-guess))))
  (try first-guess))

;; fixed-point in terms of iterative-improve
(define (fixed-point f first-guess)
  ((iterative-improve
    (lambda (guess next-guess) (< (abs (- guess next-guess)) tolerance))
    (lambda (guess) (f guess)))
   first-guess))
