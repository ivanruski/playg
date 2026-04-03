;; Exercise 3.55. Define a procedure partial-sums that takes as argument a
;; stream S and returns the stream whose elements are S0, S0 + S1, S0 + S1 + S2,
;; .... For example, (partial-sums integers) should be the stream 1, 3, 6, 10,
;; 15, ....

;; 1. define integers stream

(define (create-integers-stream)
  (define (next num)
    (cons-stream num
                 (next (+ 1 num))))

  (cons-stream 1 (next 2)))

(define integers (create-integers-stream))

(define (iterate-stream stream n)
  (cond ((empty-stream? stream) the-empty-stream)
        ((> n 0)
         (display (stream-car stream))
         (newline)
         (iterate-stream (stream-cdr stream) (- n 1)))))

;; 2. define partial-sums stream

(define (partial-sums integers)
  (define (next partial-sum integers)
    (let ((ps (+ partial-sum (stream-car integers))))
      (cons-stream ps
                   (next ps (stream-cdr integers)))))

  (cons-stream (stream-car integers)
               (next (stream-car integers)
                     (stream-cdr integers))))
