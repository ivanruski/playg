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

;; ex.85 - have a way to determine whether we deal with a tagged type
(define (datum? datum)
  (or (pair? datum)
      (number? datum)))

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
       (lambda (x y) (tag (expt x y)))) ;; using primitive expt

  ;; ex.83
  ;; ex.85 - fix raise to round num
  (put 'raise '(scheme-number)
       (lambda (num) (make-rational (round num) 1)))

  ;; ex.84
  (put 'parent-type 'scheme-number
       (lambda () 'rational))

  ;; ex.85
  (put 'project '(scheme-number)
       (lambda (num) num))

  ;; ex.86
  (put 'cos '(scheme-number) (lambda (x) (cos x)))
  (put 'sin '(scheme-number) (lambda (x) (sin x)))
  (put 'sqrt '(scheme-number) (lambda (x) (sqrt x)))
  (put 'square '(scheme-number) (lambda (x) (square x)))
  (put 'atan '(scheme-number scheme-number) (lambda (x y) (atan x y)))

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

  ;; ex.85
  (define (project-rat rat)
    (make-scheme-number (round (* 1.0 (/ (numer rat)
                                         (denom rat))))))

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

  ;; ex.83
  (put 'raise '(rational)
       (lambda (rat) (make-real (* 1.0 (/ (numer rat) (denom rat))))))

  ;; ex.84
  (put 'parent-type 'rational
       (lambda () 'real))

  ;; ex.85
  (put 'project '(rational) project-rat)

    ;; ex.86
  (put 'cos '(rational) (lambda (x) (cos (project-rat x))))
  (put 'sin '(rational) (lambda (x) (sin (project-rat x))))
  (put 'sqrt '(rational) (lambda (x) (sqrt (project-rat x))))
  (put 'square '(rational) (lambda (x) (square (project-rat x))))
  (put 'atan '(rational rational) (lambda (x y) (atan (project-rat x) (project-rat y))))

  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

;; ex.83
;; real-number-package can be improved
(define (install-real-number-package)

  (define (num-part real-num) (car real-num))

  (define (make num)
    (let ((type (type-tag num)))
      (cond ((eq? type 'scheme-number) (attach-tag 'real (list num)))
            ((eq? type 'rational) (attach-tag 'real num))
            (else
             (error "cannot make real from type -- MAKE REAL" num)))))

  ;; we need a special function scheme-number because we wrap scheme-numbers inside list
  ;; to preserve the 'real type-tag. If we don't do this (make-real 5) would return 5
  ;; instead of (real 5)
  (define (scheme-number? num)
    (and (list? num)
         (= (length num) 1)
         (number? (car num))))

  ;; ex.85
  (define (project r)
    (let ((type (type-tag r))
          (num (contents r)))
      (cond ((scheme-number? r) (make-rational (round (num-part r)) 1))
            ((eq? type 'rational) r)
            (else
             (error "unknown type -- PROJECT REAL" type)))))

  (define (equ-real? r1 r2)
    (cond ((and (scheme-number? r1) (scheme-number? r2)) (equ? (num-part r1) (num-part r2)))
          ((scheme-number? r1) (equ? (num-part r1) r2))
          ((scheme-number? r2) (equ? r1 (num-part r2)))
          (else (equ? r1 r2))))

  ;; ex. 85
  (define (add-real r1 r2)
    (cond ((and (scheme-number? r1) (scheme-number? r2)) (add (num-part r1) (num-part r2)))
          ((scheme-number? r1) (add (num-part r1) r2))
          ((scheme-number? r2) (add r1 (num-part r2)))
          (else (add r1 r2))))

  (put 'make 'real make)

  (put 'raise '(real)
       (lambda (n) (make-complex-from-real-imag (num-part n) 0)))

  ;; ex.84
  (put 'parent-type 'real
       (lambda ()  'complex))

  ;; ex.85
  (put 'project '(real) project)
  (put 'equ? '(real real) equ-real?)
  (put 'add '(real real) add-real)

  'done)

;; ex.83
(define (make-real num)
  ((get 'make 'real) num))

;; ex.79
;; define equ? before the complex package, because the complex equ? points to this equ?
;; ex.85 - simplify equ?
(define (equ? a b)
  (apply-generic 'equ? a b))

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

;; ex.85
(define (project n)
  (apply-generic 'project n))

;; Complex numbers
(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))

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

  ;; ex.84
  (put 'parent-type 'complex
       (lambda () '()))

  ;; ex.85
  (put 'project '(complex) project)

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
    (mul (magnitude z) (_cos (angle z))))
  (define (imag-part z)
    (mul (magnitude z) (_sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (_sqrt (add (_square x) (_square y)))
          (_atan y x)))

  ;; ex.79
  (define (equ-polar? a b)
    (and (equ? (magnitude a) (magnitude b))
         (equ? (angle a) (angle b))))

  ;; ex.80
  (define (=zero-polar? a)
    (and (=zero? (magnitude a))
         (=zero? (angle a))))

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
  (put 'equ? '(polar polar) equ-polar?)

  ;; ex.80
  (put '=zero? '(polar) =zero-polar?)

  ;; ex.84
  (put 'parent-type 'polar
       (lambda () 'complex))

  ;; ex.85
  (put 'project '(polar)
       (lambda (z) (make-real (real-part z))))

  'done)

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (_sqrt (add (_square (real-part z))
                (_square (imag-part z)))))
  (define (angle z)
    (_atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (mul r (cos a)) (mul r (_sin a))))

  ;; ex.79
  (define (equ-rect? a b)
    (and (equ? (real-part a) (real-part b))
         (equ? (imag-part a) (imag-part b))))

  ;; ex.80
  (define (=zero-rect? a)
    (and (=zero? (real-part a))
         (=zero? (imag-part a))))

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
  (put 'equ? '(rectangular rectangular) equ-rect?)

  ;; ex.80
  (put '=zero? '(rectangular) =zero-rect?)

  ;; ex.84
  (put 'parent-type 'rectangular
       (lambda () 'complex))

    ;; ex.85
  (put 'project '(rectangular)
       (lambda (z) (make-real (real-part z))))

  'done)

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (exp x y) (apply-generic 'exp x y))

;; ex.86
(define (_cos x) (apply-generic 'cos x))
(define (_sin x) (apply-generic 'sin x))
(define (_atan x y) (apply-generic 'atan x y))
(define (_sqrt x) (apply-generic 'sqrt x))
(define (_square x) (apply-generic 'square x))

;; install
(install-scheme-number-package)
(install-rational-package)
(install-real-number-package)
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

;; ex.83
(define (raise arg)
  (apply-generic 'raise arg))

;; ex.84
;; TODO: can I use apply-generic ?
(define (parent-type type)
  (let ((fn (get 'parent-type type)))
    (if (null? fn)
        (error "unknown type -- PARENT-TYPE" type)
        (fn))))

(define (type-rank type)
  (let ((pt (parent-type type)))
    (if (null? pt)
        0
        (- (type-rank pt) 1))))

;; not a stable sort but it should do the job
(define (sort-types types)
  (if (null? types)
      '()
      (let ((head-type (car types))
            (head-rank (type-rank (car types)))
            (rest (cdr types)))
        (append (sort-types (filter (lambda (t) (<= (type-rank t) head-rank)) rest))
                (list head-type)
                (sort-types (filter (lambda (t) (> (type-rank t) head-rank)) rest))))))


(define (try-raise arg target-type)
  (if (eq? (type-tag arg) target-type)
      arg
      (try-raise (raise arg) target-type)))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((broadest-type (last (sort-types type-tags)))
          (proc (get op type-tags)))
      (if (not (null? proc))
          (apply proc (map contents args))
          ;; attempt coercion and try again
          (let ((raised-args (map (lambda (arg) (try-raise arg broadest-type)) args)))
            (let ((proc (get op (map type-tag raised-args))))
              (if (null? proc)
                  (error "No method for these types" (list op (map type-tag raised-args)))
                  (drop (apply proc (map contents raised-args))))))))))

;; ex.85
(define (project n)
  (apply-generic 'project n))

(define (drop arg)
  (if (not (datum? arg))
      arg
      (let ((dropped (project arg)))
        (cond ((eq? (type-tag arg) (type-tag dropped)) arg)
              ((equ? (raise dropped) arg) (drop dropped))
              (else arg)))))
