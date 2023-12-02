;; Exercise 2.62. Give a (n) implementation of union-set for sets represented as
;; ordered lists.

;; Effectively, do a merge of to sorted sets just like in merge sort

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((x1 (car set1))
               (x2 (car set2)))
           (cond ((< x1 x2) (cons x1
                                  (union-set (cdr set1) set2)))
                 ((> x1 x2) (cons x2
                                  (union-set set1 (cdr set2))))
                 (else
                  (union-set (cdr set1) set2)))))))

(union-set '(1 2 3) '(4 5 6))
(union-set '(1 2 3) '())
(union-set '() '(4 5 6))
(union-set '(1) '(4 5 6))
(union-set '(1 2) '(3))
(union-set '(1 2 3) '(3 4 5))
(union-set '(3) '(3 4 5))
(union-set '(1 2 3) '(3))
