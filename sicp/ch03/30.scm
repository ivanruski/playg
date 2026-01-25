;; Exercise 3.30. Figure 3.27 shows a ripple-carry adder formed by stringing
;; together n full-adders. This is the simplest form of parallel adder for
;; adding two n-bit binary numbers. The inputs A1, A2, A3, ..., An and B1, B2,
;; B3, ..., Bn are the two binary numbers to be added (each Ak and Bk is a 0 or
;; a 1). The circuit generates S1, S2, S3, ..., Sn, the n bits of the sum, and
;; C, the carry from the addition. Write a procedure ripple-carry-adder that
;; generates this circuit. The procedure should take as arguments three lists of
;; n wires each -- the Ak, the Bk, and the Sk -- and also another wire C. The
;; major drawback of the ripple-carry adder is the need to wait for the carry
;; signals to propagate. What is the delay needed to obtain the complete output
;; from an n-bit ripple-carry adder, expressed in terms of the delays for
;; and-gates, or-gates, and inverters?

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (ripple-carry-adder As Bs Ss c)
  (define (add-iter As Bs Ss c-in)
    (if (null? As)
        (set-signal! c (get-signal c-in))
        (let ((c-out (make-wire)))
          (full-adder (car As)
                      (car Bs)
                      c-in
                      (car Ss)
                      c-out)
          (add-iter (cdr As)
                    (cdr Bs)
                    (car Ss)
                    c-out))))

  (let ((c-in (make-wire)))
    (set-signal! c-in 0)
    (add-iter (reverse As)
              (reverse Bs)
              (reverse Ss)
              c-in)))

;; What is the delay needed to obtain the complete output from an n-bit
;; ripple-carry adder, expressed in terms of the delays for and-gates, or-gates,
;; and inverters?

;;;; The delay for adding 1-bit numbers are as follows:
;;
;; The delays in the half-adders are as follows:
;;
;; For the s bit, the delay is: max(or-delay, inverter-delay + and-delay) + and-delay
(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d) ;; d is here
    (and-gate a b c) ;; e depends on c
    (inverter c e) ;; e is here
    (and-gate d e s) ;; in order to get s, we need input from d and e
    'ok))

;; For the c, the delay is: and-delay
;;
;; The dealys in the full-adder are as follows:
;;
;; The sum delay is: [max(or-delay, inverter-delay + and-delay) + and-delay] + [max(or-delay, inverter-delay + and-delay) + and-delay]
;; (the first [<sum>] because we need the result from 's' and the second [<sum>] to get 'sum'
;;
;; For the c-out the delay is: and-delay + or-delay
;;
;;;; The delay for adding n-bit numbers are as follows:
;;
;; The final s delay is: (n - 1) * (and-delay + or-delay) (we need the second to last c-out) + the sum delay from above
;;
;; The final c-out delay is: n * (and-delay + or-delay)
