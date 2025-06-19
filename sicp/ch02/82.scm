;; Exercise 2.82. Show how to generalize apply-generic to handle coercion in the
;; general case of multiple arguments. One strategy is to attempt to coerce all
;; the arguments to the type of the first argument, then to the type of the
;; second argument, and so on. Give an example of a situation where this
;; strategy (and likewise the two-argument version given above) is not
;; sufficiently general. (Hint: Consider the case where there are some suitable
;; mixed-type operations present in the table that will not be tried.)

;; Coercing to the type of the first and then to the type of the second will not
;; work in the following case:
;;
;; If we have types: a -> b -> c and have a proc which can be applied for b c,
;; if we call (proc a c), we'll try a->c and c->a and we'll miss (b c).

;; setup
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

(define coercion-table '())

(define (put-coercion from to coercion-fn)
  (set! coercion-table (cons (list from to coercion-fn)
                             (filter (lambda (entry)
                                       (not (and (eq? from (car entry)) (eq? to (cadr entry)))))
                                     coercion-table))))

(define (get-coercion from to)
  (let ((coercion-entry (find (lambda (entry)
                                (and (eq? from (car entry)) (eq? to (cadr entry))))
                              coercion-table)))
    (if coercion-entry
        (caddr coercion-entry)
        coercion-entry)))


(define (apply-generic op . args)
  (define (find-type-to-coerce-to types)
    (define (iter-types prev next)
      (if (null? next)
          '()
          (let ((curr-type (car next))
                (to-types (append prev (cdr next))))
            (let ((coercable (filter (lambda (t)
                                       (if (eq? t curr-type)
                                           t
                                           (get-coercion t curr-type)))
                                     to-types)))
              (if (= (length coercable) (length to-types))
                  curr-type
                  (iter-types (append prev (list curr-type)) (cdr next)))))))
    (iter-types '() types))

  (define (coerce-args args to-type)
    (map (lambda (arg)
           (if (eq? (type-tag arg) to-type)
               arg
               (let ((coerce-fn (get-coercion (type-tag arg) to-type)))
                 (coerce-fn arg))))
         args))

  (let ((types (map type-tag args)))
    (let ((proc (get op types)))
      (if proc
          (apply proc (map contents args))
          (let ((coerce-to (find-type-to-coerce-to types)))
            (if (null? coerce-to)
                (error "No method for these types" (list op types))
                (let ((c-args (coerce-args args coerce-to)))
                  (let ((proc (get op (map type-tag c-args))))
                    (if proc
                        (apply proc (map contents c-args))
                        (error "No method for these types" (list op types)))))))))))

;; Example
(define (install-foo-package)

  (put 'make '(foo) (lambda (x) (attach-tag 'foo x)))

  'done)

(define (install-bar-package)

  (put 'make '(bar) (lambda (x) (attach-tag 'bar x)))

  'done)

(define (install-baz-package)

  (define (concat a b c)
    (list a b c))

  (put 'concat '(baz baz baz)
       (lambda (a b c)
         (attach-tag 'baz (concat a b c))))

  (put 'make '(baz) (lambda (x) (attach-tag 'baz x)))

  'done)

(put-coercion 'foo 'bar (lambda (x) (attach-tag 'bar (contents x))))
(put-coercion 'bar 'baz (lambda (x) (attach-tag 'baz (contents x))))

(define (make-foo x)
  ((get 'make '(foo)) x))

(define (make-bar x)
  ((get 'make '(bar)) x))

(define (make-baz x)
  ((get 'make '(baz)) x))

(define (concat x y z)
  (apply-generic 'concat x y z))

(concat (make-baz 1) (make-baz 2) (make-baz 3))
(concat (make-foo 1) (make-bar 2) (make-baz 3))
(concat (make-bar 1) (make-baz 2) (make-bar 3))
