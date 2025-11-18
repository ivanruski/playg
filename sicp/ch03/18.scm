;; Exercise 3.18. Write a procedure that examines a list and determines whether
;; it contains a cycle, that is, whether a program that tried to find the end of
;; the list by taking successive cdrs would go into an infinite loop. Exercise
;; 3.13 constructed such lists.

(define (list-cyclic? l)
  (define visited-pairs '())

  (define (visited? p)
    (find (lambda (x) (eq? x p)) visited-pairs))

  (define (mark-visited p)
    (set! visited-pairs (cons p visited-pairs)))

  (define (cycle? l)
    (cond ((null? l) #f)
          ((visited? (car l)) #t)
          (else
           (mark-visited (car l))
           (cycle? (cdr l)))))

  (cycle? l))

;; tests
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define one-pair (list 'x))
(define z (cons one-pair one-pair))

(list-cyclic? '())

(list-cyclic? (list 1))

(list-cyclic? (list 1 2 3))

(list-cyclic? (cons one-pair (cons 2 one-pair)))

(list-cyclic? (cons z z))

(list-cyclic? (make-cycle (list 1 2 3)))

(list-cyclic? (append (list 1 2) (make-cycle (list 1 2 3))))
