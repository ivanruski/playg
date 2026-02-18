;; Exercise 3.40. Give all possible values of x that can result from executing

(define x 10)

(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))

;; Which of these possibilities remain if we instead use serialized procedures:

(define x 10)

(define s (make-serializer))

(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (* x x x)))))

;; For the first example:
;; 1 000 000
;;   1. (set! x (* x x)) executes
;;   2. (set! x (* x x x)) executes
;;
;; 1 000 000
;;   1. (set! x (* x x x)) executes
;;   2. (set! x (* x x)) executes
;;
;; 10 000
;;   1. (set! x (* x x)) evaluates the first x to 10
;;   2. (set! x (* x x x)) executes
;;   3. 1. evaluates the second x to 1000 and computes
;;
;; 10 000
;;   1. (set! x (* x x x)) evaluates the first x & the second x to 10
;;   2. (set! x (* x x)) executes
;;   3. 1. evaluates the the third xs to 100 and computes
;;
;; 100 000
;;   1. (set! x (* x x x)) evaluates the first x to 10
;;   2. (set! x (* x x)) executes
;;   3. 1. evaluates the second & the third xs to 100 and computes
;;
;; 100
;;   1. (* x x) computes
;;   2. (set! x (* x x x)) completes
;;   3. 1. sets x to 100
;;
;; 1000
;;   1. (* x x x) computes
;;   2. (set! x (* x x)) completes
;;   3. 1. sets x to 1000

;; For the second example:
;; 1 000 000
;;   1. (set! x (* x x)) executes
;;   2. (set! x (* x x x)) executes
;;
;; 1 000 000
;;   1. (set! x (* x x x)) executes
;;   2. (set! x (* x x)) executes
