;; Exercise 3.35. Ben Bitdiddle tells Louis that one way to avoid the trouble in
;; exercise 3.34 is to define a squarer as a new primitive constraint. Fill in
;; the missing portions in Ben's outline for a procedure to implement such a
;; constraint:

(define (squarer a b)
  (define (process-new-value)
    (if (has-value? b)
        (if (< (get-value b) 0)
            (error "square less than 0 -- SQUARER" (get-value b))
            (set-value! a (sqrt (get-value b)) me))
        (if (has-value? a)
            ;; allow negative values for a
            (set-value! b (square (get-value a)) me))))

  (define (process-forget-value)
    (forget-value! a)
    (forget-value! b)
    (process-new-value))

  (define (me request)
    (cond ((eq? request 'I-have-a-value) (process-new-value))
          ((eq? request 'I-lost-my-value) (process-forget-value))
          (else
           (error "Unknown request -- SQUARER" request))))

  (connect a me)
  (connect b me)
  me)

;; (in order for the examples below to work, import 33.scm)

(define a (make-connector))
(define b (make-connector))

(squarer a b)

(set-value! a -4 'user)
(get-value b)
;; 16

(define a (make-connector))
(define b (make-connector))

(squarer a b)

(set-value! b 36 'user)
(get-value a)
;; 6
