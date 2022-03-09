;; Exercise 1.43. If f is a numerical function and n is a positive integer, then
;; we can form the nth repeated application of f, which is defined to be the
;; function whose value at x is f(f(...(f(x))...)). For example, if f is the
;; function x -> x + 1, then the nth repeated application of f is the function
;; x -> x + n. If f is the operation of squaring a number, then the nth repeated
;; application of f is the function that raises its argument to the 2^nth
;; power. Write a procedure that takes as inputs a procedure that computes f and a
;; positive integer n and returns the procedure that computes the nth repeated
;; application of f. Your procedure should be able to be used as follows: 

;; ((repeated square 2) 5)
;; Vavlue: 625

;; Hint: You may find it convenient to use compose from exercise 1.42.

(define (repeated f n)
  (define (apply-iter i f result)
    (if (= i n)
        result
        (apply-iter (+ i 1)
                    f
                    (f result))))
  (lambda (x)
    (apply-iter 1 f (f x))))

((repeated square 3) 5)

;; x -> x + 1 applied n times should be x -> x + n
;; x -> x + 1 applied 5 times should be x -> x + 5
((repeated (lambda (x) (+ x 1)) 5) 5)

