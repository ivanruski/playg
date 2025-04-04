;; Exercise 2.28. Write a procedure fringe that takes as argument a tree
;; (represented as a list) and returns a list whose elements are all the leaves
;; of the tree arranged in left-to-right order. For example,
;;
;; (define x (list (list 1 2) (list 3 4)))
;;
;; (fringe x)
;; (1 2 3 4)
;;
;; (fringe (list x x))
;; (1 2 3 4 1 2 3 4)

(define (fringe tree)
  (if (null? tree)
      '()
      (let ((left (car tree))
            (right (cdr tree)))
        (if (list? left)
            (append (fringe left) (fringe right))
            (cons left (fringe right))))))

(define x (list (list 1 2) (list 3 4)))
(fringe x)

(fringe (list x x))
