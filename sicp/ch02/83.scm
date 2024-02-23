;; Exercise 2.83. Suppose you are designing a generic arithmetic system for
;; dealing with the tower of types shown in figure 2.25: integer, rational,
;; real, complex. For each type (except complex), design a procedure that raises
;; objects of that type one level in the tower. Show how to install a generic
;; raise operation that will work for each type (except complex).

(define (install-real-number-package)

  ;; simply wrap the number with the rational tag
  (put 'make 'real
       (lambda (n) (attach-tag 'real n)))
  
  'done)

(install-real-number-package)

(define (make-real num)
  ((get 'make 'real) num))

;; attach-tag ignores the type when the type is scheme-number
(make-real (make-scheme-number 5))
(make-real (make-rational 5 5))

;; for the purpose of the exercise simply wrap the child type to the parent when coercing
(put-coercion 'rational 'real (lambda (rat) (make-real rat)))
(put-coercion 'real 'complex (lambda (real) (attach-tag 'complex real)))

;; raise uses type coercion
(define (raise-num number)
  (define (parent type)
    (cond ((eq? type 'scheme-number) 'rational)
          ((eq? type 'rational) 'real)
          ((eq? type 'real) 'complex)
          ((eq? type 'complex) '())
          (else (error "Unknown type" type))))

  (let ((type (type-tag number))
        (parent-type (parent (type-tag number))))
    (let ((coerce (get-coercion type parent-type)))
      (cond ((null? parent-type) number)
            ((null? coerce) (error "coercion not found for related types"
                                  (list type parent-type)))
            (else (coerce number))))))

(raise-num (make-scheme-number 5))
(raise-num (make-rational 5 5))
(raise-num (make-real (make-rational 5 5)))
(raise-num (make-complex-from-real-imag 5 5))

(raise-num (make-scheme-number 5))
(raise-num (raise-num (make-scheme-number 5)))
(raise-num (raise-num (raise-num (make-scheme-number 5))))
(raise-num (raise-num (raise-num (raise-num (make-scheme-number 5)))))
