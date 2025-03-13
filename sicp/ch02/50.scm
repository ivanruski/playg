;; Exercise 2.50. Define the transformation flip-horiz, which flips painters
;; horizontally, and transformations that rotate painters counterclockwise by
;; 180 degrees and 270 degrees.

;; The exercise can be tested in drRacket
#lang sicp
(#%require sicp-pict)

;; flip-horiz
(define (flip-horizz painter)
  (transform-painter painter
                     (make-vect 1 0)
                     (make-vect 0 0)
                     (make-vect 1 1)))

;; rotate counterclockwise by 180 degress
(define (rotate-counterclockwise-180-degrees painter)
  (transform-painter painter
                     (make-vect 1 1)
                     (make-vect 0 1)
                     (make-vect 1 0)))

;; 270
(define (rotate-counterclockwise-270-degrees painter)
  (transform-painter painter
                     (make-vect 0 1)
                     (make-vect 0 0)
                     (make-vect 1 1)))
