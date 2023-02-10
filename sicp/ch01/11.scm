;; Exercise 1.11.  A function f is defined by the rule that:
;; f(n) = n if n < 3 and
;; f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n > 3
;;
;; Write a procedure that computes
;; f by means of a recursive process. Write a procedure that computes f by means
;; of an iterative process.

;; recursive solution
(define (fr n)
  (cond ((< n 3) n)
        (else (+ (fr (- n 1))
                 (* 2 (fr (- n 2)))
                 (* 3 (fr (- n 3)))))))

;; iterative solution
(define (fi n)
  (define (iter fa fb fc x)
    (if (= x n)
        (+ fa (* 2 fb) (* 3 fc))
        (iter (+ fa (* 2 fb) (* 3 fc))
                fa
                fb
                (+ x 1))))
  (if (< n 3)
      n
      (iter 2 1 0 3)))
