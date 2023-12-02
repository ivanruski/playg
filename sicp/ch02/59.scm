;; Implement the union-set operation for the unordered-list representation of
;; sets.

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        ((element-of-set? (car set1) set2)
         (union-set (cdr set1) set2))
        (else
         (cons (car set1)
               (union-set (cdr set1) set2)))))

(union-set '(1 2 3) '(4 5 6))
(union-set '(1 2 3) '())
(union-set '() '(4 5 6))
(union-set '(1) '(4 5 6))
(union-set '(1 2) '(3))
(union-set '(1 2 3) '(3 4 5))
