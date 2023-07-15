;; Exercise 2.51. Define the below operation for painters. Below takes two
;; painters as arguments. The resulting painter, given a frame, draws with the
;; first painter in the bottom of the frame and with the second painter in the
;; top. Define below in two different ways -- first by writing a procedure that
;; is analogous to the beside procedure given above, and again in terms of
;; beside and suitable rotation operations (from exercise 2.50).
;;
;; NOTE: The painters can be tested in DrRacket.
;; https://docs.racket-lang.org/sicp-manual/SICP_Picture_Language.html

(define (below-v1 painter1 painter2)
  (lambda (frame)
    ((transform-painter painter1
                        (make-vect 0.0 0.0)
                        (make-vect 1.0 0.0)
                        (make-vect 0.0 0.5))
     frame)
    ((transform-painter painter2
                        (make-vect 0.0 0.5)
                        (make-vect 1.0 0.5)
                        (make-vect 0.0 1.0))
     frame)))

(define (below-v2 painter1 painter2)
  (rotate-270-counterclockwise
  (beside (rotate-90-counterclockwise painter2)
          (rotate-90-counterclockwise painter1))))

(paint (below-v1 einstein mark-of-zorro))
(paint (below-v2 einstein mark-of-zorro))    
