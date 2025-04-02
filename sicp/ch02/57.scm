;; Exercise 2.57. Extend the differentiation program to handle sums and products
;; of arbitrary numbers of (two or more) terms. Then the last example above
;; could be expressed as
;;
;; (deriv '(* x y (+ x 3)) 'x)
;;
;; Try to do this by changing only the representation for sums and products,
;; without changing the deriv procedure at all. For example, the addend of a sum
;; would be the first term, and the augend would be the sum of the rest of the
;; terms.

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base x) (cadr x))

(define (exponent x) (caddr x))

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((and (number? base)
              (number? exponent)) (expt base exponent))
        (else
         (list '** base exponent))))

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
         (make-product (make-product (exponent exp)
                                     (make-exponentiation (base exp) (- (exponent exp) 1))) ;; asumming exponent is always a number
                       (deriv (base exp) var)))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (=number? x n)
  (and (number? x)
       (number? n)
       (= x n)))

;; updated procs
(define (make-product x y . z)
  (let ((multipliers (append (list x y) z)))
    (let ((product (accumulate * 1 (filter number? multipliers)))
          (symbols (filter (lambda (x) (not (number? x))) multipliers)))
      (cond ((= (length symbols) 0) product)
            ((= product 0) 0)
            ((and (= product 1) (> (length symbols) 1)) (cons '* symbols))
            ((and (= product 1) (= (length symbols) 1)) (car symbols))
            (else
             (cons '* (cons product symbols)))))))

(define (multiplicand p)
  (if (= (length p) 3)
      (caddr p)
      (cons '* (cddr p))))

(define (make-sum x y . z)
  (let ((addends (append (list x y) z)))
    (let ((sum (accumulate + 0 (filter number? addends)))
          (symbols (filter (lambda (x) (not (number? x))) addends)))
      (cond ((= (length symbols) 0) sum)
            ((and (= sum 0) (> (length symbols) 1)) (cons '+ symbols))
            ((and (= sum 0) (= (length symbols) 1)) (car symbols))
            (else
             (cons '+ (cons sum symbols)))))))

(define (augend s)
  (if (= (length s) 3)
      (caddr s)
      (cons '+ (cddr s))))

(define (testf x y . z)
  (append (list x y) z))

(define (accumulate op zero-value seq)
  (if (null? seq)
      zero-value
      (op (car seq)
          (accumulate op zero-value (cdr seq)))))

(deriv '(+ x 3) 'x)
;; 1

(deriv '(* x y) 'x)
;; y

(deriv '(* x y (+ x 3)) 'x)
;; (+ (* x y) (* y (+ x 3)))

(deriv '(* x y (+ x y 3)) 'x)
;; (+ (* x y) (* y (+ x y 3)))
