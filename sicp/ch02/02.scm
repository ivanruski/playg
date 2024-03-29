;; Exercise 2.2. Consider the problem of representing line segments in a
;; plane. Each segment is represented as a pair of points: a starting point and an
;; ending point. Define a constructor make-segment and selectors start-segment and
;; end-segment that define the representation of segments in terms of
;; points. Furthermore, a point can be represented as a pair of numbers: the x
;; coordinate and the y coordinate. Accordingly, specify a constructor make-point
;; and selectors x-point and y-point that define this representation. Finally,
;; using your selectors and constructors, define a procedure midpoint-segment that
;; takes a line segment as argument and returns its midpoint (the point whose
;; coordinates are the average of the coordinates of the endpoints). To try your
;; procedures, you'll need a way to print points:

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;; segments

(define (make-segment start-point end-point)
  (cons start-point end-point))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

(define (midpoint-segment segment)
  (point-avg (start-segment segment)
             (end-segment segment)))

;; points

(define (make-point x y)
  (cons x y))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (point-avg point-a point-b)
  (make-point (average (x-point point-a)
                       (x-point point-b))
              (average (y-point point-a)
                       (y-point point-b))))

;;

(define (average a b) (/ (+ a b) 2))
