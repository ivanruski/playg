;; Exercise 2.35. Redefine count-leaves from section 2.2.2 as an
;; accumulation:

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (count-leaves-old x)
  (cond ((null? x) 0)  
        ((not (pair? x)) 1)
        (else (+ (count-leaves-old (car x))
                 (count-leaves-old (cdr x))))))

(define (count-leaves t)
  (accumulate + 0
              (map (lambda (node)
                     (if (not (pair? node))
                         1
                         (count-leaves node)))
                   t)))

(define x (cons (list 1 2) (list 3 4)))

(count-leaves-old x)
(count-leaves-old (list x x))

(count-leaves x)
(count-leaves (list x x))
