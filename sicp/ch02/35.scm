;; Exercise 2.35. Redefine count-leaves from section 2.2.2 as an accumulation:

(define (accumulate fn zero-value sequence)
  (if (null? sequence)
      zero-value
      (fn (car sequence)
          (accumulate fn zero-value (cdr sequence)))))

(define (count-leaves t)
  (accumulate + 0
              (map (lambda (x)
                     (if (pair? x)
                         (count-leaves x)
                         1))
                   t)))

(define x '((1 2) 3 4))
(define y '(((1 2 3) 4) ((5 6) (7 8))))
(define z '(1 2 3))

(count-leaves x)
(count-leaves (cons x x))
(count-leaves y)
(count-leaves z)
