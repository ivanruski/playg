;; Exercise 2.32. We can represent a set as a list of distinct elements,
;; and we can represent the set of all subsets of the set as a list of
;; lists. For example, if the set is (1 2 3), then the set of all subsets
;; is: (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)).
;; Complete the following definition of a procedure that generates the
;; set of subsets of a set and give a clear explanation of why it works:

(define (subsets s)
  (if (null? s)
      (list ())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (append (list (car s)) x)) rest)))))

(subsets (list 1))

(subsets (list 1 2 3))

;; Why it works ?
;; rest is a list of lists. For each of the sublists of rest we append
;; the first element of s, like below:
(map (lambda (x) (append '(1) x)) '(() (2) (3) (2 3)))
;; We will generate all of the subsets for the remaining of the list
;; and we will create new list where some of the elements will be all
;; of the subsets for the remaining of the lists and the other elements
;; will be formed by appending the first element of s to those subsets.
;; e.g.
(append '(() (2) (3) (2 3))
        (map (lambda (x) (append '(1) x)) '(() (2) (3) (2 3))))

