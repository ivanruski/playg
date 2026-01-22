;; Exercise 3.27. Memoization (also called tabulation) is a technique that
;; enables a procedure to record, in a local table, values that have previously
;; been computed. This technique can make a vast difference in the performance
;; of a program. A memoized procedure maintains a table in which values of
;; previous calls are stored using as keys the arguments that produced the
;; values. When the memoized procedure is asked to compute a value, it first
;; checks the table to see if the value is already there and, if so, just
;; returns that value. Otherwise, it computes the new value in the ordinary way
;; and stores this in the table. As an example of memoization, recall from
;; section 1.2.2 the exponential process for computing Fibonacci numbers:

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

;; The memoized version of the same procedure is

(define memo-fib
  (memoize (lambda (n)
             (cond ((= n 0) 0)
                   ((= n 1) 1)
                   (else (+ (memo-fib (- n 1))
                            (memo-fib (- n 2))))))))

;; where the memoizer is defined as

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
        (or previously-computed-result
            (let ((result (f x)))
              (insert! x result table)
              result))))))

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))

;; Draw an environment diagram to analyze the computation of (memo-fib 3).
;; Explain why memo-fib computes the nth Fibonacci number in a number of
;; steps proportional to n. Would the scheme still work if we had simply defined
;; memo-fib to be (memoize fib)?

;; The diagram gets very messy and not all environments are drawn(with all the
;; lambdas and lets). At some point I gave up and explained what is happening.
;;
;; The state prior to evaluating (memo-fib 3)
;;
;; global env: +-----------------------------------------------------------------------------------------------+
;;             | memoize: ------------------------------------------------------------------+                  |
;;             |                                                                            |                  |
;;             | memo-fib:------------------------------------------------+                 |                  |
;;             |                                                          |                 |                  |
;;             |                                                          |                 |                  |
;;             |                                                          |                 |                  |
;;             +----------------------------------------------------------|-----------------|------------------+
;;                                                      ^                 |                 |            ^
;;                                                      |                 |                 |            |
;;                                                      |                 |                 |            |
;;                                                      |                 |                 |            |
;;                                                      |                 |                 |            |
;;                                                      |                 |                 v            |
;;                           memoize env: +----------------------+        |         +------------------+-|-+
;;                                        | f: <memo-fib lambda> |        |         | parameters: f    | . |
;;                                        +----------------------+        |         | body: <body>     |   |
;;                                                      ^                 |         +------------------+---+
;;                                                      |                 |
;;                       memoize let env: +----------------------+        |    
;;                                        | table: <table>       |        |
;;                                        +----------------------+        |
;;                                                ^                       |
;;                                                |                       |
;;                                                |                       |
;;                                                |                       v
;;                                +---------------+      +-----------------------------+---+
;;                                |               |      | parameters: x               |   |
;;                                |               |      | body: <memoize lambda body> | . |
;;                                |               |      +-----------------------------+-|-+
;;                                |               |                                      |
;;                                |               +--------------------------------------+
;;                                |
;;                                |
;; evaluating (memo-fib 3)        |
;;                                |
;;                                |
;;                         E: +------+
;;                            | x: 3 |
;;                            +------+
;;
;;                         (let ((previously-compute-result...))
;;                           ...)
;;
;; since `previously-computed-result` is false, we enter the (let ((result...))) clause
;; and we invoke f (the memo-fib lambda)
;;
;;     parent env - memoize env, because the <memo-fib lambda> is evaluated "inside" memoize env
;;  E: +-----+
;;     | n:3 |
;;     +-----+
;;
;;    (cond ((= n 0) 0)
;;      ...)
;;
;; evaluating (memo-fib 2)
;;
;;      parent env - memoize let env
;;   E: +------+
;;      | x: 2 |
;;      +------+
;;
;;   (let ((previously-compute-result...))
;;     ...)
;;
;; again, since `previously-computed-result` is false, we enter the (let ((result...))) clause
;; and we invoke f (the memo-fib lambda)
;;
;;     parent env - memoize env, because the <memo-fib lambda> is evaluated "inside" memoize env
;;  E: +-----+
;;     | n:2 |
;;     +-----+
;;
;;    (cond ((= n 0) 0)
;;      ...)
;;
;; ^^^ This will result into two more call to memo-fib - (memo-fib 1) and
;; (memo-fib 0) and after that the call stack should begin to unwind...
;;
;;
;; Explain why memo-fib computes the nth Fibonacci number in a number of
;; steps proportional to n.
;;
;; The number of steps is proportional to n, because the memo-fib stores every
;; computed Fibonacci, starting from lowest to highest and for the nth Fib we
;; already have (n-1)th Fib and (n-2)nd Fib, so computing it is a matter of
;; looking them up in the table.
;;
;;
;; Would the scheme still work if we had simply defined memo-fib to be (memoize
;; fib)?
;;
;; No, it won't work because fib does not rely on the memoization
;; table. memo-fib2 will memoize the final result, which means that the first
;; execution of memo-fib2 will be very slow and the second will return instantly
;; because the result will be in the table.
(define memo-fib2 (memoize fib))

(memo-fib2 34)

(memo-fib2 34)
