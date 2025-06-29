;; Exercise 2.85. This section mentioned a method for ``simplifying'' a data
;; object by lowering it in the tower of types as far as possible. Design a
;; procedure drop that accomplishes this for the tower described in exercise
;; 2.83. The key is to decide, in some general way, whether an object can be
;; lowered. For example, the complex number 1.5 + 0i can be lowered as far as
;; real, the complex number 1 + 0i can be lowered as far as integer, and the
;; complex number 2 + 3i cannot be lowered at all. Here is a plan for
;; determining whether an object can be lowered: Begin by defining a generic
;; operation project that ``pushes'' an object down in the tower. For example,
;; projecting a complex number would involve throwing away the imaginary
;; part. Then a number can be dropped if, when we project it and raise the
;; result back to the type we started with, we end up with something equal to
;; what we started with. Show how to implement this idea in detail, by writing a
;; drop procedure that drops an object as far as possible. You will need to
;; design the various projection operations53 and install project as a generic
;; operation in the system. You will also need to make use of a generic equality
;; predicate, such as described in exercise 2.79. Finally, use drop to rewrite
;; apply-generic from exercise 2.84 so that it ``simplifies'' its answers.

(define (attach-tag type-tag contents)
  (cond ((eq? type-tag 'scheme-number) contents)
        (else
         (cons type-tag contents))))

(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else
         (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (cdr datum))
        (else
         (error "Bad tagged datum -- CONTENTS" datum))))

(define table '())

(define (put op type item)
  ;; add or replace
  (set! table (cons (list op type item)
                    (filter (lambda (entry)
                              (not (and (eq? op (car entry))
                                        (eq? type (cadr entry)))))
                            table))))

(define (get op type)
  (let ((item (find (lambda (entry)
                      (and (equal? op (car entry))
                           (equal? type (cadr entry))))
                    table)))
    (if item
        (caddr item)
        item)))

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

  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))

  (put '=zero? '(scheme-number)
       (lambda (x) (equ? 0 x)))

  (put 'exp '(scheme-number scheme-number)
       (lambda (x y) (tag (expt x y)))) ; using primitive expt

  (put 'raise '(scheme-number)
       (lambda (x) (make-rational x 1)))

  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

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

  (define (equ? x y)
    (and (= (numer x) (numer y))
         (= (denom x) (denom y))))

  (define (raise x)
    (make-complex-from-real-imag (/ (* 1.0 (numer x)) ;; force decimal
                                    (denom x)) 0))

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

  (put 'equ? '(rational rational) equ?)

  (put '=zero? '(rational)
       (lambda (x) (= 0 (numer x))))

  (put 'raise '(rational)
       (lambda (x) (raise x)))

  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

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

  (define (equ? x y)
    (and (= (magnitude x) (magnitude y))
         (= (angle x) (angle y))))

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

  (put 'equ? '(polar polar) equ?)

  (put '=zero? '(polar)
       (lambda (x)
         (equ? x (make-from-mag-ang 0 0))))

  (put 'raise '(polar)
       (lambda (x) (make-complex-from-mag-ang (magnitude x)
                                              (angle x))))

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

  (define (equ? x y)
    (and (= (real-part x) (real-part y))
         (= (imag-part x) (imag-part y))))

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

  (put 'equ? '(rectangular rectangular) equ?)

  (put '=zero? '(rectangular)
       (lambda (x)
         (equ? x (make-from-real-imag 0 0))))

  (put 'raise '(rectangular)
       (lambda (x) (make-complex-from-real-imag (real-part x)
                                                (imag-part x))))

  'done)

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

  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  (put 'equ? '(complex complex) equ?)

  (put '=zero? '(complex) =zero?)

  ;; raise of complex, will call, raise of polar/rectangular which in turn will
  ;; call make-complex-from-x-x, the whole thing results in a couple of useless
  ;; calls. The other option is raise to be a noop.
  (put 'raise '(complex) raise)

  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

;; as per the book:
;; We can redesign our apply-generic procedure in the following way: For each
;; type, we need to supply a raise procedure, which ``raises'' objects of that
;; type one level in the tower. Then when the system is required to operate on
;; objects of different types it can successively raise the lower types until
;; all the objects are at the same level in the tower.
(define (apply-generic op . args)
  (define (get-highest-ranking-type args)
    (apply max (map get-rank args)))

  (define (raise-args-to-highest-ranking-type args)
    (define (raise-n-times arg n)
      (if (= n 0)
          arg
          (raise-n-times (raise arg) (- n 1))))

    (let ((highest (get-highest-ranking-type args)))
      (map (lambda (x)
             (raise-n-times x (abs (- highest (get-rank x)))))
           args)))

  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (apply apply-generic op (raise-args-to-highest-ranking-type args))))))


(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (equ? x y)
  (apply-generic 'equ? x y))

(define (=zero? x)
  (apply-generic '=zero? x))

(define (raise x)
  (apply-generic 'raise x))

(define (add x y)
  (apply-generic 'add x y))

;; count how many raises are required until x is raised to the top-level type of
;; the tower
(define (get-rank x)
  (let ((y (raise x)))
    (if (eq? (type-tag x) (type-tag y))
        0
        (- (get-rank y) 1))))

(install-scheme-number-package)
(install-rational-package)
(install-polar-package)
(install-rectangular-package)
(install-complex-package)
