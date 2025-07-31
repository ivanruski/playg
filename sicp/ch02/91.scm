;; Exercise 2.91. A univariate polynomial can be divided by another one to
;; produce a polynomial quotient and a polynomial remainder. For example,
;;
;;   x⁵ - 1
;;   ────── = x³ + x, remainder x - 1
;;   x² - 1
;;
;; Division can be performed via long division. That is, divide the
;; highest-order term of the dividend by the highest-order term of the
;; divisor. The result is the first term of the quotient. Next, multiply the
;; result by the divisor, subtract that from the dividend, and produce the rest
;; of the answer by recursively dividing the difference by the divisor. Stop
;; when the order of the divisor exceeds the order of the dividend and declare
;; the dividend to be the remainder. Also, if the dividend ever becomes zero,
;; return zero as both quotient and remainder.
;;
;; We can design a div-poly procedure on the model of add-poly and mul-poly. The
;; procedure checks to see if the two polys have the same variable. If so,
;; div-poly strips off the variable and passes the problem to div-terms, which
;; performs the division operation on term lists. Div-poly finally reattaches
;; the variable to the result supplied by div-terms. It is convenient to design
;; div-terms to compute both the quotient and the remainder of a
;; division. Div-terms can take two term lists as arguments and return a list of
;; the quotient term list and the remainder term list.
;;
;; Complete the following definition of div-terms by filling in the missing
;; expressions. Use this to implement div-poly, which takes two polys as
;; arguments and returns a list of the quotient and remainder polys.
;;
;; (define (div-terms L1 L2)
;;   (if (empty-termlist? L1)
;;       (list (the-empty-termlist) (the-empty-termlist))
;;       (let ((t1 (first-term L1))
;;             (t2 (first-term L2)))
;;         (if (> (order t2) (order t1))
;;             (list (the-empty-termlist) L1)
;;             (let ((new-c (div (coeff t1) (coeff t2)))
;;                   (new-o (- (order t1) (order t2))))
;;               (let ((rest-of-result
;;                      <compute rest of result recursively>
;;                      ))
;;                 <form complete result>
;;                 ))))))

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

;; TODO: tests
