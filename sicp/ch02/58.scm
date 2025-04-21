;; Exercise 2.58. Suppose we want to modify the differentiation program so that
;; it works with ordinary mathematical notation, in which + and * are infix
;; rather than prefix operators. Since the differentiation program is defined in
;; terms of abstract data, we can modify it to work with different
;; representations of expressions solely by changing the predicates, selectors,
;; and constructors that define the representation of the algebraic expressions
;; on which the differentiator is to operate.

;; a. Show how to do this in order to differentiate algebraic expressions
;; presented in infix form, such as (x + (3 * (x + (y + 2)))). To simplify the
;; task, assume that + and * always take two arguments and that expressions are
;; fully parenthesized.
;;
;; b. The problem becomes substantially harder if we allow standard algebraic
;; notation, such as (x + 3 * (x + y + 2)), which drops unnecessary parentheses
;; and assumes that multiplication is done before addition. Can you design
;; appropriate predicates, selectors, and constructors for this notation such
;; that our derivative program still works?

;; a.
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p) (caddr p))

(define (=number? x n)
  (and (number? x)
       (number? n)
       (= x n)))


;; previously
(deriv '(* x (* y (+ x (+ y 3)))) 'x)
;; (+ (* x y) (* y (+ x (+ y 3))))

;; currently
(deriv '(x * (y * (x + (y + 3)))) 'x)
;; ((x * y) + (y * (x + (y + 3))))

(deriv '(x + (3 * (x + (y + 2)))) 'x)
;; 4

(deriv '((x * y) + (y * (x + (y + 3)))) 'x)
;; (y + y)

;; b. 
;; 
;; x * y + y * (x + y + 3) will be treated as (x * y) + y * (x + y + 3)

(define (sum? expr)
  (any (lambda (x) (eq? x '+)) expr))

(define (addend expr)
  (let ((ad (car (split-by expr '+))))
    ;; unwrap if necessary e.g. ((x + y)) -> (x + y)
    (if (= (length ad) 1)
        (car ad)
        ad)))

(define (augend expr)
  (let ((au (cadr (split-by expr '+))))
    ;; unwrap if necessary e.g. ((x + y)) -> (x + y)
    (if (= (length au) 1)
        (car au)
        au)))

(define (product? expr)
  (and (any (lambda (x) (eq? x '*)) expr)
       (not (sum? expr))))

(define (multiplier expr)
  (let ((mr (car (split-by expr '*))))
    ;; unwrap if necessary e.g. ((x * y)) -> (x * y)
    (if (= (length mr) 1)
        (car mr)
        mr)))

(define (multiplicand expr)
  (let ((md (cadr (split-by expr '*))))
    ;; unwrap if necessary e.g. ((x * y)) -> (x * y)
    (if (= (length md) 1)
        (car md)
        md)))

;; splits by the first occurrence of symbol. The result is a list where the
;; first element is everything up to the first occurrence of symbol and the
;; second elemnt is the remaining part.
(define (split-by expr symbol)
  (define (iter first remaining)
    (cond ((null? remaining) first)
          ((eq? symbol (car remaining)) (list first
                                              (cdr remaining)))
          (else
           (iter (append first (list (car remaining)))
                 (cdr remaining)))))
  (iter '() expr))

(deriv '(x * y * (x + y + 3)) 'x)
;; ((x * y) + (y * (x + y + 3)))

(deriv '(x + 3 * (x + y + 2)) 'x)
;; 4

(deriv '(x * y + y * (x + y + 3)) 'x)
;; (y + y)

(deriv '((x + y) * (a + b)) 'x)
;; (a + b)

(deriv '(x * (y + z * a)) 'x)
;; (y + z * a)

(deriv '(x * y * z + a * b) 'x)
;; (y * z)

(deriv '((x + y) * z) 'x)
;; z

(deriv '(x * (y + z)) 'y)
;; x
