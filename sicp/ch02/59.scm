;; Exercise 2.59. Implement the union-set operation for the unordered-list
;; representation of sets.

(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((eq? (car set) x) #t)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (union-set sx sy)
  (cond ((null? sx) sy)
        ((element-of-set? (car sx) sy) (union-set (cdr sx) sy))
        (else (union-set (cdr sx) (cons (car sx) sy)))))
