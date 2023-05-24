;; Exercise 2.49. Use segments->painter to define the following primitive
;; painters:
;; 
;; a. The painter that draws the outline of the designated frame.
;; 
;; b. The painter that draws an ``X'' by connecting opposite corners of the
;; frame.
;; 
;; c. The painter that draws a diamond shape by connecting the midpoints of the
;; sides of the frame.
;; 
;; d. The wave painter.
;;
;; NOTE: The painters can be tested in DrRacket.
;; https://docs.racket-lang.org/sicp-manual/SICP_Picture_Language.html

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))

;; a. The painter that draws the outline of the designated frame.

(define pa
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 1 0))
                           (make-segment (make-vect 1 0) (make-vect 1 1))
                           (make-segment (make-vect 0 1) (make-vect 1 1))
                           (make-segment (make-vect 0 0) (make-vect 0 1)))))

;; b. The painter that draws an ``X'' by connecting opposite corners of the
;; frame.

(define pb
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 1 1))
                           (make-segment (make-vect 0 1) (make-vect 1 0)))))

;; c. The painter that draws a diamond shape by connecting the midpoints of the
;; sides of the frame.

(define pc
  (segments->painter (list (make-segment (make-vect 0 0.5) (make-vect 0.5 1))
                           (make-segment (make-vect 0.5 1) (make-vect 1 0.5))
                           (make-segment (make-vect 1 0.5) (make-vect 0.5 0))
                           (make-segment (make-vect 0.5 0) (make-vect 0 0.5)))))

;; d. The wave painter.

(define wave
  (segments->painter '())) ;; list consisting of 17 segments(don't know the exact coords)
