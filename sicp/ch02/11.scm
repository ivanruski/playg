;; Exercise 2.11. In passing, Ben also cryptically comments: ``By testing the
;; signs of the endpoints of the intervals, it is possible to break mul-interval
;; into nine cases, only one of which requires more than two multiplications.''
;; Rewrite this procedure using Ben's suggestion.

(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

;; old
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

;; Treating 0 as positive
;; | l1 | u1 | l2 | u2 | result                             |
;; |----+----+----+----+------------------------------------|
;; | +  | +  | +  | +  | l1xl2, u1xu2                       |
;; | +  | +  | -  | +  | u1xl2, u1xu2                       |
;; | +  | +  | -  | -  | u1xl2, l1xu2                       |
;; | -  | +  | +  | +  | l1xu2, u1xu2                       |
;; | -  | +  | -  | +  | min(l1xu2,u1xl2), max(l1xl2,u1xu2) |
;; | -  | +  | -  | -  | u1xl2, l1xl2                       |
;; | -  | -  | +  | +  | l1xu2, u1xl2                       |
;; | -  | -  | -  | +  | l1,u2, l1xl2                       |
;; | -  | -  | -  | -  | u1xu2, l1xl2                       |

(define (mul-interval-2 x y)
  (define (neutral? num)
    (not (negative? num)))
  (let ((l1 (lower-bound x))
        (u1 (upper-bound x))
        (l2 (lower-bound y))
        (u2 (upper-bound y)))
    (cond ((and (neutral? l1) (neutral? u1) (neutral? l2) (neutral? u2))
           (make-interval (* l1 l2) (* u1 u2)))
          ((and (neutral? l1) (neutral? u1) (negative? l2) (neutral? u2))
           (make-interval (* u1 l2) (* u1 u2)))
          ((and (neutral? l1) (neutral? u1) (negative? l2) (negative? u2))
           (make-interval (* u1 l2) (* l1 u2)))

          ((and (negative? l1) (neutral? u1) (neutral? l2) (neutral? u2))
           (make-interval (* l1 u2) (* u1 u2)))
          ((and (negative? l1) (neutral? u1) (negative? l2) (neutral? u2))
           (make-interval (min (* l1 u2) (* u1 l2))
                          (max (* l1 l2) (* u1 u2))))
          ((and (negative? l1) (neutral? u1) (negative? l2) (negative? u2))
           (make-interval (* u1 l2) (* l1 l2)))

          ((and (negative? l1) (negative? u1) (neutral? l2) (neutral? u2))
           (make-interval (* l1 u2) (* u1 l2)))
          ((and (negative? l1) (negative? u1) (negative? l2) (neutral? u2))
           (make-interval (* l1 u2) (* l1 l2)))
          ((and (negative? l1) (negative? u1) (negative? l2) (negative? u2))
           (make-interval (* u1 u2) (* l1 l2))))))

;; 1
(mul-interval (make-interval 5 10) (make-interval 23 27))
(mul-interval-2 (make-interval 5 10) (make-interval 23 27))

;; 2
(mul-interval (make-interval 5 10) (make-interval -23 27))
(mul-interval-2 (make-interval 5 10) (make-interval -23 27))

;; 3
(mul-interval (make-interval 5 10) (make-interval -27 -23))
(mul-interval-2 (make-interval 5 10) (make-interval -27 -23))

;; 4
(mul-interval (make-interval -5 10) (make-interval 23 27))
(mul-interval-2 (make-interval -5 10) (make-interval 23 27))

;; 5 (has 4 cases, I am testing only one)
(mul-interval (make-interval -5 10) (make-interval -23 27))
(mul-interval-2 (make-interval -5 10) (make-interval -23 27))

;; 6
(mul-interval (make-interval -5 10) (make-interval -27 -23))
(mul-interval-2 (make-interval -5 10) (make-interval -27 -23))

;; 7
(mul-interval (make-interval -10 -5) (make-interval 23 27))
(mul-interval-2 (make-interval -10 -5) (make-interval 23 27))

;; 8
(mul-interval (make-interval -10 -5) (make-interval -27 23))
(mul-interval-2 (make-interval -10 -5) (make-interval -27 23))

;; 9
(mul-interval (make-interval -10 -5) (make-interval -27 -23))
(mul-interval-2 (make-interval -10 -5) (make-interval -27 -23))
