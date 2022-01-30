;; Exercise 1.20. The process that a procedure generates is of course dependent on
;; the rules used by the interpreter. As an example, consider the iterative gcd
;; procedure given above. Suppose we were to interpret this procedure using
;; normal-order evaluation, as discussed in section 1.1.5. (The
;; normal-order-evaluation rule for if is described in exercise 1.5.) Using the
;; substitution method (for normal order), illustrate the process generated in
;; evaluating (gcd 206 40) and indicate the remainder operations that are actually
;; performed. How many remainder operations are actually performed in the
;; normal-order evaluation of (gcd 206 40)? In the applicative-order evaluation?

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; Normal order evaluation
;;
;; (gcd 206 40)
;; 
;; a = 40, b = (remanider 206 40)
;; +1 remiander - b is evaluated in the if = 6
;;
;; (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
;;
;; 
;; a = (remainder 206 40), b = (remainder 40 (remiander 206 40))
;; +2 remainder - b is evaluated in the if = 4
;;
;; (gcd (remainder 40 (remainder 206 40))
;;      (remainder (remainder 206 40)
;;                 (remainder 40 (remainder 206 40))))
;;
;; 
;; a = (remainder 40 (remainder 206 40)),
;; b = (remainder (remainder 206 40)
;;                (remainder 40 (remiander 206 40)))
;; +4 remainder - b is evaluated in the if = 2
;; 
;; (gcd (remainder (remainder 206 40)
;;                 (remainder 40 (remiander 206 40)))
;;      (remainder (remainder 40 (remainder 206 40))
;;                 (remainder (remainder 206 40)
;;                            (remainder 40 (remiander 206 40)))))
;;
;; 
;; a = (remainder (remainder 206 40)
;;                (remainder 40 (remiander 206 40)))
;; b = (remainder (remainder 40 (remainder 206 40))
;;                (remainder (remainder 206 40)
;;                           (remainder 40 (remiander 206 40))))
;; +7 remainder - b is evaluated in the if = 0
;; +4 remainder - b = 0 and a is evaluated
;; 
;; remainder function is evaluated 18 times
;;
;;
;; Applicative order evaluation
;; (gcd 206 40)
;; (gcd 40 (remainder 206 40))
;; +1 remainder = 6
;; (gcd 6 (remainder 40 6))
;; +1 remainder = 4
;; (gcd 4 (remainder 6 4))
;; + 1 remainder = 2
;; (gcd 2 (remainder 4 2))
;; + 1 remainder = 0
;; 2
;;
;; remainder function is evaluated 4 times
