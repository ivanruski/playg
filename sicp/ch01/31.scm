;; Exercise 1.31
;; a. The sum procedure is only the simplest of a vast number of similar
;; abstractions that can be captured as higher-order procedures. Write an
;; analogous procedure called product that returns the product of the values of
;; a function at points over a given range. Show how to define factorial in
;; terms of product. Also use product to compute approximations of π using the
;; formula:
;;
;; π   2·4·4·6·6·8…
;; ─ = ────────────
;; 4   3·3·5·5·7·7…
;;
;; b. If your product procedure generates a recursive process, write one that
;; generates an iterative process. If it generates an iterative process, write
;; one that generates a recursive process.

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a)  next b))))

(define (factorial n)
  (define (identity a) a)
  (define (inc a) (+ a 1))
  (product identity 1 inc n))

(define (pi-approx n)
  (define (next-odd n)
    (if (odd? n)
        (+ n 2)
        (+ n 1)))
  (define (next-even n)
    (if (even? n)
        (+ n 2)
        (+ n 1)))
  (define (term k)
    (/ (next-even k)
       (next-odd k)))
  (* 4 (product-iter term 1. inc n)))

;; b.

(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a)
              (* (term a) result))))
  (iter a 1))
