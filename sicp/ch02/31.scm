;; Exercise 2.31. Abstract your answer to exercise 2.30 to produce a procedure
;; tree-map with the property that square-tree could be defined as

(define (square-tree tree) (tree-map square tree))

(define (tree-map proc tree)
  (map (lambda (node)
         (if (pair? node) (tree-map proc node) (proc node)))
       tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

