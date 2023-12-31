;; Each of the following two procedures converts a binary tree to a list.

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

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

(define t4 (make-tree 7
                      '()
                      (make-tree 13
                                 (make-tree 9
                                            '()
                                            (make-tree 11 '() '()))
                                 '())))

(tree->list-1 t4)
(tree->list-2 t4)

;; I think that the two procedures will always produce the same result. The
;; first one is always going to the leftmost node before processing the entry
;; and the to the right side. So if we have a valid BST it will always produce
;; increasing sequence. The second one is always going to the rightmost node
;; before processing the entry and then the left side. i.e. the first procedure
;; starts building the result from the smallest entry whereas the second starts
;; from the largest one.


;; b. Do the two procedures have the same order of growth in the number of steps
;; required to convert a balanced tree with n elements to a list? If not, which
;; one grows more slowly?

;; The second one should grow more slowly because we are inserting elements at
;; the beginning of the result list which should take a constant number of
;; steps, whereas in the first one we are appending the left to the right and
;; appending is not a constaint operation.
