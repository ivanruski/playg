;; Exercise 2.32. We can represent a set as a list of distinct elements, and we
;; can represent the set of all subsets of the set as a list of lists. For
;; example, if the set is (1 2 3), then the set of all subsets is
;; (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)).
;; Complete the following definition of a procedure
;; that generates the set of subsets of a set and give a clear explanation of
;; why it works:

(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (set) (cons (car s) set)) rest)))))

;; The idea is to find out the subsets for all elements but first and then add
;; the first to each of the returned subsets and also keeping the
;; original/returned subsets in the result. For example:
;;
;; (subsets (list 1 2 3 4))
;; The bootom of the recursion is when we get to (subsets (list 4))
;; rest = (list '()) and (car s) = 4
;; (append (list '()) (map (lambda (s) (cons 4 s)) (list '())))
;; (() (4))
;;
;; After that
;; rest = (() (4)), (car s) = 3
;; (append '(() (4)) (map (lambda (s) (cons 3 s)) '(() (4))))
;;
;; and so on...
