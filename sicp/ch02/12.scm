;; Exercise 2.12. Define a constructor make-center-percent that takes a center
;; and a percentage tolerance and produces the desired interval. You must also
;; define a selector percent that produces the percentage tolerance for a given
;; interval. The center selector is the same as the one shown below.

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))


;; I will re-use make-center-width
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))


(define (make-center-percent center percent-tolerance)
  (make-center-width center (* center percent-tolerance)))

(define (percent interval)
  (let ((c (center interval))
        (u (upper-bound interval)))
    (/ (- u c) c)))


(define (make-interval a b) (cons a b))

(define (lower-bound a) (car a))
(define (upper-bound a) (cdr a))
