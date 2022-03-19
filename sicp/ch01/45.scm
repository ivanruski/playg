;; Exercise 1.45. We saw in section 1.3.3 that attempting to compute square
;; roots by naively finding a fixed point of y -> x/y does not converge, and that
;; this can be fixed by average damping. The same method works for finding cube
;; roots as fixed points of the average-damped y -> x/y^2.
;;
;; Unfortunately, the process does not work for fourth roots -- a single average
;; damp is not enough to make a fixed-point search for y -> x/y^3 converge.
;;
;; On the other hand, if we average damp twice (i.e., use the average damp of the
;; average damp of y -> x/y^3) the fixed-point search does converge. Do some
;; experiments to determine how many average damps are required to compute nth
;; roots as a fixed-point search based upon repeated average damping of
;; y -> x/y^n-1.
;;
;; Use this to implement a simple procedure for computing nth roots using
;; fixed-point, average-damp, and the repeated procedure of exercise 1.43.
;; Assume that any arithmetic operations you need are available as primitives.

;; After a bit of experimenting I've noticed that the number of average-damps
;; we have to do is related to between which two powers of 2 the n (nth-root) is.
;; For example(n is the nth root):
;; n = 1, 2, 3 - (repeated average-damp 1)
;; n = 4 - 7   - (repeated average-damp 2)
;; n = 8 - 15  - (repeated average-damp 3)
;; n = 16 - 31 - (repeated average-damp 4)
;; n = 32 - 63 - (repeated average-damp 5)

(define (average a b) (/ (+ a b) 2))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define tolerance 0.00000001)

(define (fixed-point f first-guess)
  (define (close-enough a b)
    (< (abs (- a b)) tolerance))
  (define (try guess)
    (let ((next-guess (f guess)))
      (if (close-enough guess next-guess)
          guess
          (try next-guess))))
  (try first-guess))

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose (repeated f (- n 1)) f)))

;; Examples to understand how to construct the procedure
(define (sqrt x)
  (fixed-point (lambda (y) ((average-damp (lambda (z) (/ x z))) y))
               1.0))

(define (cuberoot x)
  (fixed-point (lambda (y) ((average-damp (lambda (z) (/ x (expt z 2)))) y))
               1.0))

(define (4throot x)
  (fixed-point (lambda (y) ((average-damp
                             (average-damp (lambda (z) (/ x (expt z 3))))) y))
               1.0))

;; The solution to the exercise
(define (nth-root n num)
  (define (repeat x p)
    (cond ((< x 4) 1)
          ((and (>= x (expt 2 (- p 1)))
                (< x (expt 2 p)))
           (- p 1))
          (else
           (repeat x (+ p 1)))))
  (fixed-point
   ((repeated average-damp (repeat n 1))
    (lambda (y) (/ num (expt y (- n 1)))))
   1.0))
