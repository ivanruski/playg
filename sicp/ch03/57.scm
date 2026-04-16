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
;; One addition should only be performed, we add the last 2 elements of the fibs
;; stream, and delay the n+1th. We don't reitarate from start every time we
;; compute the nth fibonacci.
;;
;; In total to get to the nth fibonacci, we'd need n - 2 additions.


;;;; Show that the number of additions would be exponentially greater if we had
;;;; implemented (delay <exp>) simply as (lambda () <exp>), without using the
;;;; optimization provided by the memo-proc procedure described in section 3.5.1.
;;
;; If we don't have the optimization in place, I don't even know how this would work

;; 0 -> 1 -> (apply + (map stream-car (stream-cdr fibs) fibs))
;;           (stream-map + (stream-cdr (stream-cdr fibs)) (stream-cdr fibs)) ->
;;
;; -> (apply + (map stream-car (stream-cdr (stream-cdr fibs)) (stream-cdr fibs)))
;;    ....
;;
;; I imagine something like this, which would mean, that we always have a
;; reference to the begginging of the fibs stream and we always recomupte
;; everything from the start - this resembles the naive implementation of
;; Fibonnaci which is exponential.
