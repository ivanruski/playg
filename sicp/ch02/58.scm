;; Exercise 2.58. Suppose we want to modify the differentiation program so that
;; it works with ordinary mathematical notation, in which + and * are infix
;; rather than prefix operators. Since the differentiation program is defined in
;; terms of abstract data, we can modify it to work with different
;; representations of expressions solely by changing the predicates, selectors,
;; and constructors that define the representation of the algebraic expressions
;; on which the differentiator is to operate.
;; 
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

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

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

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((number? exponent) (expt base exponent))
        (else (list '** base exponent))))

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
        ((exponentiation? exp)
          (make-product (exponent exp)
                        (make-exponentiation (base exp)
                                             (- (exponent exp) 1))))
        (else
         (error "unknown expression type -- DERIV" exp))))

;; a
(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p) (caddr p))

;;

(deriv '((x * y) * (x + 3)) 'x)

(deriv '((3 * (** x 2)) + ((4 * x) + 1)) 'x)

;; b The approach I decided to try is to convert the infix to prefix and work
;; with prefix, then when I have the result to convert it to infix again

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s)
  (let ((rest (cddr s)))
    (if (= (length rest) 1)
        (car rest)
        (append '(+) rest))))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p)
  (if (= (length p) 3)
      (caddr p)
      (append '(*) (cddr p))))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((number? exponent) (expt base exponent))
        (else (list '** base exponent))))

(define (deriv exp var)
  (define (deriv-inner exp var)
    (cond ((number? exp) 0)
          ((variable? exp)
           (if (same-variable? exp var) 1 0))
          ((sum? exp)
           (make-sum (deriv-inner (addend exp) var)
                     (deriv-inner (augend exp) var)))
          ((product? exp)
           (make-sum
             (make-product (multiplier exp)
                           (deriv-inner (multiplicand exp) var))
             (make-product (deriv-inner (multiplier exp) var)
                           (multiplicand exp))))
          ((exponentiation? exp)
            (make-product (exponent exp)
                          (make-exponentiation (base exp)
                                               (- (exponent exp) 1))))
          (else
           (error "unknown expression type -- DERIV" exp))))
  (scheme-expr-to-infix
   (deriv-inner (parenthesize (infix-to-prefix exp)) var)))


;; new implementations

(define (drop-first n list)
  (if (= n 0)
      list
      (drop-first (- n 1) (cdr list))))

;; take prefix expression and convert it to valid scheme expression
(define (parenthesize expr)
  (define (inner expr result)
    ;; (display expr) (display " ") (display result) (newline)
    (if (null? expr)
        (car result)
        (cond ((operator? (car expr))
               (inner (cdr expr)
                      (cons (list (car expr)
                                  (car result)
                                  (cadr result))
                            (drop-first 2 result))))
              (else
               (inner (cdr expr) (cons (car expr) result))))))
  (inner (reverse expr) '()))

(define (deep-reverse l)
  (cond ((= (length l) 0)  l)
        ((list? (car l))
         (append (deep-reverse (cdr l))
                 (list (deep-reverse (car l)))))
        (else
         (append (deep-reverse (cdr l))
                 (list (car l))))))

(define (contains x item)
  (cond ((null? x) false)
        ((eq? item (car x)) true)
        (else (contains (cdr x) item))))

(define (operator? x)
  (contains '(* / + - **) x))

(define (infix-to-prefix expr)
  (define (variable? x)
    (and (symbol? x)
         (not (contains '(* / + - **) x))))
  (define (precedence op)
    (cond ((contains '(**) op) 3)
          ((contains '(* /) op) 2)
          ((contains '(+ -) op) 1)))
  (define (iter expr result operators)
    (if (null? expr)
        (append result operators)
        (let ((elem (car expr))
              (expr (cdr expr)))
          ;; (display elem) (display " ") (display expr) (newline)
          (cond ((or (variable? elem) (number? elem))
                 (iter expr (append result (list elem)) operators))
                ((operator? elem)
                 (cond ((null? operators) (iter expr result (list elem)))
                       ((< (precedence elem) (precedence (car operators)))
                        ;; construct the original expression you find op with equal or lesser precedence
                        (iter (cons elem expr) (append result (list (car operators))) (cdr operators)))
                       (else
                        (iter expr result (cons elem operators)))))
                ((list? elem)
                 (iter expr
                       (append result (iter elem '() '()))
                       operators))))))
  (deep-reverse
   (iter (deep-reverse expr) '() '())))

(define (scheme-expr-to-infix expr)
  (define (variable? x)
    (and (symbol? x)
         (not (contains '(* / + - **) x))))
  (cond ((or (variable? expr)
             (not (list? expr))) expr)
        (else
         (list (scheme-expr-to-infix (cadr expr)) ;; operand
               (car expr) ;; op
               (scheme-expr-to-infix (caddr expr))))))
                 

;; tests
(deriv '((3 * (x ** 2)) + 1 + (4 * x)) 'x)
;; ((3 * (2 * x)) + 4)


(deriv '(x * y * (x + 3)) 'x)
;; ((x * y) + (y * (x + 3)))

(deriv '((2 + 3 + 4) * (5 + 6 * 7)) 'x)
;; 0

(deriv '(x + 3 * (x + y + 2)) 'x)
;; 4
