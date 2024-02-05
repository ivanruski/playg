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

;; set up
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
  (cons type-tag contents))
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if (not (null? proc))
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

;; Assuming we've installed the polar and the rectangular packages from previous
;; section as well as the complex package

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (make-from-real-imag x y) (cons x y))
  
  ;; interface to the rest of the system
  (define (tag c) (attach-tag 'rectangular c))
  (put 'magnitude '(rectangular) magnitude)
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'make-from-real-imag 'rectangular 
       (lambda (x y) (tag (make-from-real-imag x y))))

  'done)

(define (install-complex-package)
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  ;; imported procedures from rectangular and polar packages
  (define (tag c) (attach-tag 'complex c))

  (put 'magnitude '(complex) magnitude)
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))

  'done)


(install-rectangular-package)
(install-complex-package)

(define (magnitude z) (apply-generic 'magnitude z))
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) 3 4))

(define z (make-complex-from-real-imag 3 4))
(magnitude z)

;; We have two magnitude procedures registered in our table and what is
;; interesting is that the magnitude for complex numbers is poiting to the
;; "public" magnitude procedure. This works becuase apply-generic strips down
;; the type of the datum before calling the proc retrieved from the table - the
;; first time we call magnitude with complex number type, the second time we
;; call it again but this time for rectangular number type which in turn gets
;; from the table the implementation defined in the rectangualar package.

;; Use applicative-order evaluation to show the trace
(magnitude '(complex rectangular 3 . 4))
(apply-generic 'magnitude '(complex rectangular 3 . 4))
(apply (get 'magnitude '(complex)) '((rectangular 3 . 4)))
;; we call the public magnitude again
(magnitude '(rectangular 3 . 4))
(apply-generic 'magnitude '(rectangular 3 . 4))
(apply (get 'magnitude '(rectangular)) '((3 . 4)))
;; the one defined in the rectangular package
((get 'magnitude '(rectangular)) '(3 . 4))
