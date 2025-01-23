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
;; (dot-product v w) - returns the single value obtained by multiplying
;; corresponding components of the vectors and summing the results
;;
;; (matrix-*-vector m v) returns the vector t, where the first element is the
;; dot-product of the first row by the vector, second element is the dot-product
;; of the second row by the vector and so on.
;;
;; (matrix-*-matrix m n) returns the matrix p, where each element of p is a
;; dot-product of a row from m multiplied by col from n. The number of columns
;; in m must equal the number of rows in n (better explanation on the internet).
;;
;; We can define the dot product as:

;; defined the procedures without looking at the code provided from the
;; book(things my be a bit different)

(define (dot-product v w)
  (accumulate + 0 (accumulate-n * 1 (list v w))))

;; Fill in the missing expressions in the following procedures for computing the
;; other matrix operations. (The procedure accumulate-n is defined in exercise
;; 2.36.)

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))


(define (transpose-matrix m)
  (accumulate-n cons '() m))

(define (matrix-*-matrix m n)
  (let ((cols (transpose-matrix n)))
    (map (lambda (row)
           (map (lambda (col) (dot-product row col))
                cols))
         m)))

(define m '((1 2 3) (4 5 6) (7 8 9)))
(define n '((1 2 3 4) (4 5 6 6) (6 7 8 9)))
(define v '(10 11 12 13))


(define (accumulate fn zero-value seq)
  (if (null? seq)
      zero-value
      (fn (car seq)
          (accumulate fn zero-value (cdr seq)))))

(define (accumulate-n fn zero-value seq-of-seqs)
  (if (or (null? seq-of-seqs)
          (null? (car seq-of-seqs)))
      '()
      (cons (accumulate fn zero-value (map car seq-of-seqs))
            (accumulate-n fn zero-value (map cdr seq-of-seqs)))))
