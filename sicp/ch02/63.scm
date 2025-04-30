;; Exercise 2.63. Each of the following two procedures converts a binary tree to
;; a list.

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

;; a. Do the two procedures produce the same result for every tree? If not, how
;; do the results differ? What lists do the two procedures produce for the trees
;; in figure 2.16?
;;
;; Yes, the two procedures produce the same results. The both build the result
;; list by traversing the tree in such a way that result list is sorted in asc
;; order.

;;
;; b. Do the two procedures have the same order of growth in the number of steps
;; required to convert a balanced tree with n elements to a list? If not, which
;; one grows more slowly?
;;
;; No, the two procedures does not have the same order of growth in the number
;; of steps. tree->list-2 always inserts to the front of the list, whereas
;; tree->list-1 appends the list from the left branch to the list of the right
;; branch. Appending is slower than inserting at the front.


(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))


(define t1 (make-tree 7
                      (make-tree 3
                                 (make-tree 1 '() '())
                                 (make-tree 5 '() '()))
                      (make-tree 9
                                 '()
                                 (make-tree 11 '() '()))))

(define t2 (make-tree 3
                      (make-tree 1 '() '())
                      (make-tree 7
                                 (make-tree 5 '() '())
                                 (make-tree 9
                                            '()
                                            (make-tree 11 '() '())))))

(define t3 (make-tree 5
                      (make-tree 3
                                 (make-tree 1 '() '())
                                 '())
                      (make-tree 9
                                 (make-tree 7 '() '())
                                 (make-tree 11 '() '()))))

(define t4 (make-tree 1 '()
                      (make-tree 3 '()
                                 (make-tree 5 '()
                                            (make-tree 7 '()
                                                       (make-tree 9 '()
                                                                  (make-tree 11 '() '())))))))

(define t5 (make-tree 11
                      (make-tree 9
                                 (make-tree 7
                                            (make-tree 5
                                                       (make-tree 3
                                                                  (make-tree 1 '() '())
                                                                  '())
                                                       '())
                                            '())
                                 '())
                      '()))
