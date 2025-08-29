;; Exercise 2.92. By imposing an ordering on variables, extend the polynomial
;; package so that addition and multiplication of polynomials works for
;; polynomials in different variables. (This is not easy!)

;; This exercise was not easy, indeed! For example if I have the following 2
;; polynomials: (3x⁵ + 2x³ + 3) + (3y⁵ + (x³ + 1)y³), I would have to expand the
;; second(the polynomial in y to become polynomial in x) and then perform the
;; addition.
;;
;; IMO, it is not enough to treat the second one simply as x⁰(3y⁵ + (x³ + 1)y³).
;; If I do that the end result will be: 3x⁵ + 2x³ + x⁰(3 + 3y⁵ + (x³ + 1)y³) and
;; if I expand first, the result will be: 3x⁵ + x³(2 + y³) + x⁰(3y⁵ + y³ + 3)
;;
;; I've tried to implemenet a solution in which I expand(convert the poly in y
;; to poly in x) and then perform the addition/multiplication. 100% I have bugs,
;; because my solution will not handle multiple levels of nested polys(coeff
;; which is poly which has coeff which is another poly).

(define (accumulate op nil-value seq)
  (if (null? seq)
      nil-value
      (op (car seq)
          (accumulate op nil-value (cdr seq)))))

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
  (define (make-termlist term . terms)
    (adjoin-term term terms))

  (define (convert-poly-to-var p new-var)
    (define (poly? x) (eq? (type-tag x) 'polynomial))

    (define (poly-has-coeff-in-var? p var)
      (any (lambda (term)
             (if (poly? (coeff term))
                 (let ((poly (contents (coeff term))))
                   (or (same-variable? (variable poly) var)
                       (poly-has-coeff-in-var? poly var)))
                 #f))
           (term-list p)))

    (define (convert p new-v)
      (define (num-term? t)
        (if (not (poly? (coeff t)))
            #t
            (let ((poly (contents (coeff t))))
              (and (not (same-variable? (variable poly) new-v))
                   (not (poly-has-coeff-in-var? poly new-v))))))

      ;; var-term? does not check whether some nested terms are in new-v
      (define (var-term? t)
        (and (poly? (coeff t))
             (same-variable? (variable (contents (coeff t))) new-v)))

      (define (expand-terms var-terms)
        (map (lambda (var-term)
               ;; var-term = (x² + 2x)y³
               ;; x-poly = x² + 2x
               ;; y-poly = y³
               (let ((x-poly (coeff var-term))
                     (y-poly (make-polynomial (variable p)
                                              (make-termlist (make-term (order var-term) 1)))))
                 ;; (x² + 2x)*y³
                 (map (lambda (x-term)
                        (make-term (order x-term)
                                   (mul y-poly (coeff x-term))))
                      (term-list (contents x-poly)))))
             var-terms))

      ;; num-terms = p terms - var-terms
      ;; var-terms = p terms - num-terms
      (let ((num-terms (filter num-term? (term-list p)))
            (var-terms (filter var-term? (term-list p))))
        (let ((expanded-terms (expand-terms var-terms)))
          (make-poly new-var
                     ;; add all of the expanded terms toghether to x⁰(num-terms)
                     (accumulate add-terms
                                 (list (make-term 0 (make-polynomial (variable p) num-terms)))
                                 expanded-terms)))))


    ;; if all of p coeffs are numbers or polynomials in third variable, just
    ;; create poly of new-var with order 0.
    ;;
    ;; if p has coeffs which are polys in new-var, expand/convert p to become
    ;; polynomial in new-var
    (if (poly-has-coeff-in-var? p new-var)
        (convert p new-var)
        (make-poly new-var
                   (adjoin-term (make-term 0 (tag p))
                                (the-empty-termlist)))))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (let ((v1 (variable p1))
              (v2 (variable p2)))
          (if (string<? (symbol->string v1) (symbol->string v2))
              (add-poly p1
                        (convert-poly-to-var p2 v1))
              (add-poly (convert-poly-to-var p1 v2)
                        p2)))))

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

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul-terms (term-list p1)
                              (term-list p2)))
        (let ((v1 (variable p1))
              (v2 (variable p2)))
          (if (string<? (symbol->string v1) (symbol->string v2))
              (mul-poly p1
                        (convert-poly-to-var p2 v1))
              (mul-poly (convert-poly-to-var p1 v2)
                        p2)))))

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

;; Tests
;; p1 = 3x⁵ + 2x³ + 3
(define p1 (make-polynomial 'x (list '(5 3)
                                     '(3 2)
                                     '(0 3))))

;; p2 = 3y⁵ + 2y³
(define p2 (make-polynomial 'y (list '(5 3)
                                     '(3 2))))

;; p3 = 3y⁵ + (x² + 2x)y³ + 4
(define p3 (make-polynomial 'y (list (list 5 3)
                                     (list 3 (make-polynomial 'x '((2 1) (1 2))))
                                     (list 0 4))))

;; p4 = 3y⁵ + (2x³ + 2x)y³ + 4
(define p4 (make-polynomial 'y (list (list 5 3)
                                     (list 3 (make-polynomial 'x '((3 2) (1 2))))
                                     (list 0 4))))

;; p5 = 3y⁵ + (2x³ + 2x)y³ + (x²)y² + 4
(define p5 (make-polynomial 'y (list (list 5 3)
                                     (list 3 (make-polynomial 'x '((3 2) (1 2))))
                                     (list 2 (make-polynomial 'x '((2 1))))
                                     (list 0 4))))

;; p6 = (x³ + 2x)y⁵ + (x² + 2x)y³ + (x)y² + 4
(define p6 (make-polynomial 'y (list (list 5 (make-polynomial 'x '((3 1) (1 2))))
                                     (list 3 (make-polynomial 'x '((2 1) (1 2))))
                                     (list 2 (make-polynomial 'x '((1 1))))
                                     (list 0 4))))

(add p1 p2)
;; 3x⁵ + 2x³ + (3y⁵ + 2y³ + 3)x⁰
;; (polynomial x (5 3)
;;               (3 2)
;;               (0 (polynomial y (5 3) (3 2) (0 3))))

(add p1 p3)
;; 3x⁵ + 2x³ + (y³)x² + (2y³)x + (3y⁵ + 7)
;; (polynomial x (5 3)
;;               (3 2)
;;               (2 (polynomial y (3 1)))
;;               (1 (polynomial y (3 2)))
;;               (0 (polynomial y (5 3) (0 7))))

(add p1 p4)
;; 3x⁵ + (2y³ + 2)x³ + (2y³)x + (3y⁵ + 7)
;; (polynomial x (5 3)
;;               (3 (polynomial y (3 2) (0 2)))
;;               (1 (polynomial y (3 2)))
;;               (0 (polynomial y (5 3) (0 7))))

(add p1 p5)
;; 3x⁵ + (2y³ + 2)x³ + x²y² + (2y³)x + (3y⁵ + 7)
;; (polynomial x (5 3)
;;               (3 (polynomial y (3 2) (0 2)))
;;               (2 (polynomial y (2 1)))
;;               (1 (polynomial y (3 2)))
;;               (0 (polynomial y (5 3) (0 7))))

(add p1 p6)
;; 3x⁵ + (y⁵ + 2)x³ + (y³)x² + (2y⁵ + 2y³ + y²)x + 7
;; (polynomial x (5 3)
;;               (3 (polynomial y (5 1) (0 2)))
;;               (2 (polynomial y (3 1)))
;;               (1 (polynomial y (5 2) (3 2) (2 1)))
;;               (0 (polynomial y (0 7)))) ;; TODO: This can be simplified

(mul p1 p2)
;; (9y⁵ + 6y³)x⁵ + (6y⁵ + 4y³)x³ + (9yf⁵ + 6y³)
;; (polynomial x (5 (polynomial y (5 9) (3 6)))
;;               (3 (polynomial y (5 6) (3 4)))
;;               (0 (polynomial y (5 9) (3 6))))
