;; Exercise 2.65. Use the results of exercises 2.63 and 2.64 to give O(n)
;; implementations of union-set and intersection-set for sets implemented as
;; (balanced) binary trees

;; for union and intersection of trees I reuse list->tree, union-set and
;; intersection-set for ordered sets from previous exercises. All of the three
;; functions are with O(n) implementations and the complexity of the new one is
;; O(n) because we invoke 4 O(n) functions
(define (union-tree t1 t2)
  (list->tree (union-set (tree->list-2 t1)
                         (tree->list-2 t2))))

(define (intersect-tree t1 t2)
  (list->tree (intersection-set (tree->list-2 t1)
                                (tree->list-2 t2))))

(union-tree (list->tree '(1 2 3))
            (list->tree '(1 2 3)))

(union-tree (list->tree '(1 2 3))
            (list->tree '(4 5 6)))

(union-tree (list->tree '(1 3 5 7 9 11 13))
            (list->tree '(11 13 15 17 19)))

(intersect-tree (list->tree '(1 2 3))
                (list->tree '(1 2 3)))

(intersect-tree (list->tree '(1 2 3))
                (list->tree '(4 5 6)))

(intersect-tree (list->tree '(1 3 5 7 9 11 13))
                (list->tree '(11 13 15 17 19)))


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

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-result (partial-tree elts (quotient (- n 1) 2))))
        (let ((root (cadr left-result))
              (left-subtree (car left-result))
              (next-elts (cddr left-result)))
          (let ((right-result (partial-tree next-elts (quotient n 2))))
            (cons (make-tree root left-subtree (car right-result))
                  (cdr right-result)))))))
