;; Exercise 2.96.  a. Implement the procedure pseudoremainder-terms, which is
;; just like remainder-terms except that it multiplies the dividend by the
;; integerizing factor described above before calling div-terms. Modify
;; gcd-terms to use pseudoremainder-terms, and verify that
;; greatest-common-divisor now produces an answer with integer coefficients on
;; the example in exercise 2.95.
;;
;; b. The GCD now has integer coefficients, but they are larger than those of
;; P1. Modify gcd-terms so that it removes common factors from the coefficients
;; of the answer by dividing all the coefficients by their (integer) greatest
;; common divisor.

(define (accumulate op nil-value seq)
  (if (null? seq)
      nil-value
      (op (car seq)
          (accumulate op nil-value (cdr seq)))))

;; copied from 2.94
(load "generic-arithmetic-used-in-2.5.3.scm")

(define (install-rational-package-253-extended)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (cons n d))

  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))

  (define (equ-rat? x y)
    (and (equ? (numer x) (numer y))
         (equ? (denom x) (denom y))))

  (define (raise-rat x)
    (let ((n (numer x))
          (d (denom x)))
      (if (or (polynomial? n) (polynomial? d))
          (tag x)
          (make-real (div (mul n 1.) d)))))

  (define (project-rat x)
    (let ((n (numer x))
          (d (denom x)))
      (if (or (polynomial? n) (polynomial? d))
          (tag x)
          (let ((result (div n d)))
            (if (eq? (type-tag result) 'scheme-number)
                (round result)
                result)))))

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

  (put 'equ? '(rational rational) equ-rat?)

  (put '=zero? '(rational)
       (lambda (x) (equ? 0 (numer x))))

  (put 'raise '(rational)
       (lambda (x) (raise-rat x)))

  (put 'project '(rational)
       (lambda (x) (project-rat x)))

  (put 'negate '(rational)
       (lambda (x) (tag (negate-rat x))))

  'done)

(install-rational-package-253-extended)

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

  (define (remainder-terms L1 L2)
    (let ((result (div-terms L1 L2)))
      (let ((remainder (cadr result)))
        remainder)))

  (define (pseudoremainder-terms L1 L2)
    (define (integerizing-factor L1 L2)
      (let ((o1 (order (first-term L1)))
            (o2 (order (first-term L2)))
            (c (coeff (first-term L2))))
        (expt c (+ 1 (- o1 o2)))))

    (let ((factored-l1 (mul-term-by-all-terms (make-term 0 (integerizing-factor L1 L2))
                                              L1)))
      (let ((result (div-terms factored-l1 L2)))
        (let ((remainder (cadr result)))
          remainder))))

  (define (gcd-terms a b)
    (define (remove-common-factors L)
      (if (empty-termlist? L)
          L
          (let ((gcd-l (accumulate gcd 0 (map coeff L))))
            (map (lambda (term)
                   (make-term (order term)
                              (/ (coeff term) gcd-l)))
                 L))))

    (if (empty-termlist? b)
        (remove-common-factors a)
        (gcd-terms b (pseudoremainder-terms a b))))

  (define (gcd-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (gcd-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- GCD-POLY"
               (list p1 p2))))

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

  (put 'greatest-common-divisor '(polynomial polynomial)
       (lambda (p1 p2) (tag (gcd-poly p1 p2))))

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

(define (greatest-common-divisor x y)
  (apply-generic 'greatest-common-divisor x y))

;; test

(define p1 (make-polynomial 'x '((2 1) (1 -2) (0 1))))
(define p2 (make-polynomial 'x '((2 11) (0 7))))
(define p3 (make-polynomial 'x '((1 13) (0 5))))

(define q1 (mul p1 p2))
(define q2 (mul p1 p3))

(greatest-common-divisor q1 q2)
