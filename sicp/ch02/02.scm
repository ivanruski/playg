;; Exercise 2.2. Consider the problem of representing line segments in a
;; plane. Each segment is represented as a pair of points: a starting point and
;; an ending point. Define a constructor make-segment and selectors
;; start-segment and end-segment that define the representation of segments in
;; terms of points. Furthermore, a point can be represented as a pair of
;; numbers: the x coordinate and the y coordinate. Accordingly, specify a
;; constructor make-point and selectors x-point and y-point that define this
;; representation. Finally, using your selectors and constructors, define a
;; procedure midpoint-segment that takes a line segment as argument and returns
;; its midpoint (the point whose coordinates are the average of the coordinates
;; of the endpoints). To try your procedures, you'll need a way to print points:

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;; make-point and selectors x-point and y-point
(define (make-point x y)
  (cons x y))

(define (x-point p) (car p))

(define (y-point p) (cdr p))

;; make-segment and selectors start-segment and end-segment
(define (make-segment start-point end-point)
  (cons start-point end-point))

(define (start-segment segment) (car segment))

(define (end-segment segment) (cdr segment))

(define (midpoint-segment segment)
  (let ((start (start-segment segment))
        (end (end-segment segment)))
    (let ((x1 (x-point start))
          (y1 (y-point start))
          (x2 (x-point end))
          (y2 (y-point end)))
      (make-point (/ (+ x1 x2) 2.)
                  (/ (+ y1 y2) 2.)))))


(define p1 (make-point 4 2))
(define p2 (make-point 6 4))
(define seg (make-segment p1 p2))
(midpoint-segment seg)

(define p1 (make-point 5 3))
(define p2 (make-point 8 8))
(define seg (make-segment p1 p2))
(midpoint-segment seg)
