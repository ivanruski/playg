;; Exercise 2.77. Louis Reasoner tries to evaluate the expression (magnitude z)
;; where z is the object shown in figure 2.24. To his surprise, instead of the
;; answer 5 he gets an error message from apply-generic, saying there is no
;; method for the operation magnitude on the types (complex). He shows this
;; interaction to Alyssa P. Hacker, who says ``The problem is that the
;; complex-number selectors were never defined for complex numbers, just for
;; polar and rectangular numbers. All you have to do to make this work is add
;; the following to the complex package:''
;;
;; (put 'real-part '(complex) real-part)
;; (put 'imag-part '(complex) imag-part)
;; (put 'magnitude '(complex) magnitude)
;; (put 'angle '(complex) angle)
;;
;; Describe in detail why this works. As an example, trace through all the
;; procedures called in evaluating the expression (magnitude z) where z is the
;; object shown in figure 2.24. In particular, how many times is apply-generic
;; invoked? What procedure is dispatched to in each case?

(define (attach-tag tag datum)
  (cons tag datum))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "invalid datum -- CONTENTS" datum)))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "invalid datum -- TYPE-TAG" datum)))

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
        (error "unknown combination of operation and type -- GET" op type))))

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

  ;; comment/uncomment to reproduce
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(install-polar-package)
(install-rectangular-package)
(install-complex-package)

(magnitude (make-complex-from-real-imag 3 4))

;; Alyssa is write, there is no '(complex) column for the rows 'real-part',
;; `imag-part`, etc, in the ddp table.
;;
;; Here clever suggestion works because apply-generic strips the outtermost type
;; of the datum and passes its contents to the result obtained from calling (get
;; op type-tags). The first call to (magnitude complex-num), results in
;; stripping the 'complex tag, and since the magnitude implementation in the DDP
;; table is the same one we've provided to the users of the package, the
;; procedure is called again but the second time, the outtermost tag is
;; 'rectangular.
;;
;; As a result apply-generic is called twice. The first time it dispatches to
;; the same procedure that called it(the public magnitude), the second time
;; dispatches to the internal magnitude defined in the rectangular package.
