;; Exercise 2.53. What would the interpreter print in response to evaluating
;; each of the following expressions?

(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(list 'a 'b 'c)
;Value: (a b c)

(list (list 'george))
;Value: ((george))

(cdr '((x1 x2) (y1 y2)))
;Value: (y1 y2) -- I got this wrong
;Value: ((y1 y2))

(cadr '((x1 x2) (y1 y2)))
;Value: (y1 y2)

(pair? (car '(a short list)))
;Value: #f

(memq 'red '((red shoes) (blue socks)))
;Value: #f

(memq 'red '(red shoes blue socks))
;Value: '(red shoes blue socks)
