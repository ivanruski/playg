;; Exercise 2.60. We specified that a set would be represented as a list with no
;; duplicates. Now suppose we allow duplicates. For instance, the set {1,2,3} could
;; be represented as the list (2 3 2 1 3 2 2). Design procedures element-of-set?,
;; adjoin-set, union-set, and intersection-set that operate on this
;; representation. How does the efficiency of each compare with the corresponding
;; procedure for the non-duplicate representation? Are there applications for which
;; you would use this representation in preference to the non-duplicate one?

;; not changed
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

;; dups are allowed, simply adjoin.
;; The funcions runs in O(1) because we simply append to the front (assuming cons takes O(1))
(define (adjoin-set x set)
  (cons x set))

;; not changed
(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else
         (intersection-set (cdr set1) set2))))

;; interesction-set will return different results if s1 and s2 are swapped on
;; invocation
(intersection-set '(2 3 2 1 3 2 2) '(1 2 3))
(intersection-set '(1 2 3) '(2 3 2 1 3 2 2))

;; dups are allowed, simply append
;; The efficiency of the function depends on the efficiency of append, which I think is
;; O(n) where n is the length of the first set.
(define (union-set set1 set2)
  (append set1 set2))

(define (append-custom set1 set2)
  (if (null? set1)
      set2
      (cons (car set1)
            (append-custom (cdr set1) set2))))

;; Overall it looks like we improved the performance of the union-set and adjoin-set,
;; however we will be working with bigger Ns as we allow duplicates. Bigger Ns means
;; more memory consumption and CPU consumption.
;; I can't think of any applications for using the second approach, because the effort
;; to achieve the first approach is the same and the first is better IMO.
