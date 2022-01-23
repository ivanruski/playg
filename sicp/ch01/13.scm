;; Exercise 1.13.  Prove that Fib(n) is the closest integer to phi^n/sqrt(5),
;; where phi = (1 + sqrt(5))/2. Hint: Let psi = (1 - (sqrt(5))/2. Use induction
;; and the definition of the Fibonacci numbers (see section 1.2.2) to prove
;; that Fib(n) = (phi^n - psi^n)/sqrt(5)
;;
;; phi = (1 + sqrt(5))/2
;; psy = (1 - sqrt(5))/2
;; 
;; Proof of Fib(n) = (phi^n - psi^n)/sqrt(5)
;;
;; Base: n = 0
;; Fib(0) = 0
;; (phi^n - psi^n)/sqrt(5) = 0
;;
;; Induction step:
;; Fib(n+1) = Fib(n) + Fib(n-1)
;;
;; (phi^n+1 - psi^n+1)/sqrt(5) = (phi^n - psi^n)/sqrt(5) + (phi^n-1 - psi^n-1)/sqrt(5)
;; We have to tranform the left hand-side and right hand-side to see that
;; they are equal.
;;
;;
;; Proof of Fib(n) is the closest integer to phi^n/sqrt(5)
;; Fib(n) - phi^n/sqrt(5) = -psi^n/sqrt(5)
;;
;; We have to proof that psi^n/sqrt(5) is less than 0.5 for any n >= 0
;; For n = 0, 1/sqrt(5)     ≈ 0.4472135955
;; For n = 1, psi/sqrt(5)   ≈ -0.27639320225
;; For n = 2, psi^2/sqrt(5) ≈ 0.0.17082039325
;;
;; Since psi ≈ -0.61803398875, psi^n gets smaller and smaller as n increases
