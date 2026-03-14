;; Exercise 3.50. Complete the following definition, which generalizes
;; stream-map to allow procedures that take multiple arguments, analogous to map
;; in section 2.2.3, footnote 12.

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define s1 (stream-enumerate-interval 1 3))
(define s2 (stream-enumerate-interval 4 6))

(display-stream s1)
(display-stream s2)
(display-stream (stream-map * s1 s2))
