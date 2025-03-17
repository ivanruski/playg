;; Exercise 2.51. Define the below operation for painters. Below takes two
;; painters as arguments. The resulting painter, given a frame, draws with the
;; first painter in the bottom of the frame and with the second painter in the
;; top. Define below in two different ways -- first by writing a procedure that
;; is analogous to the beside procedure given above, and again in terms of
;; beside and suitable rotation operations (from exercise 2.50).

;; The exercise can be tested in drRacket
#lang sicp
(#%require sicp-pict)

(define (below p1 p2)
  (lambda (frame)
    ((transform-painter p1 (make-vect 0 0) (make-vect 1 0) (make-vect 0 0.5)) frame)
    ((transform-painter p2 (make-vect 0 0.5) (make-vect 1 0.5) (make-vect 0 1)) frame)))

;; in terms of beside and rotate
(define (rotate-counterclockwise-90-degrees painter)
  (transform-painter painter
                     (make-vect 1 0)
                     (make-vect 1 1)
                     (make-vect 0 0)))

(define (rotate-90-degrees painter)
  (transform-painter painter
                     (make-vect 0 1)
                     (make-vect 0 0)
                     (make-vect 1 1)))

(define (below2 p1 p2)
 (rotate-90-degrees (beside (rotate-counterclockwise-90-degrees p1)
                            (rotate-counterclockwise-90-degrees p2))))

(paint (below einstein einstein))
(paint (below2 einstein einstein))
