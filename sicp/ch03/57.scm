;; Exercise 3.57. How many additions are performed when we compute the nth
;; Fibonacci number using the definition of fibs based on the add-streams
;; procedure? Show that the number of additions would be exponentially greater
;; if we had implemented (delay <exp>) simply as (lambda () <exp>), without
;; using the optimization provided by the memo-proc procedure described in
;; section 3.5.1.

(define fibs
  (cons-stream 0
               (cons-stream 1
                            (add-streams (stream-cdr fibs)
                                         fibs))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

;;;; How many additions are performed when we compute the nth Fibonacci number?
;;
;; The additions must be n - 2(if we count the 0 as the 1st element, not as the
;; 0-ed), because the first 2 elements are hardcoded and for the 3rd we need 1
;; addition, for the 4th one more and so on.
;;
;; If we start from 0, the 0-ed and the 1st are hardcoded and we need 1 addition
;; for the 2nd, one more for the 3rd and so on. In this case the additions will
;; be n - 1.


;;;; Show that the number of additions would be exponentially greater if we had
;;;; implemented (delay <exp>) simply as (lambda () <exp>), without using the
;;;; optimization provided by the memo-proc procedure described in section 3.5.1.
;;
;; Every cdr part of a stream pair will be a function and this is how I imagine
;; the whole thing:
;;
;; FN0 +---+---+
;;     | 0 | ----->  FN1
;;     +---+---+
;;
;; FN1 +---+---+
;;     | 1 | ----->  FN2
;;     +---+---+
;;
;;     Where the car is computed by (map + fibs FN1)
;; FN2 +---+---+
;;     | 1 | ----->  FN3
;;     +---+---+
;;
;;     Where the car is computed by (map + FN1 FN2)
;; FN3 +---+---+
;;     | 2 | ----->  FN4
;;     +---+---+
;;
;;     Where the car is computed by (map + FN2 FN3)
;; FN4 +---+---+
;;     | 3 | ----->  FN5
;;     +---+---+
;;
;; If you are at the 5th fib (FN4), in order to find it we'd have to first
;; evaluate FN2 & FN3, to get the value of FN3 we'd have to evaluate FN1 & FN2
;; and so on. This is basically the naive fib(n) = fib(n-1) + fib(n-2), definition
;; which has an exponential growth(as we found out in chapter 1)
