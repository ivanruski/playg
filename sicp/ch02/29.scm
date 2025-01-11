;; Exercise 2.29. A binary mobile consists of two branches, a left branch and a
;; right branch. Each branch is a rod of a certain length, from which hangs
;; either a weight or another binary mobile. We can represent a binary mobile
;; using compound data by constructing it from two branches (for example, using
;; list):
;;
;; (define (make-mobile left right)
;;   (list left right))
;;
;; A branch is constructed from a length (which must be a number) together with
;; a structure, which may be either a number (representing a simple weight) or
;; another mobile:
;;
;; (define (make-branch length structure)
;;   (list length structure))
;;
;; a. Write the corresponding selectors left-branch and right-branch, which
;; return the branches of a mobile, and branch-length and branch-structure,
;; which return the components of a branch.
;;
;; b. Using your selectors, define a procedure total-weight that returns the
;; total weight of a mobile.
;;
;; c. A mobile is said to be balanced if the torque applied by its top-left
;; branch is equal to that applied by its top-right branch (that is, if the
;; length of the left rod multiplied by the weight hanging from that rod is
;; equal to the corresponding product for the right side) and if each of the
;; submobiles hanging off its branches is balanced. Design a predicate that
;; tests whether a binary mobile is balanced.
;;
;; d. Suppose we change the representation of mobiles so that the constructors
;; are
;;
;; (define (make-mobile left right)
;;   (cons left right))
;; (define (make-branch length structure)
;;   (cons length structure))
;;
;; How much do you need to change your programs to convert to the new
;; representation?

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;; a.

(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))

(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

;; b.

(define (weight? structure) (number? structure))

(define (total-weight mobile)
  (cond ((null? mobile) 0)
        ((weight? mobile) mobile)
        (else (+ (total-weight (branch-structure (left-branch mobile)))
                 (total-weight (branch-structure (right-branch mobile)))))))

(define x (make-mobile (make-branch 1 1) (make-branch 2 2)))
(define y (make-mobile (make-branch 1 x) (make-branch 2 x)))
(define z (make-mobile (make-branch 1 x) (make-branch 2 y)))

(total-weight x)
(total-weight y)
(total-weight z)

;; c.

(define (balanced? mobile)
  (define (struct-balanced? struct)
    (if (weight? struct)
        #t
        (balanced? struct)))
  (if (null? mobile)
      #t
      (let ((left (left-branch mobile))
            (right (right-branch mobile)))
        (let ((left-length (branch-length left))
              (left-struct (branch-structure left))
              (right-length (branch-length right))
              (right-struct (branch-structure right)))
          (and (= (* left-length (total-weight left-struct))
                  (* right-length (total-weight right-struct)))
               (struct-balanced? left-struct)
               (struct-balanced? right-struct))))))

(balanced? x)
(balanced? y)
(balanced? z)

(define a (make-mobile (make-branch 1 1) (make-branch 1 1)))
(define b (make-mobile (make-branch 2 a) (make-branch 2 a)))
(define c (make-mobile (make-branch 2 a) (make-branch 2 2)))
(define d (make-mobile (make-branch 3 b) (make-branch 3 c)))
(define e (make-mobile (make-branch 4 a) (make-branch 2 b)))

(balanced? a)
(balanced? b)
(balanced? c)
(balanced? d)
(balanced? e)

(define f (make-mobile (make-branch 2 y) (make-branch 4 x)))
(balanced? f)

;; d. I need to update the 2 procedures below and everything works

(define (right-branch mobile) (cdr mobile))
(define (branch-structure branch) (cdr branch))
