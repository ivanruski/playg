;; This file is to play around with the transformations which are happening when
;; we are transforming one frame to another.
;;
;; We are doing change of basis like in the video below, but we are also
;; changing our origin.
;;
;; https://www.youtube.com/watch?v=P2LTAUO1TdA

;; Define relevant functions
(define (make-vect x y) (cons x y))

(define (xcor-vect v) (car v))

(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1)
                (xcor-vect v2))
             (+ (ycor-vect v1)
                (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1)
                (xcor-vect v2))
             (- (ycor-vect v1)
                (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (caddr frame))
;;

(define the-frame
  (make-frame (make-vect 0.0 0.0)
              (make-vect 1.0 0.0)
              (make-vect 0.0 1.0)))

(define 45f
  (make-frame (make-vect 0.5 0.0)
              (make-vect 1.0 0.5)
              (make-vect 0.0 0.5)))


(define (frame-coord-map frame)
  (lambda (v)
    (add-vect (origin-frame frame)
              (add-vect (scale-vect (xcor-vect v)
                                    (edge1-frame frame))
                        (scale-vect (ycor-vect v)
                                    (edge2-frame frame))))))

(define (transform origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (make-frame new-origin
                    (sub-vect (m corner1) new-origin)
                    (sub-vect (m corner2) new-origin))))))

(define f90 ((transform
            (make-vect 1.0 0.0)
            (make-vect 1.0 1.0)
            (make-vect 0.0 0.0))
             the-frame))

(define f45 ((transform
            (make-vect 0.5 0.0)
            (make-vect 1.0 0.5)
            (make-vect 0.0 0.5))
           the-frame))

((frame-coord-map f90) (make-vect 0.2 0.8))
((frame-coord-map f90) (make-vect 1 1))
((frame-coord-map f45) (make-vect 1 1))
