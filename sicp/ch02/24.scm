;; Exercise 2.24. Suppose we evaluate the expression:
;; (list 1 (list 2 (list 3 4))).
;; Give the result printed by the interpreter, the corresponding
;; box-and-pointer structure, and the interpretation of this as a
;; tree (as in figure 2.6).

;; The result printed by the interpreter should be:
;; (1 (2 (3 4)))

;; The box-and-pointer structure should be:
;;
;; |---+---|       |---+---|       
;; | 1 |   | ----> |    | x |
;; |---+---|       |---+---|
;;                   |
;;                   |
;;                 |---+---|       |---+---|
;;                 | 2 |   | ----> |    | x |
;;                 |---+---|       |---+---|
;;                                   |
;;                                   |
;;                                 |---+---|      |---+---| 
;;                                 |  3 |   | ---> | 4 | x |
;;                                 |---+---|      |---+---|
;;
;; This is a list of two elements, the first element is 1, the second element is
;; another list.

(define t (list 1 (list 2 (list 3 4))))

(length t)

;; The tree should look like this, with 4 nodes.
;; (1 (2 (3 4)))
;;     /\
;;    1  \(2 (3 4))
;;       /\ 
;;      2  \ (3 4)
;;         /\
;;        3  4

(define (count-leaves x)
  (cond ((null? x) 0)  
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(count-leaves t)
