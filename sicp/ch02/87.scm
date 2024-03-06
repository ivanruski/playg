;; Exercise 2.87. Install =zero? for polynomials in the generic arithmetic
;; package. This will allow adjoin-term to work for polynomials with
;; coefficients that are themselves polynomials.

;; Solution(added in the generic-arithmetic.scm):
(define (=zero-poly? p)
  (define (=zero-terms? terms)
    (or (empty-termlist? terms)
        (and (=zero? (first-term terms))
             (=zero-terms? (rest-terms terms)))))

  (zero-terms? (term-list p)))

(=zero? (make-polynomial 'x '((3 3)
                              (2 2)
                              (1 1)
                              (0 3))))

(=zero? (make-polynomial 'x '((3 3)
                              (2 0)
                              (1 1)
                              (0 3))))

(=zero? (make-polynomial 'x '((3 0)
                              (2 0)
                              (1 0)
                              (0 0))))

(=zero? (make-polynomial 'x '((0 0))))
(=zero? (make-polynomial 'x '()))

(=zero? (make-polynomial 'x (list (list 3 (make-complex-from-real-imag 0 0)))))

(=zero? (make-polynomial 'x (list (list 3 (make-complex-from-real-imag 0 0))
                                  (list 2 (make-rational 0 3)))))
