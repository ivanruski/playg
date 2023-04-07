;; Exercise 2.22. Louis Reasoner tries to rewrite the first square-list
;; procedure of exercise 2.21 so that it evolves an iterative process:

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items ()))

;; Unfortunately, defining square-list this way produces the answer
;; list in the reverse order of the one desired. Why?

;; ANSWER: The procedure above reverses the input list because Louis
;; is placing each mapped element at the begging of the resulted list.

;; Louis then tries to fix his bug by interchanging the arguments to cons:

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items ()))

;; This doesn't work either. Explain.

;; ANSWER: The fix doesn't work because the result is not a
;; sequence. The cdr of the last element of a sequence must be a (),
;; whereas in Louise's case it's another number. He consructs a nested
;; pairs.
