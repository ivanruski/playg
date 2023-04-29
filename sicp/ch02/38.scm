;; Exercise 2.38. The accumulate procedure is also known as fold-right,
;; because it combines the first element of the sequence with the result
;; of combining all the elements to the right. There is also a fold-left,
;; which is similar to fold-right, except that it combines elements
;; working in the opposite direction:

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

;; What are the values of

(fold-right / 1 (list 1 2 3)) ;; 3/2
(fold-left / 1 (list 1 2 3)) ;; 1/6 
(fold-right list '() (list 1 2 3)) ;; (1 (2 (3 ())))
(fold-left list '() (list 1 2 3)) ;; (((() 1) 2) 3)

;; Give a property that op should satisfy to guarantee that fold-right
;; and fold-left will produce the same values for any sequence.

;; The op should have associative property in order for the two procedures
;; to produce the same values for any sequence

(fold-right + 0 (list 2 3 5 8 9 9 123))
(fold-left + 0 (list 2 3 5 8 9 9 123))

(fold-right - 0 (list 2 3 5 8 9 9 123))
(fold-left - 0 (list 2 3 5 8 9 9 123))
