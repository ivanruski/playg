;; After considerable work, Alyssa P. Hacker delivers her finished
;; system. Several years later, after she has forgotten all about it, she gets a
;; frenzied call from an irate user, Lem E. Tweakit. It seems that Lem has
;; noticed that the formula for parallel resistors can be written in two
;; algebraically equivalent ways:
;;
;; (R1 * R2) / (R1 + R2)
;;
;; and
;;
;; 1 / (1/R1 + 1/R2)
;;
;; He has written the following two programs, each of which computes the
;; parallel-resistors formula differently:

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

;; Lem complains that Alyssa's program gives different answers for the two ways
;; of computing. This is a serious complaint.
;;
;; Exercise 2.14. Demonstrate that Lem is right. Investigate the behavior of the
;; system on a variety of arithmetic expressions. Make some intervals A and B,
;; and use them in computing the expressions A/A and A/B. You will get the most
;; insight by using intervals whose width is a small percentage of the center
;; value. Examine the results of the computation in center-percent form (see
;; exercise 2.12).

;; I think that the discrepancy comes from the fact that interval arithemtic is
;; not the same as integer arithemtic. R1/R1 is not the "one" interval in the
;; interval world.
;;
;; If we treat R1 and R2 as an integers and we try to expand the second way, we
;; see that it becomes the first way. However if we treat R1 and R2 as intervals
;; we get different result at the end, because the reciprocal of an interval is
;; not the same as reciprocal of an integer.

(define A (make-center-percent 100 0.1))
(define B (make-center-percent 200 0.1))
(define C (make-interval 100 200))
(define ONE (make-interval 1 1))

(mul-interval c (reciprocal c))

(define (reciprocal x)
  (make-interval (/ 1.0 (upper-bound x))
                 (/ 1.0 (lower-bound x))))

;; re-use code from previous exercises
(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent center tolerance)
  (make-center-width center (* center tolerance)))

(define (percent interval)
  (/ (width interval) (center interval)))

(define (div-interval x y)
  (define (spans-zero? interval)
    (let ((l (lower-bound interval))
          (u (upper-bound interval)))
      (or (= l 0)
          (= u 0)
          (and (negative? l)
               (positive? u)))))
  (if (or (spans-zero? x) (spans-zero? y))
      (error "Dividing interval that spans zero is not allowed.")
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
