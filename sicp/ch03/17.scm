;; Exercise 3.17. Devise a correct version of the count-pairs procedure of
;; exercise 3.16 that returns the number of distinct pairs in any
;; structure. (Hint: Traverse the structure, maintaining an auxiliary data
;; structure that is used to keep track of which pairs have already been
;; counted.)

(define (count-pairs x)
  (define visited-pairs '())

  (define (count x)
    (cond ((not (pair? x)) 0)
          ((find (lambda (p) (eq? x p)) visited-pairs) 0)
          (else
           (set! visited-pairs (cons x visited-pairs))
           (+ 1
              (count (car x))
              (count (cdr x))))))
  (count x))

;; The lists are taken from 3.16

(count-pairs (list 1 2 3))

(define one-pair (list 'x))
(count-pairs (cons one-pair (cons 2 one-pair)))

(define z (cons one-pair one-pair))
(count-pairs (cons z z))

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(count-pairs (make-cycle (list 1 2 3)))
