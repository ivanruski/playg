;; Exercise 2.89. Define procedures that implement the term-list representation
;; described above as appropriate for dense polynomials.

(load "generic-arithmetic-used-in-2.5.3.scm")

;; Polynomial package copied from previous exercise, with refactored term-list
;; representation
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

;;;; tests
;; adjoin-term
(adjoin-term (make-term 6 3) '(1 1 0 1)) ;; (3 0 0 1 1 0 1)
(adjoin-term (make-term 4 5) '(1 0 1 1)) ;; (5 1 0 1 1)
(adjoin-term (make-term 3 5) '(1 0 1 1)) ;; error
(adjoin-term (make-term 1 1) '(1)) ;; (1 1)
(adjoin-term (make-term 4 1) '()) ;; (1 0 0 0 0)

;; add
(add (make-polynomial 'x '(1 2 0 3 -2 -5))
     (make-polynomial 'x '(1 2 0 3 -2 -5))) ;; (polynomial x 2 4 0 6 -4 -10)

(add (make-polynomial 'x '(1 2 0 3 -2 -5))
     (make-polynomial 'x '(3 2 5))) ;; (polynomial x 1 2 0 6 0 0)

(add (make-polynomial 'x '(3 2 5))
     (make-polynomial 'x '(1 2 0 3 -2 -5))) ;; (polynomial x 1 2 0 6 0 0)

(add (make-polynomial 'x '(3 0 0))
     (make-polynomial 'x '(7 0 1 2 0 -3 -2 -5))) ;; (polynomial x 7 0 1 2 0 0 -2 -5)

(add (make-polynomial 'x '(0 0 0))
     (make-polynomial 'x '(2 5))) ;; (polynomial x 0 2 5)

;; sub
(sub (make-polynomial 'x '(1 2 0 3 -2 -5))
     (make-polynomial 'x '(1 2 0 3 -2 -5))) ;; (polynomial x 0 0 0 0 0 0)

(sub (make-polynomial 'x '(1 2 0 3 -2 -5))
     (make-polynomial 'x '(3 2 5))) ;; (polynomial x 1 2 0 0 -4 -10)

(sub (make-polynomial 'x '(3 2 5))
     (make-polynomial 'x '(1 2 0 3 -2 -5))) ;; (polynomial x -1 -2 0 0 4 10)

(sub (make-polynomial 'x '(3 0 0))
     (make-polynomial 'x '(7 0 1 2 0 -3 -2 -5))) ;; (polynomial x -7 0 -1 -2 0 6 2 5)

;; mul
(mul (make-polynomial 'x '(1 0 1))
     (make-polynomial 'x '(1 0 1))) ;; (polynomial x 1 0 2 0 1)

(mul (make-polynomial 'x '(1 2 0 3 -2 -5))
     (make-polynomial 'x '(1 2 0 3 -2 -5))) ;; (polynomial x 1 4 4 6 8 -18 -11 -12 -26 20 25)

;; zero
(=zero? (make-polynomial 'x '(1 2 0 3 -2 -5)))
(=zero? (make-polynomial 'x '(0 0 0 0)))
(=zero? (make-polynomial 'x '()))
