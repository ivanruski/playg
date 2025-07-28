;; Exercise 2.90. Suppose we want to have a polynomial system that is efficient
;; for both sparse and dense polynomials. One way to do this is to allow both
;; kinds of term-list representations in our system. The situation is analogous
;; to the complex-number example of section 2.4, where we allowed both
;; rectangular and polar representations. To do this we must distinguish
;; different types of term lists and make the operations on term lists
;; generic. Redesign the polynomial system to implement this
;; generalization. This is a major effort, not a local change.

;; dense & sparse term list packages are absolutely the same, except for
;; adjoin-term and first-term were refactored for dense-term-list.
;;
;; Refactoring the 2 procs allowed me to reuse everything else.

(load "generic-arithmetic-used-in-2.5.3.scm")

(define (install-sparse-term-list-package)

  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1)) (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 (add-terms (rest-terms L1) L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 (add-terms L1 (rest-terms L2))))
                   (else
                    (adjoin-term
                     (make-term (order t1)
                                (add (coeff t1) (coeff t2)))
                     (add-terms (rest-terms L1)
                                (rest-terms L2)))))))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term
           (make-term (+ (order t1) (order t2))
                      (mul (coeff t1) (coeff t2)))
           (mul-term-by-all-terms t1 (rest-terms L))))))

  (define (=zero-term-list? L)
    (if (empty-termlist? L)
        #t
        (let ((t (first-term L))
              (R (rest-terms L)))
          (and (=zero? (coeff t))
               (=zero-term-list? R)))))

  (define (negate-term-list L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t (first-term L)))
          (adjoin-term
           (make-term (order t)
                      (negate (coeff t)))
           (negate-term-list (rest-terms L))))))

  (define (sub-terms L1 L2)
    (add-terms L1 (negate-term-list L2)))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'sparse-term-list p))

  (put 'add '(sparse-term-list sparse-term-list)
       (lambda (l1 l2) (tag (add-terms l1 l2))))

  (put 'mul '(sparse-term-list sparse-term-list)
       (lambda (l1 l2) (tag (mul-terms l1 l2))))

  (put '=zero? '(sparse-term-list) =zero-term-list?)

  (put 'negate '(sparse-term-list)
       (lambda (l) (tag (negate-term-list l))))

  (put 'sub '(sparse-term-list sparse-term-list)
       (lambda (l1 l2) (tag (sub-terms l1 l2))))

  (put 'make 'sparse-term-list
       (lambda (l) (tag l)))

  'done)

(define (make-sparse-term-list l)
  ((get 'make 'sparse-term-list) l))

(define (install-dense-term-list-package)

  (define (adjoin-term term term-list)
    (cond ((> (order term) (length term-list))
           (adjoin-term term
                        (adjoin-term (make-term (length term-list) 0)
                                     term-list)))
          ((= (order term) (length term-list))
           (cons (coeff term) term-list))
          (else
           (error "term order is invalid -- ADJOIN-TERM" term term-list))))

  (define (the-empty-termlist) '())
  (define (first-term term-list) (make-term (- (length term-list) 1)
                                            (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1)) (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 (add-terms (rest-terms L1) L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 (add-terms L1 (rest-terms L2))))
                   (else
                    (adjoin-term
                     (make-term (order t1)
                                (add (coeff t1) (coeff t2)))
                     (add-terms (rest-terms L1)
                                (rest-terms L2)))))))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term
           (make-term (+ (order t1) (order t2))
                      (mul (coeff t1) (coeff t2)))
           (mul-term-by-all-terms t1 (rest-terms L))))))


  (define (=zero-term-list? L)
    (if (empty-termlist? L)
        #t
        (let ((t (first-term L))
              (R (rest-terms L)))
          (and (=zero? (coeff t))
               (=zero-term-list? R)))))

  (define (negate-term-list L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t (first-term L)))
          (adjoin-term
           (make-term (order t)
                      (negate (coeff t)))
           (negate-term-list (rest-terms L))))))

  (define (sub-terms L1 L2)
    (add-terms L1 (negate-term-list L2)))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'dense-term-list p))

  (put 'add '(dense-term-list dense-term-list)
       (lambda (l1 l2) (tag (add-terms l1 l2))))

  (put 'mul '(dense-term-list dense-term-list)
       (lambda (l1 l2) (tag (mul-terms l1 l2))))

  (put '=zero? '(dense-term-list) =zero-term-list?)

  (put 'negate '(dense-term-list)
       (lambda (l) (tag (negate-term-list l))))

  (put 'sub '(dense-term-list dense-term-list)
       (lambda (l1 l2) (tag (sub-terms l1 l2))))

  (put 'make 'dense-term-list
       (lambda (l) (tag l)))

  'done)

(define (make-dense-term-list l)
  ((get 'make 'dense-term-list) l))

(define (install-polynomial-package)

  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add (term-list p1)
                        (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
               (list p1 p2))))

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul (term-list p1)
                        (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
               (list p1 p2))))

  (define (negate-poly p)
    (make-poly (variable p)
               (negate (term-list p))))

  (define (sub-poly p1 p2)
    (add-poly p1 (negate-poly p2)))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))

  (put 'add '(polynomial polynomial) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))

  (put 'mul '(polynomial polynomial) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))

  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))

  (put '=zero? '(polynomial)
       (lambda (p) (=zero? (term-list p))))

  (put 'negate '(polynomial)
       (lambda (p) (tag (negate-poly p))))

  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))

  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(install-dense-term-list-package)
(install-sparse-term-list-package)
(install-polynomial-package)

;;;; tests
;; dense terms list
(add (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))) ;; (polynomial x dense-term-list 2 4 0 6 -4 -10)

(add (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))
     (make-polynomial 'x (make-dense-term-list '(3 2 5)))) ;; (polynomial x dense-term-list 1 2 0 6 0 0)

(add (make-polynomial 'x (make-dense-term-list '(3 2 5)))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))) ;; (polynomial x dense-term-list 1 2 0 6 0 0)

(add (make-polynomial 'x (make-dense-term-list '(3 0 0)))
     (make-polynomial 'x (make-dense-term-list '(7 0 1 2 0 -3 -2 -5)))) ;; (polynomial x dense-term-list 7 0 1 2 0 0 -2 -5)

(add (make-polynomial 'x (make-dense-term-list '(0 0 0)))
     (make-polynomial 'x (make-dense-term-list '(2 5)))) ;; (polynomial x dense-term-list 0 2 5)

(sub (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))) ;; (polynomial x dense-term-list 0 0 0 0 0 0)

(sub (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))
     (make-polynomial 'x (make-dense-term-list '(3 2 5)))) ;; (polynomial x dense-term-list 1 2 0 0 -4 -10)

(sub (make-polynomial 'x (make-dense-term-list '(3 2 5)))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))) ;; (polynomial x dense-term-list -1 -2 0 0 4 10)

(sub (make-polynomial 'x (make-dense-term-list '(3 0 0)))
     (make-polynomial 'x (make-dense-term-list '(7 0 1 2 0 -3 -2 -5)))) ;; (polynomial x dense-term-list -7 0 -1 -2 0 6 2 5)

(mul (make-polynomial 'x (make-dense-term-list '(1 0 1)))
     (make-polynomial 'x (make-dense-term-list '(1 0 1)))) ;; (polynomial x dense-term-list 1 0 2 0 1)

(mul (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5)))) ;; (polynomial x dense-term-list 1 4 4 6 8 -18 -11 -12 -26 20 25)

(=zero? (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5))))
(=zero? (make-polynomial 'x (make-dense-term-list '(0 0 0 0))))
(=zero? (make-polynomial 'x (make-dense-term-list '())))

;; sparse terms lists
(add (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))
     (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))) ;; (polynomial x sparse-term-list ((5 2) (4 4) (2 6) (1 -4) (0 -10)))

(add (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))
     (make-polynomial 'x (make-sparse-term-list '((2 3) (1 2) (0 5))))) ;; (polynomial x sparse-term-list (5 1) (4 2) (2 6))

(add (make-polynomial 'x (make-sparse-term-list '((2 3) (1 2) (0 5)))) 
     (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))) ;; (polynomial x sparse-term-list (5 1) (4 2) (2 6))

(add (make-polynomial 'x (make-sparse-term-list '((2 3))))
     (make-polynomial 'x (make-sparse-term-list '((7 7) (5 1) (4 2) (2 -3) (1 -2) (0 -5))))) ;; (polynomial x sparse-term-list (7 7) (5 1) (4 2) (1 -2) (0 -5))

(add (make-polynomial 'x (make-sparse-term-list '()))
     (make-polynomial 'x (make-sparse-term-list '((2 5))))) ;; (polynomial x sparse-term-list (2 5))

(mul (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))
     (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))) ;; (polynomial x sparse-term-list (10 1) (9 4) (8 4) (7 6) (6 8) (5 -18) (4 -11) (3 -12) (2 -26) (1 20) (0 25))

;; TODO: I need coercion!
;;
;; Probably the nicest way would be to change apply-generic to
;; raise/drop/project types when dealing with types which are with different
;; ranks and to try coercion when types are from the same rank but no proc was
;; found.
(add (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5))))
     (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5))))
