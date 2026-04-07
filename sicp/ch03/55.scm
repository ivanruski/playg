;; Exercise 3.55. Define a procedure partial-sums that takes as argument a
;; stream S and returns the stream whose elements are S0, S0 + S1, S0 + S1 + S2,
;; .... For example, (partial-sums integers) should be the stream 1, 3, 6, 10,
;; 15, ....

;; 1. define integers stream

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

;; 2. define partial-sums stream

(define (partial-sums integers)
  (define (next partial-sum integers)
    (let ((ps (+ partial-sum (stream-car integers))))
      (cons-stream ps
                   (next ps (stream-cdr integers)))))

  (cons-stream (stream-car integers)
               (next (stream-car integers)
                     (stream-cdr integers))))

;; v2 - I didn't like the first solution and after going throught the chapter
;; again I came up with this one, which I like more

(define (partial-sums s)
  (cons-stream (stream-car s)
               (partial-sums (cons-stream (+ (stream-car s) (stream-car (stream-cdr s)))
                                          (stream-cdr (stream-cdr s))))))
