;; Exercise 3.29.  Another way to construct an or-gate is as a compound digital
;; logic device, built from and-gates and inverters. Define a procedure or-gate
;; that accomplishes this. What is the delay time of the or-gate in terms of
;; and-gate-delay and inverter-delay?

;; (inverter)
;;   |\
;; --| |*------+   (and)
;;   |/        |   |\        |\
;;             +---| |-------| |*---------
;;   |\        |   |/        |/
;; --| |*------+
;;   |/
;;
(define (or-gate a1 a2 output)
  (let ((a1-inverted-output (make-wire))
        (a2-inverted-output (make-wire))
        (and-inverted-output (make-wire)))
    (inverter a1 a1-inverted-output)
    (inverter a2 a2-inverted-output)
    (and-gate a1-inverted-output
              a2-inverted-output
              and-inverted-output)
    (inverter and-inverted-output
              output)
    'ok))

;; The delay time of the or-gate is: inverter-delay + and-delay + inverter-delay.
