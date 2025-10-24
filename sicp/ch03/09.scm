;; Exercise 3.9. In section 1.2.1 we used the substitution model to analyze two
;; procedures for computing factorials, a recursive version

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

;; and an iterative version

(define (factorial-i n)
  (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))

;; Show the environment structures created by evaluating (factorial 6) using
;; each version of the factorial procedure.

;; Evaluating the recurisve factorial
;;
;; (fact 6)         (fact 5)         (fact 4)         (fact 3)         (fact 2)         (fact 1)
;;
;; E1 -> |------|   E2 -> |------|   E3 -> |------|   E4 -> |------|   E5 -> |------|   E6 -> |------|
;;       | n: 6 |         | n: 5 |         | n: 4 |         | n: 3 |         | n: 2 |         | n: 6 |
;;       |------|         |------|         |------|         |------|         |------|         |------|
;;
;; (* n (fact 5)    (* n (fact 4)    (* n (fact 3)    (* n (fact 2)    (* n (fact 1)    1

;; Evaluating the iterative factorial
;;
;; (fact 6)            (fact-iter 1 1 6)   (fact-iter 1 2 6)   (fact-iter 2 3 6)   (fact-iter 6 4 6)   (fact-iter 24 5 6)   (fact-iter 120 6 6)    (fact-iter 720 7 6)
;;
;; E1 -> |------|      E2 -> |------|      E3 -> |------|      E4 -> |------|      E5 -> |------|      E6 -> |-------|      E7 -> |--------|       E8 -> |--------|
;;       | n: 6 |            | p: 1 |            | p: 1 |            | p: 2 |            | p: 6 |            | p: 24 |            | p: 120 |             | p: 720 |
;;       |      |            | c: 1 |            | c: 2 |            | c: 3 |            | c: 4 |            | c: 5  |            | c: 6   |             | c: 7   |
;;       |      |            | m: 6 |            | m: 6 |            | m: 6 |            | m: 6 |            | m: 6  |            | m: 6   |             | m: 6   |
;;       |------|            |------|            |------|            |------|            |------|            |-------|            |--------|             |--------|
;;
;;
;;
;; (fact-iter 1 1 6) (fact-iter 1 2 6)     (fact-iter 2 3 6)   (fact-iter 6 4 6)   (fact-iter 24 5 6)  (fact-iter 120 6 6)  (fact-iter 720 7 6)     720
