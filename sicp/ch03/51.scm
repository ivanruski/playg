;; Exercise 3.51. In order to take a closer look at delayed evaluation, we will
;; use the following procedure, which simply returns its argument after printing
;; it:

(define (show x)
  (display-line x)
  x)

;; What does the interpreter print in response to evaluating each expression in
;; the following sequence?

(define x (stream-map show (stream-enumerate-interval 0 10)))
;; 0
(stream-ref x 5)
;; 1
;; 2
;; 3
;; 4
;; 5

(stream-ref x 7)
;; I said:
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 7
;;
;; However the correct output is
;; 6
;; 7
;;
;; Because as explained in the "Implementing delay and force" section:
;;
;; ...
;; The solution is to build delayed objects so that the first time they
;; are forced, they store the value that is computed. Subsequent forcings will
;; simply return the stored value without repeating the computation
;; ...
;;
;; Evaluating (stream-ref x 7), does not print anything

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
