;; Exercise 2.50. Define the transformation flip-horiz, which flips painters
;; horizontally, and transformations that rotate painters counterclockwise by
;; 180 degrees and 270 degrees.
;;
;; NOTE: The painters can be tested in DrRacket.
;; https://docs.racket-lang.org/sicp-manual/SICP_Picture_Language.html

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate-180-counterclockwise painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 0.0)))

(define (rotate-270-counterclockwise painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

;; or
(define (rotate-90-counterclockwise painter)
   (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (rotate-180-counterclockwise painter)
  (rotate-90-counterclockwise (rotate-90-counterclockwise painter)))

(define (rotate-270-counterclockwise painter)
  (rotate-180-counterclockwise (rotate-90-counterclockwise painter)))

(paint (flip-horiz einstein))
(paint (rotate-180-counterclockwise einstein))
(paint (rotate-270-counterclockwise einstein))
