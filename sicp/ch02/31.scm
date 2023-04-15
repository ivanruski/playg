;; Exercise 2.31. Abstract your answer to exercise 2.30 to produce a
;; procedure tree-map with the property that square-tree could be defined
;; as (define (square-tree tree) (tree-map square tree))

(define (tree-map fn tree)
  (define (leaf? tree) (number? tree))
  (cond ((null? tree) ())
        ((leaf? tree) (fn tree))
        (else
         (cons (tree-map fn (car tree))
               (tree-map fn (cdr tree))))))

(define (square-tree tree) (tree-map square tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define (cube-tree tree) (tree-map cube tree))

(cube-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

