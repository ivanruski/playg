;; Exercise 2.65. Use the results of exercises 2.63 and 2.64 to give O(n)
;; implementations of union-set and intersection-set for sets implemented as
;; (balanced) binary trees.

;; re-use union-set for ordered lists and convert between binary tree and
;; ordered list and vice-versa.
;; The implementation is O(n) because tree->list is O(n) and list->tree is O(n)
(define (union-set tree-one tree-two)
  (list->tree (union-list-set (tree->list tree-one)
                              (tree->list tree-two))))

;; The above comment applies here.
(define (intersection-set tree-one tree-two)
  (list->tree (intersection-list-set (tree->list tree-one)
                                     (tree->list tree-two))))

;; procs copied from previous exercises and code samples
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? x (left-branch set)))
        ((> x (entry set))
         (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree (entry set) 
                    (adjoin-set x (left-branch set))
                    (right-branch set)))
        ((> x (entry set))
         (make-tree (entry set)
                    (left-branch set)
                    (adjoin-set x (right-branch set))))))


(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

(define (union-list-set one two)
  (if (or (null? one) (null? two))
      (append one two)
      (let ((x (car one))
            (y (car two)))
        (cond ((= x y) (cons x (union-list-set (cdr one)
                                               (cdr two))))
              ((< x y) (cons x (union-list-set (cdr one)
                                               two)))
              ((> x y) (cons y (union-list-set one
                                               (cdr two))))))))
(define (intersection-list-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-list-set (cdr set1)
                                            (cdr set2))))
              ((< x1 x2)
               (intersection-list-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-list-set set1 (cdr set2)))))))
