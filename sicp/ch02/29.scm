;; Exercise 2.29. A binary mobile consists of two branches, a left branch
;; and a right branch. Each branch is a rod of a certain length, from
;; which hangs either a weight or another binary mobile. We can represent
;; a binary mobile using compound data by constructing it from two
;; branches (for example, using list):
;; 
;; (define (make-mobile left right) (list left right))
;; 
;; A branch is constructed from a length (which must be a number)
;; together with a structure, which may be either a number (representing
;; a simple weight) or another mobile:
;; 
;; (define (make-branch length structure) (list length structure))
;; 
;; a. Write the corresponding selectors left-branch and right-branch,
;; which return the branches of a mobile, and branch-length and
;; branch-structure, which return the components of a branch.
;; 
;; b. Using your selectors, define a procedure total-weight that returns
;; the total weight of a mobile.
;; 
;; c. A mobile is said to be balanced if the torque applied by its
;; top-left branch is equal to that applied by its top-right branch (that
;; is, if the length of the left rod multiplied by the weight hanging
;; from that rod is equal to the corresponding product for the right
;; side) and if each of the submobiles hanging off its branches is
;; balanced. Design a predicate that tests whether a binary mobile is
;; balanced.
;; 
;; d. Suppose we change the representation of mobiles so that the
;; constructors are
;; 
;; (define (make-mobile left right) (cons left right)) (define
;; (make-branch length structure) (cons length structure))
;; 
;; How much do you need to change your programs to convert to the new
;; representation?

(define (make-mobile left right) (list left right))

(define (make-branch length structure) (list length structure))

;; mobile
;;            |
;;            |
;;            |
;;    ---6---   ---6----
;;   |                 |
;;   5             -3-   -3-
;;                |         |
;;                3         3

;; a. Write the corresponding selectors left-branch and right-branch,
;; which return the branches of a mobile, and branch-length and
;; branch-structure, which return the components of a branch.

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cadr mobile))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cadr branch))

;; b. Using your selectors, define a procedure total-weight that returns
;; the total weight of a mobile.

(define (branch? b)
  (and (list? b)
       (= (length b) 2)
       (number? (branch-length b))
       (or (number? (branch-structure b))
           (mobile? (branch-structure b)))))

(define (mobile? m)
  (and (list? m)
       (= (length m) 2)
       (branch? (left-branch m))
       (branch? (right-branch m))))

(define (branch-weight branch)
  (let ((structure (branch-structure branch)))
    (if (mobile? structure)
        (total-weight structure)
        structure)))
  
(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))
  
;; c. A mobile is said to be balanced if the torque applied by its
;; top-left branch is equal to that applied by its top-right branch (that
;; is, if the length of the left rod multiplied by the weight hanging
;; from that rod is equal to the corresponding product for the right
;; side) and if each of the submobiles hanging off its branches is
;; balanced. Design a predicate that tests whether a binary mobile is
;; balanced.

(define (balanced? m)
  (define (subm-balanced? sm)
    (if (number? sm)
        true
        (balanced? sm)))
  (define (torque b)
    (* (branch-length b) (branch-weight b)))
  (let ((left (left-branch m))
        (right (right-branch m)))
    (and (= (torque left) (torque right))
         (subm-balanced? (branch-structure left))
         (subm-balanced? (branch-structure right)))))
         

;; d. Suppose we change the representation of mobiles so that the
;; constructors are
;; 
;; (define (make-mobile left right) (cons left right))
;; (define (make-branch length structure) (cons length structure))
;; 
;; How much do you need to change your programs to convert to the new
;; representation?

(define (make-mobile left right) (cons left right))
(define (make-branch length structure) (cons length structure))

;; Changing the following functions seems to be enough to work with
;; the new representation

(define (right-branch m)
  (cdr m))

(define (branch-structure branch)
  (cdr branch))

(define (branch? b)
  (and (pair? b)
       (number? (branch-length b))
       (or (number? (branch-structure b))
           (mobile? (branch-structure b)))))

(define (mobile? m)
  (and (pair? m)
       (branch? (left-branch m))
       (branch? (right-branch m))))

;; mobiles for testing
(define m (make-mobile (make-branch 6 5)
                       (make-branch 6
                                    (make-mobile
                                     (make-branch 3 3)
                                     (make-branch 3 3)))))

(define m2 (make-mobile (make-branch 6
                                     (make-mobile (make-branch 3 3)
                                                  (make-branch 3 3)))
                        (make-branch 6
                                     (make-mobile (make-branch 3 3)
                                                  (make-branch 3 3)))))

(define m3 (make-mobile (make-branch 3 1)
                        (make-branch 1 3)))


(define m4 (make-mobile (make-branch 6 6)
                        (make-branch 6
                                     (make-mobile (make-branch 3 3)
                                                  (make-branch 3 3)))))

(define m5 (make-mobile (make-branch 6 6)
                        (make-branch 6
                                     (make-mobile (make-branch 1 3)
                                                  (make-branch 3 3)))))

;; Below is output when the representation is a list vs pair

(left-branch m)
;; list: (6 5)
;; pair: (6 . 5)

(right-branch m)
;; list: (6 ((3 3) (3 3)))
;; pair: (6 (3 . 3) 3 . 3)

(branch-length (left-branch m))
;; list: 6
;; pair: 6

(branch-length (right-branch m))
;; list: 6
;; pair: 6

(branch-structure (left-branch m))
;; list: 5
;; pair: 5

(branch-structure (right-branch m))
;; list: ((3 3) (3 3))
;; pair: ((3 . 3) 3 . 3)

(branch? m)
;; list: #f
;; pair: #f

(branch? (left-branch m))
;; list: #t
;; pair: #t

(branch-weight (left-branch m))
;; list: 5
;; pair: 5

(branch-weight (right-branch m))
;; list: 6
;; pair: 6

(mobile? m)
;; list: #t
;; pair: #t

(mobile? (left-branch m))
;; list: #f
;; pair: #f 

(total-weight m)
;; list: 11
;; pair: 11

(total-weight m2)
;; list: 12
;; pair: 12

(total-weight m3)
;; list: 4
;; pair: 4

(total-weight m4)
;; list: 12
;; pair: 12

(balanced? m)
;; list: #f
;; pair: #f

(balanced? m2)
;; list: #t
;; pair: #t

(balanced? m3)
;; list: #t
;; pair: #t

(balanced? m4)
;; list: #t
;; pair: #t

(balanced? m5)
;; list: #f
;; pair: #f
