;; Exercise 2.10. Ben Bitdiddle, an expert systems programmer, looks over
;; Alyssa's shoulder and comments that it is not clear what it means to divide
;; by an interval that spans zero. Modify Alyssa's code to check for this
;; condition and to signal an error if it occurs.

(define (div-interval x y)
  (define (spans-zero? interval)
    (or (<= (lower-bound interval) 0)
         (>= 0 (upper-bound interval))))
  (if (spans-zero? y)
      (error "can't divide by an interval spanning zero" y)
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (make-interval a b) (cons a b))

(define (lower-bound a) (car a))
(define (upper-bound a) (cdr a))
