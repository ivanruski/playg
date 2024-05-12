;; Exercise 2.92. By imposing an ordering on variables, extend the polynomial
;; package so that addition and multiplication of polynomials works for
;; polynomials in different variables. (This is not easy!)

;; NOTES:
;;
;; - I might break a lot of things, but I am not going to regression test the
;;   whole artithmetic package.
;; - The whole thing became spaghetti code

;; I use a hybrid approach between tower types and coercion. I have a "type
;; family" e.g. the 'scheme-number', 'real', 'complex', 'rational' types belong
;; to the same family type, whereas the polynomial and the term-lists belong to
;; another type family.
;;
;; If I try to perform operation between types from the same type family I use
;; the logic implemented in exercises 2.83-85 and if the types are from
;; different type families coercion is applied and then the logic(2.83-85) is
;; used.

;; TODOs
;; 1. I need to be able to find which will be leading variable e.g. when adding
;; X polynomial with Y polynomial, the X will be the leading (x is before y)
;;
;; 2. I need to be able to convert polynomial in Y to polynomial in X e.g. the
;; polynomial y^2 + 1 is represented as '(y (sparse-term-list (2 1) (0 1))) must
;; be converted to: '(x (sparse-term-list (0 ((y (sparse-term-list (2 1) (0 1)))))))
;; and if it is a dense-term-list: '(y (dense-term-list 1 0 1)) must be converted to:
;; '(x (dense-term-list (y (dense-term-list 1 0 1))))

(sort '(z y x b c a d f h j) (lambda (a b)
                 (string<? (symbol->string a)
                           (symbol->string b))))

(define (first-lexical a b)
  (if (symbol<? a b))
      a
      b)

(make-polynomial 'x (make-sparse-term-list (list '(5 1)
                                                 (list 0 (make-polynomial 'y (make-sparse-term-list '((2 1) (0 1))))))))

(add 1 1)

(add (make-sparse-term-list '((5 1)))
     (make-sparse-term-list '((2 1))))

(add 1
     (make-sparse-term-list '((2 1))))

(add (make-sparse-term-list '((0 1)))
     (make-sparse-term-list '((2 1))))

(add (make-polynomial 'x (make-sparse-term-list (list '(2 1))))
     (make-polynomial 'y (make-sparse-term-list (list '(2 1)))))
