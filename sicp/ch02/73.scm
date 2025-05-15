;; Exercise 2.73. Section 2.3.2 described a program that performs symbolic
;; differentiation:
;;
;; (define (deriv exp var)
;;   (cond ((number? exp) 0)
;;         ((variable? exp) (if (same-variable? exp var) 1 0))
;;         ((sum? exp)
;;          (make-sum (deriv (addend exp) var)
;;                    (deriv (augend exp) var)))
;;         ((product? exp)
;;          (make-sum
;;            (make-product (multiplier exp)
;;                          (deriv (multiplicand exp) var))
;;            (make-product (deriv (multiplier exp) var)
;;                          (multiplicand exp))))
;;         <more rules can be added here>
;;         (else (error "unknown expression type -- DERIV" exp))))
;;
;; We can regard this program as performing a dispatch on the type of the
;; expression to be differentiated. In this situation the ``type tag'' of the
;; datum is the algebraic operator symbol (such as +) and the operation being
;; performed is deriv. We can transform this program into data-directed style by
;; rewriting the basic derivative procedure as
;;
;; (define (deriv exp var)
;;    (cond ((number? exp) 0)
;;          ((variable? exp) (if (same-variable? exp var) 1 0))
;;          (else ((get 'deriv (operator exp)) (operands exp)
;;                                             var))))
;;
;; (define (operator exp) (car exp))
;; (define (operands exp) (cdr exp))
;;
;; a. Explain what was done above. Why can't we assimilate the predicates
;; number? and same-variable? into the data-directed dispatch?
;;
;; b. Write the procedures for derivatives of sums and products, and the
;; auxiliary code required to install them in the table used by the program
;; above.
;;
;; c. Choose any additional differentiation rule that you like, such as the one
;; for exponents (exercise 2.56), and install it in this data-directed system.
;;
;; d. In this simple algebraic manipulator the type of an expression is the
;; algebraic operator that binds it together. Suppose, however, we indexed the
;; procedures in the opposite way, so that the dispatch line in deriv looked
;; like
;;
;; ((get (operator exp) 'deriv) (operands exp) var)
;;
;; What corresponding changes to the derivative system are required?

;; a. sum, product and the other rules were moved outside of the deriv proc. If
;; we have something like (* exp1 exp2), calling operator will return * and
;; operands will return (exp1 exp2). We can pass the operands to deriv-product
;; and find the derviative.
;;
;; We can't assimilate number? and same-variable?, because they don't have a
;; type attached to the datum. If we want to assimilate them, we would have to
;; change the implementations of get, operator and operands.
;;
;; b. Write the procedures for derivatives of sums and products, and the
;; auxiliary code required to install them in the table used by the program
;; above.

(define table '())

(define (put op type item)
  (set! table (cons (list op type item) table)))

(define (get op type)
  (let ((item (find (lambda (entry)
                      (and (equal? op (car entry))
                           (equal? type (cadr entry))))
                    table)))
    (if item
        (caddr item)
        (error "unknown combination of operation and type -- GET" op type))))

(define (deriv-product operands var)
  (let ((multiplier (multiplier operands))
        (multiplicand (multiplicand operands)))
    (make-sum
     (make-product multiplier (deriv multiplicand var))
     (make-product (deriv multiplier var) multiplicand))))

(define (deriv-sum operands var)
  (let ((addend (addend operands))
        (augend (augend operands)))
    (make-sum (deriv addend var) (deriv augend var))))

(put 'deriv '+ deriv-sum)
(put 'deriv '* deriv-product)

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

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

(define (=number? x n)
  (and (number? x)
       (number? n)
       (= x n)))

;; 4 procs below had to be modified because the operator is no longer the first
;; element in the list. We are passing only the operands.
(define (addend s) (car s))

(define (augend s) (cadr s))

(define (multiplier p) (car p))

(define (multiplicand p) (cadr p))

(deriv '(* x (* y (+ x (+ y 3)))) 'x)
;; (+ (* x y) (* y (+ x (+ y 3))))

;; c. Choose any additional differentiation rule that you like, such as the one
;; for exponents (exercise 2.56), and install it in this data-directed system.

(define (deriv-exponent operands var)
  (make-product (make-product (exponent operands)
                              (make-exponentiation (base operands) (- (exponent operands) 1)))
                (deriv (base operands) var)))

(put 'deriv '** deriv-exponent)

;; 2 procs below had to be modified because the operator is no longer the first
;; element in the list. We are passing only the operands.
(define (base x) (car x))

(define (exponent x) (cadr x))

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((and (number? base)
              (number? exponent)) (expt base exponent))
        (else
         (list '** base exponent))))

(deriv '(** (+ (* x y) y) 5) 'x)
;; (* (* 5 (** (+ (* x y) y) 4)) y)

;; d. In this simple algebraic manipulator the type of an expression is the
;; algebraic operator that binds it together. Suppose, however, we indexed the
;; procedures in the opposite way, so that the dispatch line in deriv looked
;; like
;;
;; ((get (operator exp) 'deriv) (operands exp) var) ;; new
;; ((get 'deriv (operator exp)) (operands exp) var) ;; old
;;
;; What corresponding changes to the derivative system are required?
;;
;; I would have to update all of the puts as well as the get implementation

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get (operator exp) 'deriv) (operands exp)
                                            var))))

(put '+ 'deriv deriv-sum)
(put '* 'deriv deriv-product)
(put '** 'deriv deriv-exponent)

(define (get type op)
  (let ((item (find (lambda (entry)
                      (and (equal? type (car entry))
                           (equal? op (cadr entry))))
                    table)))
    (if item
        (caddr item)
        (error "unknown combination of operation and type -- GET" op type))))

(deriv '(** (+ (* x y) y) 5) 'x)
;; (* (* 5 (** (+ (* x y) y) 4)) y)
