;; Exercise 3.19. Redo exercise 3.18 using an algorithm that takes only a
;; constant amount of space. (This requires a very clever idea.)

(define (list-cyclic? l)
  (define (cddr? l)
    (and (not (null? l))
         (not (null? (cdr l)))
         (not (null? (cddr l)))))

  ;; The idea is to traverse the list with 2 pointers. The first moves one cdr
  ;; each cycle and the second moves two cdrs each cycle. If there is a cycle
  ;; they will overlap at some point.
  (define (cyclic? one two)
    (cond ((eq? one two) #t)
          ((cddr? two) (cyclic? (cdr one) (cddr two)))
          (else #f)))

  (if (cddr? l)
      (cyclic? l (cddr l))
      #f))

;; tests

(list-cyclic? '())

(list-cyclic? (list 1))

(list-cyclic? (list 1 2 3))

(list-cyclic? (cons one-pair (cons 2 one-pair)))

(list-cyclic? (cons z z))

(list-cyclic? (make-cycle (list 1 2 3)))

(list-cyclic? (append (list 1 2) (make-cycle (list 1 2 3))))
