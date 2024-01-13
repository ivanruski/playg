;; The following procedure list->tree converts an ordered list to a balanced
;; binary tree. The helper procedure partial-tree takes as arguments an integer
;; n and list of at least n elements and constructs a balanced tree containing
;; the first n elements of the list. The result returned by partial-tree is a
;; pair (formed with cons) whose car is the constructed tree and whose cdr is
;; the list of elements not included in the tree.

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

;; a. Write a short paragraph explaining as clearly as you can how partial-tree
;; works. Draw the tree produced by list->tree for the list (1 3 5 7 9 11).
;;
;; The procedure works recursively. On every invocation it creates two subtrees:
;; the first subtree has elements less then the middle element in the list, the
;; second subtree has elements larger then the middle element and then attaches
;; those two subtrees to the middle element. It goes to the left as much as
;; possible, slicing the smallest elements in the list first, of the remainding
;; elements the first one will be the root and the others will be part of the
;; right subtree.
;; 
;;    5
;;  /   \
;; 1     9
;;  \   / \
;;   3 7  11

;; b. What is the order of growth in the number of steps required by list->tree
;; to convert a list of n elements?
;;
;; The order of growth is O(n) because we have to go through all of the elements
;; and we go through each element only once. 
