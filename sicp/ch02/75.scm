;; Exercise 2.75. Implement the constructor make-from-mag-ang in message-passing
;; style. This procedure should be analogous to the make-from-real-imag
;; procedure given above.

(define (make-from-mag-ang r a)
  (define (dispatch op)
    (cond ((eq? op 'magnitude) r)
          ((eq? op 'angle) a)
          ((eq? op 'real-part) (* r (cos a)))
          ((eq? op 'imag-part) (* r (sin a)))
          (else
           (error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
  dispatch)
