;; Exercise 2.33. Fill in the missing expressions to complete the
;; following definitions of some basic list-manipulation operations as
;; accumulations:

(define (accumulate fn initial-value sequence)
  (if (null? sequence)
      initial-value
      (fn (car sequence)
          (accumulate fn initial-value (cdr sequence)))))

(define (map2 p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) () sequence))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
