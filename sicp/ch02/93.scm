;; Exercise 2.93. Modify the rational-arithmetic package to use generic
;; operations, but change make-rat so that it does not attempt to reduce
;; fractions to lowest terms. Test your system by calling make-rational on two
;; polynomials to produce a rational function
;;
;; (define p1 (make-polynomial 'x '((2 1)(0 1))))
;; (define p2 (make-polynomial 'x '((3 1)(0 1))))
;; (define rf (make-rational p2 p1))
;;
;; Now add rf to itself, using add. You will observe that this addition
;; procedure does not reduce fractions to lowest terms.
;;
;; We can reduce polynomial fractions to lowest terms using the same idea we
;; used with integers: modifying make-rat to divide both the numerator and the
;; denominator by their greatest common divisor. The notion of ``greatest common
;; divisor'' makes sense for polynomials. In fact, we can compute the GCD of two
;; polynomials using essentially the same Euclid's Algorithm that works for
;; integers.60 The integer version is
;;
;; (define (gcd a b)
;;   (if (= b 0)
;;       a
;;       (gcd b (remainder a b))))
;;
;; Using this, we could make the obvious modification to define a GCD operation
;; that works on term lists:
;;
;; (define (gcd-terms a b)
;;   (if (empty-termlist? b)
;;       a
;;       (gcd-terms b (remainder-terms a b))))
;;
;; where remainder-terms picks out the remainder component of the list returned
;; by the term-list division operation div-terms that was implemented in
;; exercise 2.91.

(load "generic-arithmetic-used-in-2.5.3.scm")

(define (install-rational-package-253-extended)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (cond ((not (integer? n)) (error "Numerator must be an integer -- MAKE-RATIONAL" n))
          ((not (integer? d)) (error "Denumerator must be an integer -- MAKE-RATIONAL" d))
          (else
           (let ((g (gcd n d)))
             (let ((n (/ n g))
                   (d (/ d g)))
               (if (negative? (* n d))
                   (cons (- (abs n)) (abs d))
                   (cons (abs n) (abs d))))))))

  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))

  (define (equ? x y)
    (and (= (numer x) (numer y))
         (= (denom x) (denom y))))

  (define (raise x)
    (make-real (/ (* (numer x) 1.)
                  (denom x))))

  (define (negate-rat x)
    (make-rat (negate (numer x))
              (denom x)))

  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))

  (put 'equ? '(rational rational) equ?)

  (put '=zero? '(rational)
       (lambda (x) (= 0 (numer x))))

  (put 'raise '(rational)
       (lambda (x) (raise x)))

  (put 'project '(rational)
       (lambda (x) (make-scheme-number (round (/ (numer x) (denom x))))))

  (put 'sin-num '(rational)
       (lambda (x) (sin-num (raise x))))
  (put 'cos-num '(rational)
       (lambda (x) (cos-num (raise x))))
  (put 'atan-num '(rational)
       (lambda (x) (atan-num (raise x))))
  (put 'atan-num '(rational rational)
       (lambda (x y) (atan-num (raise x) (raise y))))
  (put 'sqrt-num '(rational)
       (lambda (x) (sqrt-num (raise x))))
  (put 'square-num '(rational)
       (lambda (x) (tag (make-rat (square-num (numer x))
                                  (square-num (denom x))))))

  (put 'negate '(rational)
       (lambda (x) (tag (negate-rat x))))

  'done)

(install-rational-package-253-extended)

;; Polynomial package copied from 91.scm + additional support for add/mul poly
;; to number. I deliberately copied from 91 not 92, because in the next
;; exercises working with polynomials in different variables is not needed.
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

  (define (negate-term-list L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t (first-term L)))
          (adjoin-term
           (make-term (order t)
                      (negate (coeff t)))
           (negate-term-list (rest-terms L))))))

  (define (negate-poly p)
    (make-poly (variable p)
               (negate-term-list (term-list p))))

  (define (sub-poly p1 p2)
    (add-poly p1 (negate-poly p2)))

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (let ((result (div-terms (term-list p1)
                                 (term-list p2))))
          (list (make-poly (variable p1) (car result))
                (make-poly (variable p1) (cadr result))))
        (error "Polys not in same var -- DIV-POLY"
               (list p1 p2))))

  (define (div-terms L1 L2)
    (define (sub-term-lists L1 L2)
      (add-terms L1 (negate-term-list L2)))

    (if (empty-termlist? L1)
        (list (the-empty-termlist) (the-empty-termlist))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-termlist) L1)
              (let ((new-c (div (coeff t1) (coeff t2)))
                    (new-o (- (order t1) (order t2))))
                (let ((rest-of-result
                       ;; new-dividend = (new term * divisor) - dividend
                       (div-terms (sub-term-lists L1
                                                  (mul-term-by-all-terms (make-term new-o new-c)
                                                                    L2))
                                  L2)))
                  (list (cons (make-term new-o new-c)
                              (car rest-of-result))
                        (cadr rest-of-result))))))))

  (define (add-poly-to-number p num)
    (add-poly p
              (make-poly (variable p)
                         (adjoin-term (make-term 0 num)
                                      (the-empty-termlist)))))

  (define (mul-poly-to-number p num)
    (mul-poly p
              (make-poly (variable p)
                         (adjoin-term (make-term 0 num)
                                      (the-empty-termlist)))))

  (define (poly-equ? p1 p2)
    (define (terms-equ? L1 L2)
      (if (empty-termlist? L1)
          (empty-termlist? L2)
          (let ((t1 (first-term L1))
                (t2 (first-term L2)))
            (and (= (order t1) (order t2))
                 (equ? (coeff t1) (coeff t2))
                 (terms-equ? (rest-terms L1) (rest-terms L2))))))

    (if (same-variable? (variable p1) (variable p2))
        (terms-equ? (term-list p1) (term-list p2))
        #f))

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

  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) (map tag (div-poly p1 p2))))

  (put 'equ? '(polynomial polynomial)
       (lambda (p1 p2) (poly-equ? p1 p2)))

  (for-each (lambda (type)

              (put 'add (list 'polynomial type) (lambda (p num) (tag (add-poly-to-number p (attach-tag type num)))))
              (put 'add (list type 'polynomial) (lambda (num p) (tag (add-poly-to-number p (attach-tag type num)))))

              (put 'mul (list 'polynomial type) (lambda (p num) (tag (mul-poly-to-number p (attach-tag type num)))))
              (put 'mul (list type 'polynomial) (lambda (num p) (tag (mul-poly-to-number p (attach-tag type num))))))

            '(scheme-number rational real-number polar rectangular complex))

  'done)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(define (polynomial? x)
  (eq? (type-tag x) 'polynomial))

(define p1 (make-polynomial 'x '((2 1)(0 1))))
(define p2 (make-polynomial 'x '((3 1)(0 1))))
(define rf (make-rational p2 p1))
