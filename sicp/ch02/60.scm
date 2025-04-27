;; Exercise 2.60. We specified that a set would be represented as a list with no
;; duplicates. Now suppose we allow duplicates. For instance, the set {1,2,3}
;; could be represented as the list (2 3 2 1 3 2 2). Design procedures
;; element-of-set?, adjoin-set, union-set, and intersection-set that operate on
;; this representation. How does the efficiency of each compare with the
;; corresponding procedure for the non-duplicate representation? Are there
;; applications for which you would use this representation in preference to the
;; non-duplicate one?

;; element-of-set? stays the same
;;
;; The time complexity remains O(n).
(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))

;; if duplicates are allowed, we don't need to check if the element exists
;; before adjoining it
;;
;; The time complexity is O(1) because we are simply attaching a new element at
;; the front of the set.
(define (adjoin-set x set)
  (cons x set))

;; again, we don't need to check if the element exists
;;
;; The time complexity is O(n) (append's grows as O(n)), compared to O(n^2) in
;; the previous implementation where we had to perform element-of-set? for each
;; element in sx.
(define (union-set xs ys)
  (append xs ys))

;; intersection-set remains the same
;;
;; The time complexity remains O(n^2).
(define (intersection-set xs ys)
  (cond ((or (null? xs) (null? ys)) '())
        ((element-of-set? (car xs) ys)
         (cons (car xs) (intersection-set (cdr xs) ys)))
        (else
         (intersection-set (cdr xs) ys))))

;; Personally, I would use the non-duplicate representation in any case. One
;; might argue that if I perform more adjoins I should use the duplicate
;; representation but I am not sure if the trade off is worth it.
