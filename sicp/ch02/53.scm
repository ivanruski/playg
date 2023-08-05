;; Exercise 2.53. What would the interpreter print in response to evaluating
;; each of the following expressions?

(list 'a 'b 'c)
;Value: (a b c)

(list (list 'george))
;Value: ((george))

(cdr '((x1 x2) (y1 y2)))
;Value: (y1 y2)
;; I got this wrong actually it is ((y1 y2))

(cadr '((x1 x2) (y1 y2)))
;Value: y1
;; I got this wrong actually it is (y1 y2)

(pair? (car '(a short list)))
;Value: #f

(memq 'red '((red shoes) (blue socks)))
;Value: #f

(memq 'red '(red shoes blue socks))
;Value: #t
;; I got this wrong actually it is (red shoes blue socks)
