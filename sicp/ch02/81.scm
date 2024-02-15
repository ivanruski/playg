;; Exercise 2.81. Louis Reasoner has noticed that apply-generic may try to
;; coerce the arguments to each other's type even if they already have the same
;; type. Therefore, he reasons, we need to put procedures in the coercion table
;; to "coerce" arguments of each type to their own type. For example, in
;; addition to the scheme-number->complex coercion shown above, he would do:
;;
;; (define (scheme-number->scheme-number n) n)
;; (define (complex->complex z) z)
;; (put-coercion 'scheme-number 'scheme-number
;;               scheme-number->scheme-number)
;; (put-coercion 'complex 'complex complex->complex)
;;
;; a. With Louis's coercion procedures installed, what happens if apply-generic
;; is called with two arguments of type scheme-number or two arguments of type
;; complex for an operation that is not found in the table for those types? For
;; example, assume that we've defined a generic exponentiation operation:
;;
;; (define (exp x y) (apply-generic 'exp x y))
;;
;; and have put a procedure for exponentiation in the Scheme-number package but
;; not in any other package:
;;
;; following added to Scheme-number package
;; (put 'exp '(scheme-number scheme-number)
;;     (lambda (x y) (tag (expt x y)))) ; using primitive expt
;;
;; What happens if we call exp with two complex numbers as arguments?
;;
;; b. Is Louis correct that something had to be done about coercion with
;; arguments of the same type, or does apply-generic work correctly as is?
;;
;; c. Modify apply-generic so that it doesn't try coercion if the two arguments
;; have the same type.

;; a.
;; When we call exp with two complex numbers the following will happen:
;;
;; (get 'exp '(complex complex)) will return null and we'll proceed in the else
;; part where we'll try to coerce the arguments. We'll find coercing for t1->t2 (complex->complex)
;; and we'll call apply-generic again. In this way we'll enter endless recursion.

(exp (make-scheme-number 5) (make-scheme-number 3)) ;; ok
(exp (make-complex-from-real-imag 5 10) (make-complex-from-real-imag 2 0)) ;; endless recursion

;; b.
;; No, Louis is wrong, we don't need coerce procedures for arguments of the same type.
;; Because we define operations for arguments of the same type in the respective package
;; we are developing. When we have arguments of the same type the first `if` in apply-generic
;; will handle that.

;; c.

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if (not (null? proc))
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (if (eq? type1 type2)
                    (error "No method for these types" (list op type-tags))
                    (let ((t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1)))
                      (cond ((not (null? t1->t2))
                             (apply-generic op (t1->t2 a1) a2))
                            ((not (null? t2->t1))
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for these types"
                                    (list op type-tags)))))))
                (error "No method for these types"
                       (list op type-tags)))))))

(exp (make-complex-from-real-imag 5 10) (make-scheme-number 2))
(exp (make-complex-from-real-imag 5 10) (make-complex-from-real-imag 2 0)) ;; no endless recursion anymore
