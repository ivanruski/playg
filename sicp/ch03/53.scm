;; Exercise 3.53. Without running the program, describe the elements of the
;; stream defined by

(define s (cons-stream 1 (add-streams s s)))

;; s is the 2^n stream, where n starts from 0
;; 1
;; 2
;; 4
;; 8
;; 16

(stream-ref s 0)
(stream-ref s 1)
(stream-ref s 2)
(stream-ref s 3)
(stream-ref s 4)

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

;; This time I got it right! The first element is 1, and when we execute
;; (stream-cdr s), we evaluate (add-streams s s), where stream-map, cars the
;; first element of s, two times (1 + 1), and returns (cons-stream 2 <promise>)
;;
;; The next stream-cdr does the same, but this time the first element is 2 and
;; so on...
