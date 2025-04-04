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

(define (my-equal? x y)
  (cond ((and (null? x) (null? y)) #t)
        ((or (null? x) (null? y)) #f)
        (else
         (let ((left (car x))
               (right (car y)))
           (if (and (list? left) (list? right))
               (and (my-equal? left right)
                    (my-equal? (cdr x) (cdr y)))
               (and (eq? left right)
                    (my-equal? (cdr x) (cdr y))))))))
