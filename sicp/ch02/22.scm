;; Exercise 2.22.  Louis Reasoner tries to rewrite the first square-list
;; procedure of exercise 2.21 so that it evolves an iterative process:

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items '()))

;; Unfortunately, defining square-list this way produces the answer list in the
;; reverse order of the one desired. Why?
;;
;; Louis then tries to fix his bug by interchanging the arguments to cons:

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items '()))

;; This doesn't work either. Explain.

;; The first implementation is incorrect, because the function squares the first
;; element and puts it in the result, then it squares the second element and
;; puts it in front of the result and so on. If we remove the square from the
;; square-list function, the implementation will closely resemble how one might
;; write the reverse function.
;;
;; The second implementation is incorrect, because Louis cons pairs NOT
;; lists. Using append instead of cons should solve his problems.
