;; Exercise 2.37. Suppose we represent vectors v = (vi) as sequences of
;; numbers, and matrices m = (mij) as sequences of vectors (the rows of
;; the matrix). For example, the matrix
;; 
;; | 1 2 3 4 |
;; | 4 5 6 6 |
;; | 6 7 8 9 |
;;
;; is represented as the sequence ((1 2 3 4) (4 5 6 6) (6 7 8 9)). With
;; this representation, we can use sequence operations to concisely
;; express the basic matrix and vector operations. These operations
;; (which are described in any book on matrix algebra) are the following:
;;
;; (dot-product v w)     returns the sum Σi(mij)(vi)
;; (matrix-*-vector m v) returns the vector t, where ti = Σi(mij)(vi)
;; (matrix-*-matrix m n) returns the matrix p, where pij = Σk(mik)(nkj)
;; We can define the dot product as:

(define (accumulate op init sequence)
  (if (null? sequence)
      init
      (op (car sequence)
          (accumulate op init (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (or (null? seqs)
          (null? (car seqs)))
      ()
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))


(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(define (transpose m)
  (accumulate-n cons '() m))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-*-vector cols row)) m)))


(define v '(1 2 3 4))
(define m '((1 2 3 4) (4 5 6 6) (6 7 8 9)))

(define m1 '((1 2 3) (4 5 6) (7 8 9)))
(define m2 '((1 2 3) (5 6 7) (8 8 9) (9 9 9)))

(matrix-*-matrix m1 m1)
(matrix-*-matrix m m2)
