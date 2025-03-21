;; Exercise 2.45. Right-split and up-split can be expressed as instances of a
;; general splitting operation. Define a procedure split with the property that
;; evaluating
;;
;; (define right-split (split beside below))
;; (define up-split (split below beside))
;; 
;; produces procedures right-split and up-split with the same behaviors as the
;; ones already defined.

(define (split p1 p2)
  (lambda (painter)
    (p1 painter (p2 painter painter))))

(define right-split (split beside below))
(define up-split (split below beside))

(paint (right-split einstein))
(paint (up-split einstein))
