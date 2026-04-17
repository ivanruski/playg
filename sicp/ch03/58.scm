;; Exercise 3.58. Give an interpretation of the stream computed by the following
;; procedure:
;;
;; (define (expand num den radix)
;;   (cons-stream
;;    (quotient (* num radix) den)
;;    (expand (remainder (* num radix) den) den radix)))
;;
;; (Quotient is a primitive that returns the integer quotient of two integers.)
;; What are the successive elements produced by (expand 1 7 10) ? What is
;; produced by (expand 3 8 10) ?

(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

(define s1 (expand 1 7 10))
;; 1 | (expand 3 7 10)
;; 4 | (expand 2 7 10)
;; 2 | (expand 6 7 10)
;; 8 | (expand 4 7 10)
;; 5 | (expand 5 7 10)
;; 7 | (expand 1 7 10)
;; repeat 

(define s2 (expand 3 8 10))
;; 3 | (expand 6 8 10)
;; 7 | (expand 4 8 10)
;; 5 | (expand 0 8 10)
;; 0 | (expand 0 8 10)
;; 0 | (expand 0 8 10)
;; ..... 

;; Interpreting the output of the streams was easier that describing what expand
;; is actually doing 😄.
;;
;; The stream created by expand is a stream where the car is the quotient of
;; some number X divided by another number Y and the cdr is the remainder of the
;; X over Y.
;;
;; Once expand reaches a remainder 0, the resulted stream becomes a stream of
;; zeroes.
;;
;; After looking up on the internet I found out that expand is actually doing
;; long division (I didn't see that!)
;;
;; (expand 1 7 10) produces a stream of numbers for 10 / 7
;; (expand 3 8 10) produces a stream of numbers for 30 / 8
