;; Exercise 3.26. To search a table as implemented above, one needs to scan
;; through the list of records. This is basically the unordered list
;; representation of section 2.3.3. For large tables, it may be more efficient
;; to structure the table in a different manner. Describe a table implementation
;; where the (key, value) records are organized using a binary tree, assuming
;; that keys can be ordered in some way (e.g., numerically or
;; alphabetically). (Compare exercise 2.66 of chapter 2.)

;; I should read the exercises' description more carefully!
;; Instead of describing I went with a PoC implementation.
;;
;; My idea was to have a BST(I didn't implement deletion) where each node's
;; value is either a value or another(nested) BST. In this way I can have
;; multi-keys.

;; not perfect, but it will do the job for this exercise
(define (node? node)
  (and (list? node)
       (= (length node) 3)
       (or (= (length (cadr node)) 2)
           (= (length (cadr node)) 1))))

(define (make-node key value)
  (list '() (list key value) '()))

(define (node-key n)
  (car (cadr n)))

(define (node-value n)
  (let ((value (cadr n)))
    (if (= (length value) 1) ;; only key
        '()
        (cadr value))))

(define (set-node-value! node value)
  (let ((l (cadr node)))
    (set-cdr! l (list value))))

(define (left-child n)
  (car n))

(define (right-child n)
  (caddr n))

(define (set-left-child! node left)
  (set-car! node left))

(define (set-right-child! node right)
  (set-car! (cddr node) right))

(define (insert-node! root node)
  (if (null? root)
      '()
      (let ((rk (node-key root))
            (nk (node-key node)))
        (cond ((equal? rk nk)
               (set-left-child node (left-child root))
               (set-right-child node (right-child root))
               (set! root node))
              ((string<? rk nk)
               (if (null? (right-child root))
                   (set-right-child! root node)
                   (insert-node! (right-child root) node)))
              (else
               (if (null? (left-child root))
                   (set-left-child! root node)
                   (insert-node! (left-child root) node)))))))

(define (find-node node key)
  (if (null? node)
      '()
      (let ((nk (node-key node)))
        (cond ((equal? nk key) node)
              ((string<? nk key) (find-node (right-child node) key))
              (else (find-node (left-child node) key))))))

(define (make-table)
  (list '*table*))

;; support multi-keyed table, where under each node's value can be another BST
;;
;; insert!
;; 1. find node for the first key
;;   1. the first key is the only key
;;     1. if node exists, set its value
;;     2. if node does not exist, create the value
;;   2. the first key is not the only key
;;     1. if the node exists
;;       1. if its value is not another node, but a value, return error
;;       2. if its value is another node, search for the next node with the next key and the node value
;;     2. if the node does not exist, insert the node and for its value insert the next key, and so on
(define (insert! table keys value)
  (define (insert-nodes! root keys value)
    (if (null? keys)
        '()
        (let ((key (car keys))
              (nested-keys (cdr keys)))
          (cond ((null? nested-keys)
                 (let ((node (find-node root key)))
                   (if (null? node)
                       (insert-node! root (make-node key value))
                       (set-node-value! node value))))
                (else
                 (let ((node (find-node root key)))
                   (cond ((null? node) (insert-node! root (make-node key
                                                                     (create-root nested-keys value))))
                         ;; if node value is not another node, create a sub-tree
                         ((not (node? (node-value node)))
                          (set-node-value! node (create-root nested-keys value)))
                         (else
                          (insert-nodes! (node-value node) nested-keys value)))))))))

  (define (create-root keys value)
    (if (= (length keys) 1)
        (make-node (car keys) value)
        (make-node (car keys) (create-root (cdr keys) value))))

  (if (null? keys)
      (error "keys cannot be nil -- INSERT!")
      (let ((root (cdr table)))
        (if (null? root)
            (set-cdr! table (create-root keys value))
            (insert-nodes! (cdr table) keys value)))))

(define (lookup table keys)
  '())

;;;;  tests

;; insert first element - multi-key
(define t (make-table))
(insert! t (list "a" "b" "c") 1)

;; insert first element - single-key
(define t (make-table))
(insert! t (list "a") 1)

;; insert single keys
(define t (make-table))
(insert! t (list "b") 1)
(insert! t (list "a") 2)
(insert! t (list "c") 3)

;; insert multi-keys
(define t (make-table))
(insert! t (list "b") 1)

(insert! t (list "math" "+") 43)
(insert! t (list "math" "-") 48)
(insert! t (list "math" "*") 42)

;; override the multi-keyed table
(insert! t (list "math") 20)

;; override single key with multi-key
(insert! t (list "math" "*") 42)
(insert! t (list "0") 0)

(insert! t (list "letters" "a") 97)
(insert! t (list "letters" "b") 98)
