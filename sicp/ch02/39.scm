;; Exercise 2.39. Complete the following definitions of reverse (exercise 2.18)
;; in terms of fold-right and fold-left from exercise 2.38:

(define (fold-left op zero sequence)
  (define (iter result seq)
    (if (null? seq)
        result
        (iter (op result (car seq)) (cdr seq))))
  (iter zero sequence))

(define (fold-right op zero sequence)
  (if (null? sequence)
      zero
      (op (car sequence)
          (fold-right op zero (cdr sequence)))))

(define (reverse-r sequence)
  (fold-right (lambda (x y) (append y (list x)))
              '()
              sequence))

(define (reverse-l sequence)
  (fold-left (lambda (x y) (append (list y) x))
             '()
             sequence))
