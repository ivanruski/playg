;; Exercise 2.66. Implement the lookup procedure for the case where the set of
;; records is structured as a binary tree, ordered by the numerical values of
;; the keys.

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

;; set-of-records is binary search tree
(define (lookup given-key set-of-records)
  (if (null? set-of-records)
      false
      (let ((current-key (key (entry set-of-records)))
            (left-subtree (left-branch set-of-records))
            (right-subtree (right-branch set-of-records)))
        (cond ((< given-key current-key) (lookup given-key left-subtree))
              ((> given-key current-key) (lookup given-key right-subtree))
              (else (entry set-of-records))))))

;; use representation of recrods where each records is a list and the first
;; element is the numeric key
(define (key record) (car record))

(define records (list->tree '((1 ivan 27)
                              (2 lori 27)
                              (3 geri 27)
                              (5 yavor 30)
                              (8 marto 26)
                              (13 bobi 27))))

(lookup 1 records)
(lookup 2 records)
(lookup 3 records)
(lookup 4 records)
(lookup 5 records)
(lookup 13 records)
(lookup 15 records)

