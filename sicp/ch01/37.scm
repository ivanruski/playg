;; Exercise 1.37. a. An infinite continued fraction is an expression of the form
;;
;;          N1
;;f = ---------------
;;             N2
;;    D1 + ----------
;;               N3
;;         D2 -------
;;
;;            D3 ...
;;
;; As an example, one can show that the infinite continued fraction expansion
;; with the Ni and the Di all equal to 1 produces 1/𝜙, where 𝜙 is the golden
;; ratio (described in section 1.2.2). One way to approximate an infinite
;; continued fraction is to truncate the expansion after a given number of
;; terms. Such a truncation — a so called k-term finite continued fraction — has
;; the form
;;
;;          N1
;;f = ---------------
;;             N2
;;    D1 + ----------
;;               N3
;;         D2 -------
;;          .
;;           .
;;            .
;;             .
;;              Di ...
;;
;; Suppose that n and d are procedures of one argument (the term index i) that
;; return the Ni and Di of the terms of the continued fraction. Define a procedure
;; cont-frac such that evaluating (cont-frac n d k) computes the value of the
;; k-term finite continued fraction. Check your procedure by approximating 1/𝜙 using
;;
;; (cont-frac (lambda (i) 1.0)
;;            (lambda (i) 1.0)
;;            k)
;;
;; for successive values of k. How large must you make k in order to get an
;; approximation that is accurate to 4 decimal places?

(define (cont-frac n d k)
  (define (frac i)
    (if (= i k)
        (d i)
        (+ (d i)
           (/ (n (+ i 1))
              (frac (+ i 1))))))
  (/ (n 1)
     (frac 1)))

;; b. If your cont-frac procedure generates a recursive process, write one that
;; generates an iterative process. If it generates an iterative process, write one
;; that generates a recursive process.

(define (cont-frac-iter n d k)
  (define (iter result i)
    (if (= i 1)
        (/ (n i) result)
        (iter (+ (d (- i 1))
                 (/ (n i) result))
              (- i 1))))
  (iter (d k) k))

;; 11 iterations are needed for approximating 1/𝜙 to 4 decimal places

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           11)

(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                11)
