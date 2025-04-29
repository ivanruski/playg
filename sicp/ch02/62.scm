;; Exercise 2.62. Give a O(n) implementation of union-set for sets represented
;; as ordered lists.

(define (union-set one two)
  (if (or (null? one) (null? two))
      (append one two)
      (let ((x (car one))
            (y (car two)))
        (cond ((= x y) (cons x (union-set (cdr one)
                                          (cdr two))))
              ((< x y) (cons x (union-set (cdr one)
                                          two)))
              ((> x y) (cons y (union-set one
                                          (cdr two))))))))

(union-set '(1 2 3) '(4 5 6))
(union-set '(1 2 3) '())
(union-set '() '(4 5 6))
(union-set '(1) '(4 5 6))
(union-set '(1 2) '(3))
(union-set '(1 2 3) '(3 4 5))
(union-set '(3) '(3 4 5))
(union-set '(1 2 3) '(3))
