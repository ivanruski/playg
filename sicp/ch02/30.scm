;; Exercise 2.30. Define a procedure square-tree analogous to the square-list
;; procedure of exercise 2.21. That is, square-list should behave as follows:
;;
;; (square-tree
;;  (list 1
;;        (list 2 (list 3 4) 5)
;;        (list 6 7)))
;; (1 (4 (9 16) 25) (36 49))
;;
;; Define square-tree both directly (i.e., without using any higher-order
;; procedures) and also by using map and recursion.

(define (square-tree tree)
  (cond ((null? tree) '())
        ((pair? (car tree)) (cons (square-tree (car tree))
                                  (square-tree (cdr tree))))
        (else (cons (square (car tree))
                    (square-tree (cdr tree))))))

(define (square-tree tree)
  (map (lambda (node)
         (if (pair? node) (square-tree node) (square node)))
       tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
