;; Exercise 2.3. Implement a representation for rectangles in a plane. (Hint:
;; You may want to make use of exercise 2.2.) In terms of your constructors and
;; selectors, create procedures that compute the perimeter and the area of a
;; given rectangle. Now implement a different representation for rectangles. Can
;; you design your system with suitable abstraction barriers, so that the same
;; perimeter and area procedures will work using either representation?

(define (rectangle-perimeter rect)
  (+ (* 2 (rectangle-height rect))
     (* 2 (rectangle-width rect))))

(define (rectangle-area rect)
  (* (rectangle-height rect)
     (rectangle-width rect)))

;; either
(define (make-rectangle upper-left-point
                        upper-right-point
                        lower-right-point
                        lower-left-point)
  (cons upper-left-point
        (cons upper-right-point
              (cons lower-right-point
                    lower-left-point))))

(define (rectangle-height rect)
  (point-dist (car rect) (car (cdr rect))))

(define (rectangle-width rect)
  ;; take upper and lower point on the same side
  ;; upper-right and lower-right
  (point-dist (car (cdr rect))
              (car (cdr (cdr rect)))))

;; or
(define (make-rectangle width height)
  (cons width height))

(define (rectangle-height rect)
  (segment-length (cdr rect)))

(define (rectangle-width rect)
  (segment-length (car rect)))

;; Code from from exercise 2.2

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

(define (segment-length segment)
  (point-dist (start-segment segment)
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

(define (point-dist point-a point-b)
  (sqrt (+ (square (- (x-point point-b)
                      (x-point point-a)))
           (square (- (y-point point-b)
                      (y-point point-a))))))

;;

(define (average a b) (/ (+ a b) 2))
