;; Exercise 2.39. Complete the following definitions of reverse (exercise
;; 2.18) in terms of fold-right and fold-left from exercise 2.38:

(define (reverse sequence)
  (fold-right (lambda (x y)
                (let ((lx (list x)))
                  (if (null? y)
                      lx
                      (append y lx)))) '() sequence))

(define (reverse sequence)
  (fold-left (lambda (x y)
               (append (list y) x)) '() sequence))
