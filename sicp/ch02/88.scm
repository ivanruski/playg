;; Exercise 2.88. Extend the polynomial system to include subtraction of
;; polynomials. (Hint: You may find it helpful to define a generic negation
;; operation.)

(load "generic-arithmetic-used-in-2.5.3.scm")

;; test negation
(negate 3)
(negate -3)

(negate (make-rational 21 4))
(negate (make-rational -21 4))
(negate (make-rational -21 -4))
(negate (make-rational 21 -4))

(negate (make-real 3.5))
(negate (make-real -3.5))

(negate (make-complex-from-mag-ang 3 5)) ;; does not work, because I have not implemented it.

(negate (make-complex-from-real-imag 3 5))
(negate (make-complex-from-real-imag 3 -5))
(negate (make-complex-from-real-imag -3 5))
(negate (make-complex-from-real-imag -3 -5))

;; Polynomial package from previous exercise
(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  ;; representation of terms and term lists
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

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
               (list p1 p2))))

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

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
               (list p1 p2))))

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

  (define (=zero-poly? p)
    (define (=zero-term-list? L)
      (if (empty-termlist? L)
          #t
          (let ((t (first-term L))
                (R (rest-terms L)))
            (and (=zero? (coeff t))
                 (=zero-term-list? R)))))
    (=zero-term-list? (term-list p)))

  (define (negate-poly p)
    (define (negate-term-list L)
      (if (empty-termlist? L)
          (the-empty-termlist)
          (let ((t (first-term L)))
            (adjoin-term
             (make-term (order t)
                        (negate (coeff t)))
             (negate-term-list (rest-terms L))))))
    (make-poly (variable p)
               (negate-term-list (term-list p))))

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

  (put '=zero? '(polynomial) =zero-poly?)

  (put 'negate '(polynomial)
       (lambda (p) (tag (negate-poly p))))

  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))

  'done)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

;; test polynomial negatation and subsctraction
(negate (make-polynomial 'x '((100 1) (2 1) (0 1))))
(negate (make-polynomial 'x '((100 -1) (2 -1) (0 -1))))
(negate (make-polynomial 'x (list '(100 -1)
                                  (list 10 (make-complex-from-real-imag 5 5))
                                  (list 2 (make-rational 5 3))
                                  (list 0 (make-real -3.5)))))

(sub (make-polynomial 'x '((100 2) (2 2) (0 2)))
     (make-polynomial 'x '((100 1) (2 1) (0 1))))

;; adjoin-term drops 0-coeffs
(sub (make-polynomial 'x '((100 1) (2 1) (0 1)))
     (make-polynomial 'x '((100 1) (2 1) (0 1))))

(sub (make-polynomial 'x '((100 1) (2 1) (0 1)))
     (make-polynomial 'x '((100 2) (2 2) (0 2))))

(sub (make-polynomial 'x (list '(100 -1)
                               (list 10 (make-complex-from-real-imag 5 5))
                               (list 2 (make-rational 5 3))
                               (list 0 (make-real -3.5))))
     (make-polynomial 'x '((100 2) (2 2) (0 2))))

(sub (make-polynomial 'x (list '(100 -1)
                               (list 10 (make-complex-from-real-imag 5 5))
                               (list 2 (make-rational 5 3))
                               (list 0 (make-real -3.5))))
     (make-polynomial 'x (list '(100 -1)
                               (list 10 (make-rational 3 5))
                               (list 2 3)
                               (list 0 (make-rational 8 3)))))
