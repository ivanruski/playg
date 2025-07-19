;; Used throught section 2.5.3, the code is copied from 86.scm and modified if
;; needed.

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

(define (datum? datum)
  (or (number? datum) (pair? datum)))

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

  (put 'sin-num '(scheme-number)
       (lambda (x) (make-real (sin x))))
  (put 'cos-num '(scheme-number)
       (lambda (x) (make-real (cos x))))
  (put 'atan-num '(scheme-number)
       (lambda (x) (make-real (atan x))))
  (put 'atan-num '(scheme-number scheme-number)
       (lambda (x y) (make-real (atan x y))))
  (put 'sqrt-num '(scheme-number)
       (lambda (x) (make-real (sqrt x))))
  (put 'square-num '(scheme-number)
       (lambda (x) (tag (square x))))

  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))

  (put '=zero? '(scheme-number)
       (lambda (x) (equ? 0 x)))

  (put 'exp '(scheme-number scheme-number)
       (lambda (x y) (tag (expt x y)))) ; using primitive expt

  (put 'raise '(scheme-number)
       (lambda (x) (make-rational x 1)))

  (put 'project '(scheme-number)
       (lambda (x) x))

  (put 'negate '(scheme-number)
       (lambda (x) (- x)))

  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (cond ((not (integer? n)) (error "Numerator must be an integer -- MAKE-RATIONAL" n))
          ((not (integer? d)) (error "Denumerator must be an integer -- MAKE-RATIONAL" d))
          (else
           (let ((g (gcd n d)))
             (let ((n (/ n g))
                   (d (/ d g)))
               (if (negative? (* n d))
                   (cons (- (abs n)) (abs d))
                   (cons (abs n) (abs d))))))))

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
    (make-real (/ (* (numer x) 1.)
                  (denom x))))

  (define (negate-rat x)
    (make-rat (negate (numer x))
              (denom x)))

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

  (put 'project '(rational)
       (lambda (x) (make-scheme-number (round (/ (numer x) (denom x))))))

  (put 'sin-num '(rational)
       (lambda (x) (sin-num (raise x))))
  (put 'cos-num '(rational)
       (lambda (x) (cos-num (raise x))))
  (put 'atan-num '(rational)
       (lambda (x) (atan-num (raise x))))
  (put 'atan-num '(rational rational)
       (lambda (x y) (atan-num (raise x) (raise y))))
  (put 'sqrt-num '(rational)
       (lambda (x) (sqrt-num (raise x))))
  (put 'square-num '(rational)
       (lambda (x) (tag (make-rat (square-num (numer x))
                                  (square-num (denom x))))))

  (put 'negate '(rational)
       (lambda (x) (tag (negate-rat x))))

  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-real-number-package)
  (define (tag x)
    (attach-tag 'real-number x))

  (put 'add '(real-number real-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real-number real-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real-number real-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real-number real-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'real-number
       (lambda (x)
         (if (real? x)
             (tag x)
             (error "not a real number -- MAKE-REAL" x))))

  (put 'sin-num '(real-number)
       (lambda (x) (tag (sin x))))
  (put 'cos-num '(real-number)
       (lambda (x) (tag (cos x))))
  (put 'atan-num '(real-number)
       (lambda (x) (tag (atan x))))
  (put 'atan-num '(real-number real-number)
       (lambda (x y) (tag (atan x y))))
  (put 'sqrt-num '(real-number)
       (lambda (x) (tag (sqrt x))))
  (put 'square-num '(real-number)
       (lambda (x) (tag (square x))))

  (put 'equ? '(real-number real-number)
       (lambda (x y) (= x y)))

  (put '=zero? '(real-number)
       (lambda (x) (equ? 0 x)))

  (put 'exp '(real-number real-number)
       (lambda (x y) (tag (expt x y))))

  ;; Raising to rectangular representation causes issues when we try to drop a
  ;; polar representation
  (put 'raise '(real-number)
       (lambda (x) (make-complex-from-real-imag (tag x) 0)))

  (put 'project '(real-number)
       (lambda (x) (make-rational (round x) 1)))

  (put 'negate '(real-number)
       (lambda (x) (tag (- x))))

  'done)

(define (make-real x)
  ((get 'make 'real-number) x))

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (mul (magnitude z) (cos-num (angle z))))
  (define (imag-part z)
    (mul (magnitude z) (sin-num (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt-num (add (square-num x) (square-num y)))
          (atan-num y x)))

  (define (equ-p? x y)
    (and (equ? (magnitude x) (magnitude y))
         (equ? (angle x) (angle y))))

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

  (put 'equ? '(polar polar) equ-p?)

  (put '=zero? '(polar)
       (lambda (x)
         (equ? x (make-from-mag-ang 0 0))))

  (put 'raise '(polar)
       (lambda (x) (make-complex-from-mag-ang (magnitude x)
                                              (angle x))))

  (put 'project '(polar)
       (lambda (x)
         (let ((rp (real-part x)))
           (if (eq? (type-tag rp) 'real-number)
               rp
               (error "real-part of polar is not real-number -- PROJECT-POLAR" rp)))))

  (put 'project '(polar)
       (lambda (x)
         (let ((real-p (real-part x))
               (typ (type-tag (real-part x))))
           (cond ((eq? typ 'scheme-number) (make-real real-p))
                 ((eq? typ 'rational) (raise real-p))
                 ((eq? typ 'real-number) real-p)
                 (else ;; should be a complex
                  (project real-p))))))

  (put 'negate '(polar)
       (lambda (x) (error "TODO(negate polar) -- not implemented")))

  'done)

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt-num (add (square-num (real-part z))
                   (square-num (imag-part z)))))
  (define (angle z)
    (atan-num (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (mul r (cos-num a)) (mul r (sin-num a))))

  (define (equ-r? x y)
    (and (equ? (real-part x) (real-part y))
         (equ? (imag-part x) (imag-part y))))

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

  (put 'equ? '(rectangular rectangular) equ-r?)

  (put '=zero? '(rectangular)
       (lambda (x)
         (equ-r? x (make-from-real-imag 0 0)))) ;; TODO: fix in corresponding exercise

  (put 'raise '(rectangular)
       (lambda (x) (make-complex-from-real-imag (real-part x)
                                                (imag-part x))))

  (put 'project '(rectangular)
       (lambda (x)
         (let ((real-p (real-part x))
               (typ (type-tag (real-part x))))
           (cond ((eq? typ 'scheme-number) (make-real real-p))
                 ((eq? typ 'rational) (raise real-p))
                 ((eq? typ 'real-number) real-p)
                 (else ;; should be a complex
                  (project real-p))))))

  (put 'negate '(rectangular)
       (lambda (x)
         (tag (make-from-real-imag (negate (real-part x))
                                   (negate (imag-part x))))))

  'done)

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  ;; adding/multiplying/subtracting/dividing in this way means that we can
  ;; multiply to rectangular representation and get polar representation as a
  ;; result and vice-versa ... I am not going to address this
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

  (define (complex-equ? x y)
    (and (eq? (type-tag x) (type-tag y))
         (equ? x y)))

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

  (put 'equ? '(complex complex) complex-equ?)

  (put '=zero? '(complex) =zero?)

  (put 'project '(complex) project)  

  ;; raise of complex, will call, raise of polar/rectangular which in turn will
  ;; call make-complex-from-x-x, the whole thing results in a couple of useless
  ;; calls. The other option is raise to be a noop.
  (put 'raise '(complex) raise)

  (put 'negate '(complex) negate)

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

  ;; TODO: if proc does not exisit, it will loop forever
  (define (apply-op)
    (let ((type-tags (map type-tag args)))
      (let ((proc (get op type-tags)))
        (if proc
            (apply proc (map contents args))
            (apply apply-generic op (raise-args-to-highest-ranking-type args))))))

  (let ((result (apply-op)))
    (cond ((not (datum? result)) result)
          ((eq? op 'raise) result)
          ((eq? op 'project) result)
          (else
           (drop result)))))


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

(define (sub x y)
  (apply-generic 'sub x y))

(define (mul x y)
  (apply-generic 'mul x y))

(define (div x y)
  (apply-generic 'div x y))

(define (sin-num x)
  (apply-generic 'sin-num x))

(define (cos-num x)
  (apply-generic 'cos-num x))

(define (atan-num x . y)
  (cond ((= (length y) 0) (apply-generic 'atan-num x))
        ((= (length y) 1) (apply-generic 'atan-num x (car y)))
        (else
         (error "atan-num requires between 1 and 2 arguments"))))

(define (sqrt-num x)
  (apply-generic 'sqrt-num x))

(define (square-num x)
  (apply-generic 'square-num x))

;; count how many raises are required until x is raised to the top-level type of
;; the tower
;;
;; get-rank requires each type in the generic arithmetic package to define a
;; raise procedure.
(define (get-rank x)
  (let ((y (raise x)))
    (if (eq? (type-tag x) (type-tag y))
        0
        (- (get-rank y) 1))))

(define (project x)
  (apply-generic 'project x))

(define (drop x)
  (let ((dropped (project x)))
    (if (equ? x (raise dropped))
        dropped
        x)))

(define (negate x)
  (apply-generic 'negate x))

(install-scheme-number-package)
(install-rational-package)
(install-real-number-package)
(install-polar-package)
(install-rectangular-package)
(install-complex-package)
