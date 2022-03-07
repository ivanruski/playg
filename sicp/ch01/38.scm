;; Exercise 1.38. In 1737, the Swiss mathematician Leonhard Euler published a
;; memoir De Fractionibus Continuis, which included a continued fraction expansion
;; for e - 2, where e is the base of the natural logarithms. In this fraction, the
;; Ni are all 1, and the Di are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, ....
;; Write a program that uses your cont-frac procedure from exercise 1.37 to
;; approximate e, based on Euler's expansion.

(define (cont-frac-iter n d k)
  (define (iter result i)
    (if (= i 1)
        (/ (n i) result)
        (iter (+ (d (- i 1))
                 (/ (n i) result))
              (- i 1))))
  (iter (d k) k))

;; The Di term is calculated by using the fact that sequence is increasing
;; with 2 on every 3rd i strating from i = 2

(define e-2 (cont-frac-iter (lambda (i) 1.0)
                            (lambda (i)
                              ;; redefine i for a lack of a better name
                              (let ((i (- i 2)))
                                (if (= (remainder i 3) 0)
                                    (+ 2 (* 2 (/ i 3)))
                                    1)))
                            20))

(= (+ e-2 2) (exp 1))
