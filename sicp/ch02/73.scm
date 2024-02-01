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


;; a. Explain what was done above. Why can't we assimilate the predicates
;; number? and same-variable? into the data-directed dispatch?
;;
;; We started treating the algebraic operations +, *, -, etc as types all of
;; which must implement the same procedure - deriv.
;; 
;; We can't assimilate number? and same-veriable? because when we have a number
;; or var, exp does not have operands. We should be able to tweak operator and
;; operands to handle those 2 cases however it is better to treat the
;; numbers/vars separately from the operations.
;; 
;; b and c

;;;; auxiliary procedures
;; copy pasted from 56
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

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((number? exponent) (expt base exponent))
        (else (list '** base exponent))))

;; this should only be accessible by put and get, but I don't know how to achieve it
(define table '())

(define (put op type item)
  (cond ((null? (get op type))
         (set! table (cons (list op type item) table))
         table)
        (else table)))

(define (get op type)
  (define (iter-table table)
    (if (null? table)
        '()
        (let ((elem (car table))
              (rest (cdr table)))
          (if (and (equal? (car elem) op)
                   (equal? (cadr elem) type))
              (caddr elem)
              (iter-table rest)))))
  (iter-table table))

;;;; derivate procedures
(define (install-derive-procs)
  
  (define (deriv-sum exp var)
    (make-sum (deriv (car exp) var)
              (deriv (cadr exp) var)))

  (define (deriv-prod exp var)
    (let ((multiplier (car exp))
          (multiplicand (cadr exp)))
      (make-sum
       (make-product multiplier
                     (deriv multiplicand var))
       (make-product (deriv multiplier var)
                     multiplicand))))

  (define (deriv-exp exp var)
    (let ((base (car exp))
          (exponent (cadr exp)))
      (make-product exponent
                    (make-exponentiation base
                                         (- exponent 1)))))
                                         

  (put 'deriv '+ deriv-sum)
  (put 'deriv '* deriv-prod)
  (put 'deriv '** deriv-exp)

  'done)

;;;; 
(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get (operator exp) 'deriv) (operands exp)
                                            var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;; d. In this simple algebraic manipulator the type of an expression is the
;; algebraic operator that binds it together. Suppose, however, we indexed the
;; procedures in the opposite way, so that the dispatch line in deriv looked
;; like
;; 
;; ((get (operator exp) 'deriv) (operands exp) var)
;; 
;; What corresponding changes to the derivative system are required?

;; We only have to update how we put the procs in the table
;;from:
(put 'deriv '+ deriv-sum)
(put 'deriv '* deriv-prod)
(put 'deriv '** deriv-exp)
;; to:
(put '+ 'deriv deriv-sum)
(put '* 'deriv deriv-prod)
(put '** 'deriv deriv-exp)
