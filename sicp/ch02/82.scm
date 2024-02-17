;; Exercise 2.82. Show how to generalize apply-generic to handle coercion in the
;; general case of multiple arguments. One strategy is to attempt to coerce all
;; the arguments to the type of the first argument, then to the type of the
;; second argument, and so on. Give an example of a situation where this
;; strategy (and likewise the two-argument version given above) is not
;; sufficiently general. (Hint: Consider the case where there are some suitable
;; mixed-type operations present in the table that will not be tried.)

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

;;;; tests

;; define type hierarchy
;; foo
(define (install-foo-package)

  (define (concat foo1 foo2)
    (cons foo1 foo2))

  (define (tag foo) (attach-tag 'foo foo))
  (put 'concat '(foo foo) (lambda (foo1 foo2) (tag (concat foo1 foo2))))
  (put 'make 'foo (lambda (foo) (tag foo)))

  'done)

(define (make-foo foo)
  ((get 'make 'foo) foo))

;; bar
(define (install-bar-package)

  (define (concat bar1 bar2)
    (cons bar1 bar2))

  (define (tag bar) (attach-tag 'bar bar))
  (put 'concat '(bar bar) (lambda (bar1 bar2) (tag (concat bar1 bar2))))
  (put 'make 'bar (lambda (bar) (tag bar)))

  'done)

;; baz
(define (make-bar bar)
  ((get 'make 'bar) bar))

(define (install-baz-package)

  (define (concat baz1 baz2)
    (cons baz1 baz2))

  (define (tag baz) (attach-tag 'baz baz))
  (put 'concat '(baz baz) (lambda (baz1 baz2) (tag (concat baz1 baz2))))
  (put 'make 'baz (lambda (baz) (tag baz)))

  'done)

(define (make-baz baz)
  ((get 'make 'baz) baz))

(define (concat a b)
  (apply-generic 'concat a b))

;; setup
(install-foo-package)
(install-bar-package)
(install-baz-package)

(put-coercion 'foo 'bar (lambda (foo) (make-bar (contents foo))))
(put-coercion 'foo 'baz (lambda (foo) (make-baz (contents foo))))
(put-coercion 'bar 'baz (lambda (bar) (make-baz (contents bar))))

;; test using the fake types
(concat (make-foo (cons 1 2)) (make-foo (cons 3 4)))
(concat (make-foo (cons 1 2)) (make-bar (cons 3 4)))
(concat (make-foo (cons 1 2)) (make-baz (cons 3 4)))
(concat (make-bar (cons 1 2)) (make-baz (cons 3 4)))

;; test apply-generic with the numbers package
(add (make-scheme-number 5) (make-rational 7 5))
(add (make-scheme-number 5) (make-complex-from-real-imag 7 5))

;; Give an example of a situation where this strategy is not sufficiently general.
;;
;; The current version of apply-generic will work only with types with direct
;; relationships. If in my coercion table foo->baz was missing, we won't be able to
;; call concat defined in the baz package.
;; e.g.

;; clear the coercion table
(define coercion-table '())
(put-coercion 'foo 'bar (lambda (foo) (make-bar (contents foo))))
(put-coercion 'bar 'baz (lambda (bar) (make-baz (contents bar))))

(concat (make-foo (cons 1 2)) (make-bar (cons 3 4))) ;; works
(concat (make-foo (cons 1 2)) (make-baz (cons 3 4))) ;; breaks
(concat ((get-coercion 'foo 'bar) (make-foo (cons 1 2))) ;; works
        (make-baz (cons 3 4)))
