;; Exercise 2.57. Extend the differentiation program to handle sums and products
;; of arbitrary numbers of (two or more) terms. Then the last example above
;; could be expressed as:
;;
;; (deriv '(* x y (+ x 3)) 'x)
;;
;; Try to do this by changing only the representation for sums and products,
;; without changing the deriv procedure at all. For example, the addend of a sum
;; would be the first term, and the augend would be the sum of the rest of the
;; terms.

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

;; augend defined below

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

;; multiplicand defined below

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


;; old implementations
(define (augend s) (caddr s))

(define (multiplicand p) (caddr p))

;; new implementations
(define (augend s)
  (let ((rest (cddr s)))
    (if (= (length rest) 1)
        (car rest)
        (append '(+) rest))))

(define (multiplicand p)
  (if (= (length p) 3)
      (caddr p)
      (append '(*) (cddr p))))



;; before
(deriv '(* (* x y) (+ x 3)) 'x)
;; (+ (* x y) (* y (+ x 3)))

;; after
(deriv '(* x y (+ x 3)) 'x)

;; before
(deriv '(+ (* 3 (** x 2)) (+ (* 4 x) 1)) 'x)
;; (+ (* 3 (* 2 x)) 4)

;; after
(deriv '(+ (* 3 (** x 2)) 1 (* 4 x)) 'x)
