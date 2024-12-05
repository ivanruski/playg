;; Exercise 2.3. Implement a representation for rectangles in a plane. (Hint:
;; You may want to make use of exercise 2.2.) In terms of your constructors and
;; selectors, create procedures that compute the perimeter and the area of a
;; given rectangle. Now implement a different representation for rectangles. Can
;; you design your system with suitable abstraction barriers, so that the same
;; perimeter and area procedures will work using either representation?

;; from ex.2.2
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

(define (segment-length segment)
  (let ((start (start-segment segment))
        (end (end-segment segment)))
    (let ((x1 (x-point start))
          (y1 (y-point start))
          (x2 (x-point end))
          (y2 (y-point end)))
      (sqrt (+ (square (abs (- x2 x1)))
               (square (abs (- y2 y1))))))))
  

;; rep v1

(define (make-rectangle width-segment height-segment)
  (cons width-segment height-segment))

(define (width-rectangle rect)
  (segment-length (car rect)))

(define (height-rectangle rect)
  (segment-length (cdr rect)))

(define (perimeter-rectangle rect)
  (+ (* 2 (width-rectangle rect))
     (* 2 (height-rectangle rect))))

(define (area-rectangle rect)
  (* (width-rectangle rect)
     (height-rectangle rect)))

(define h1 (make-segment (make-point 0 0)
                         (make-point 0 5)))
(define w1 (make-segment (make-point 0 0)
                         (make-point 10 0)))

(define r1 (make-rectangle w1 h1))
(perimeter-rectangle r1)
(area-rectangle r1)

;; rep v2

(define (make-rectangle width height)
  (cons width height))

(define (width-rectangle rect) (car rect))
(define (height-rectangle rect) (cdr rect))

(define r2 (make-rectangle 5 10))
(perimeter-rectangle r2)
(area-rectangle r2)
