;; Exercise 2.26. Suppose we define x and y to be two lists:

(define x (list 1 2 3))
(define y (list 4 5 6))

;; What result is printed by the interpreter in response to evaluating
;; each of the following expressions:

(append x y)

(cons x y)

(list x y)

;; The result from (append x y) should be:
;; (1 2 3 4 5 6)

;; The result from (cons x y) should be:
;; ((1 2 3) 4 5 6)
;; My answer was: ((1 2 3) . (4 5 6)) which is the same.

;; The result from (list x y) should be:
;; ((1 2 3) (4 5 6))
