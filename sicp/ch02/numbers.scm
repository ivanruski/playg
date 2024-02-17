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

(define (attach-tag type-tag contents)
  (if (number? contents)
      contents
      (cons type-tag contents)))

(define (type-tag datum)
  (cond ((pair? datum) (car datum))
        ((number? datum) 'scheme-number)
        (else
         (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (cond ((pair? datum) (cdr datum))
        ((number? datum) datum)
        (else
         (error "Bad tagged datum -- CONTENTS" datum))))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))

  ;; ex.79
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))

  ;; ex.80
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0)))

  ;; ex.81
  (put 'exp '(scheme-number scheme-number)
      (lambda (x y) (tag (expt x y)))) ; using primitive expt
  
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

;; Rational numbers
(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))

  ;; ex.79
  (define (equ? a b)
    (and (= (numer a) (numer b))
         (= (denom a) (denom b))))

  ;; ex.80
  (define (=zero? a)
    (or (= (numer a) 0)
        (= (denom a) 0)))

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

  ;; ex.79
  (put 'equ? '(rational rational) equ?)

  ;; ex.80
  (put '=zero? '(rational) =zero?)

  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

;; ex.79
;; define equ? before the complex package, because the complex equ? points to
;; this equ?
(define (equ? a b)
  (if (eq? (type-tag a) (type-tag b))
      (apply-generic 'equ? a b)
      #f))

;; ex.80
;; analogous to ex.79
(define (=zero? a)
  (apply-generic '=zero? a))

;; ex.77
(define (real-part z)
  (apply-generic 'real-part z))

(define (imag-part z)
  (apply-generic 'imag-part z))

(define (magnitude z)
  (apply-generic 'magnitude z))

(define (angle z)
  (apply-generic 'angle z))

;; Complex numbers
(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))

  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ;; ex.77
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  ;; ex.79
  ;; point the complex equ? to the public equ?, like ex.77
  (put 'equ? '(complex complex) equ?)

  ;; ex.80
  ;; same as above
  (put '=zero? '(complex) =zero?)

  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; ex.79
  (define (equ? a b)
    (and (= (magnitude a) (magnitude b))
         (= (angle a) (angle b))))

  ;; ex.80
  (define (=zero? a)
    (and (= (magnitude a) 0)
         (= (angle a) 0)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar 
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ;; ex.79
  (put 'equ? '(polar polar) equ?)

  ;; ex.80
  (put '=zero? '(polar) =zero?)

  'done)

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (* r (cos a)) (* r (sin a))))

  ;; ex.79
  (define (equ? a b)
    (and (= (real-part a) (real-part b))
         (= (imag-part a) (imag-part b))))

  ;; ex.80
  (define (=zero? a)
    (and (= (real-part a) 0)
         (= (imag-part a) 0)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular 
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular 
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ;; ex.79
  (put 'equ? '(rectangular rectangular) equ?)

  ;; ex.80
  (put '=zero? '(rectangular) =zero?)

  'done)

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (exp x y) (apply-generic 'exp x y))

;; install
(install-scheme-number-package)
(install-rational-package)
(install-complex-package)
(install-polar-package)
(install-rectangular-package)

;; coercion

(define coercion-table '())

(define (put-coercion from-type to-type proc)
  (cond ((null? (get-coercion from-type to-type))
         (set! coercion-table (cons (list from-type to-type proc) coercion-table))
         coercion-table)
        (else coercion-table)))

(define (get-coercion from-type to-type)
  (define (iter-table table)
    (if (null? table)
        '()
        (let ((elem (car table))
              (rest (cdr table)))
          (if (and (equal? (car elem) from-type)
                   (equal? (cadr elem) to-type))
              (caddr elem)
              (iter-table rest)))))
  (iter-table coercion-table))

;; ex.81
(define (install-coercion-package)
  (define (scheme-number->scheme-number n) n)
 ;;  (define (complex->complex z) z)

  (define (scheme-number->complex n)
    (make-complex-from-real-imag (contents n) 0))

  (define (scheme-number->rational n)
    (make-rational (contents n) 1))

  (put-coercion 'scheme-number 'scheme-number scheme-number->scheme-number)
  ;; (put-coercion 'complex 'complex complex->complex)

  (put-coercion 'scheme-number 'complex scheme-number->complex)
  (put-coercion 'scheme-number 'rational scheme-number->rational)

  'done)

(install-coercion-package)

;; ex.82
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args))
        (coerced-types (try-coerce-types (map type-tag args))))
    (let ((proc (get op coerced-types)))
      (if (or (null? proc) (null? type-tags))
          (error "No method for these types" (list op type-tags))
          (apply proc (map (lambda (datum)
                             (let ((data (contents datum))
                                   (type (type-tag datum))
                                   (coerced-type (car coerced-types)))
                               (if (eq? type coerced-type) ;; we don't have a->a coercions
                                   data
                                   (contents ((get-coercion type coerced-type) datum)))))
                           args))))))

(define (try-coerce-types type-tags)
  (define (coercions type-tags)
    (map (lambda (type1)
           (map (lambda (type2)
                  (if (eq? type1 type2)
                      type1
                      (let ((proc (get-coercion type2 type1)))
                        (if (not (null? proc))
                            type1
                            '()))))
                type-tags))
         type-tags))

  (define (valid-coercions coersions-lists)
    ;; (display coersions-lists)
    ;; (newline)
    (filter (lambda (list)
            (let ((filtered (filter (lambda (el) (symbol? el)) list)))
              (= (length filtered)
                 (length type-tags))))
            coersions-lists))

  ;; take the first valid coercion
  (let ((valid-list (valid-coercions (coercions type-tags))))
    (if (= (length valid-list) 0)
        '()
        (car valid-list))))
