;; Exercise 2.66. Implement the lookup procedure for the case where the set of
;; records is structured as a binary tree, ordered by the numerical values of
;; the keys.

(define (lookup given-key tree-of-records)
  (if (null? tree-of-records)
      #f
      (let ((record-key (key (entry tree-of-records))))
        (cond ((< given-key record-key) (lookup given-key (left-branch tree-of-records)))
              ((> given-key record-key) (lookup given-key (right-branch tree-of-records)))
              (else
               (entry tree-of-records))))))

;; let's say the first element of the record is its numerical value
(define (key record) (car record))

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))


(define t1 (make-tree '(7 Ivan)
                      (make-tree '(3 Pesho)
                                 (make-tree '(1 Gosho) '() '())
                                 (make-tree '(5 Zhivka) '() '()))
                      (make-tree '(9 Stefka)
                                 '()
                                 (make-tree '(11 Vasko) '() '()))))
