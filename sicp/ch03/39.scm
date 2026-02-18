;; Exercise 3.39. Which of the five possibilities in the parallel execution
;; shown above remain if we instead serialize execution as follows:
;;
(define x 10)

(define s (make-serializer))

(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))

;; the obvious ones are 101 and 121
;; 100:
;;   1. the serialized (* x x) executes
;;   2. the serialized (set! x (+ x 1)) executes
;;   3. (set! x 100) executes
;; 11 & 110 can't happen
