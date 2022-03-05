;; Exercise 1.34. Suppose we define the procedure
;; 
;; (define (f g)
;;   (g 2))
;; 
;; Then we have
;; 
;; (f square)
;; 4
;; 
;; (f (lambda (z) (* z (+ z 1))))
;; 6
;; 
;; What happens if we (perversely) ask the interpreter to evaluate the combination
;; (f f)? Explain.
;;
;; Answer:
;; The interpreter will throw an error because the 'g' parameter have to be a
;; function. In the initial invocation 'g' is 'f' and the interpreter will have
;; to evaluate (f 2), when the interpreter evaluates and operand and f the result
;; will be (2 2) which is the reason why the interpreter throws an error:
;; "2 is not applicable"
