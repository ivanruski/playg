;; Exercise 2.5. Show that we can represent pairs of nonnegative integers using
;; only numbers and arithmetic operations if we represent the pair a and b as the
;; integer that is the product 2^a*3^b. Give the corresponding definitions of the
;; procedures cons, car, and cdr.

(define (ncons a b)
  (* (expt 2 a) (expt 3 b)))

(define (ncar z)
  (define (find-a pow)
    (let ((raised (expt 2 pow)))
      (if (is-x-power-of-y 3 (/ z raised))
          pow
          (find-a (+ pow 1)))))
  (find-a 0))
    

(define (ncdr z)
  (define (find-b pow)
    (let ((raised (expt 3 pow)))
      (if (is-x-power-of-y 2 (/ z raised))
          pow
          (find-b (+ pow 1)))))
  (find-b 0))

(define (is-x-power-of-y x y)
  (define (iter pow)
    (let ((raised (expt x pow)))
      (cond ((= x 0) (or (= y 1) (= y 0)))
            ((= x 1) (= y 1))
            ((= y raised) true)
            ((< y raised) false)
            (else (iter (+ pow 1))))))
  (iter 0))


(ncar (ncons 20 30))
(ncar (ncons 3 (ncons 2 1)))
(ncar (ncdr (ncons 3 (ncons 2 1))))
(ncdr (ncdr (ncons 3 (ncons 2 1))))
