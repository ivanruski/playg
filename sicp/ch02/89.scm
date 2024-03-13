;; Exercise 2.89. Define procedures that implement the term-list representation
;; described above as appropriate for dense polynomials.

;; This exercise implements the bare minimum(even less) to add a to
;; polynomials. The generic-arithmetic.scm file is untouched because the next
;; exercise ask us to implement solution that works for both representations for
;; term-lists.
;;
;; Here my idea is to see what selectors and functions need to be changed if we
;; are to use dense representation for term-lists.

(define (make-poly variable term-list)
  (cons variable term-list))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (variable? x) (symbol? x))

(define (empty-termlist? term-list) (null? term-list))

(define (variable p) (car p))

(define (term-list p) (cdr p))

(define (rest-terms term-list) (cdr term-list))

;; first-term now simply returns the whole term-list
(define (first-term term-list) term-list)

;; order and coeff are changed
(define (order term-list) (- (length term-list) 1))
(define (coeff term-list) (car term-list))

;; adjoin-term accepts coeff instead of term
(define (adjoin-term coeff term-list)
  (cons coeff term-list))

(define (add-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (add-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- ADD-POLY"
             (list p1 p2))))

(define (add-terms L1 L2)
  (cond ((empty-termlist? L1) L2)
        ((empty-termlist? L2) L1)
        (else
         (let ((t1 (first-term L1)) (t2 (first-term L2)))
           (cond ((> (order t1) (order t2))
                  (adjoin-term (coeff t1) ;; replace t1 with (coeff t1)
                               (add-terms (rest-terms L1) L2)))
                 ((< (order t1) (order t2))
                  (adjoin-term (coeff t2) ;; replace t2 with (coeff t2)
                               (add-terms L1 (rest-terms L2))))
                 (else
                  (adjoin-term
                   ;; use + instead of add for simplicity, in this way the
                   ;; coeffs can be only scheme-numbers, but I will fix this in
                   ;; the next exercise.
                   ;;
                   ;; make-term is not needed anymore
                   (+ (coeff t1) (coeff t2))
                   (add-terms (rest-terms L1)
                              (rest-terms L2)))))))))

(define p1 (make-poly 'x '(1 2 0 3 -2 -5)))

(order (first-term (term-list p1)))
(coeff (first-term (term-list p1)))

(order (first-term (rest-terms (term-list p1))))
(coeff (first-term (rest-terms (term-list p1))))
