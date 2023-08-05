;; Exercise 2.54. Two lists are said to be equal? if they contain equal elements
;; arranged in the same order. For example,
;;
;; (equal? '(this is a list) '(this is a list))
;; 
;; is true, but
;;
;; (equal? '(this is a list) '(this (is a) list))
;;
;; is false. To be more precise, we can define equal? recursively in terms of
;; the basic eq? equality of symbols by saying that a and b are equal? if they
;; are both symbols and the symbols are eq?, or if they are both lists such that
;; (car a) is equal? to (car b) and (cdr a) is equal? to (cdr b). Using this
;; idea, implement equal? as a procedure.

(define (equal2? x y)
  (cond ((and (null? x) (null? y)) #t)
        ((and (list? x) (list? y))
         (and (equal2? (car x) (car y))
              (equal2? (cdr x) (cdr y))))
        (else
         (eq? x y))))

(equal2? '(this is a list) '(this is a list))
(equal2? '(this is a list) '(this (is a) list))

(equal2? (cons 1 2) (cons 1 2)) ;; in order for this to work I have to replace list? with pair?
(equal? (cons 1 2) (cons 1 2))


