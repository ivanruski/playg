;; Exercise 3.46. Suppose that we implement test-and-set! using an ordinary
;; procedure as shown in the text, without attempting to make the operation
;; atomic. Draw a timing diagram like the one in figure 3.29 to demonstrate how
;; the mutex implementation can fail by allowing two processes to acquire the
;; mutex at the same time.

(define (make-mutex)
  (let ((cell (list false)))            
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))
(define (clear! cell)
  (set-car! cell false))

(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

;; |  (m 'acquire)                                         (m 'acquire)
;; |
;; |  (test-and-set! (list false))
;; |  (car cell) is false, we enter the else statement
;; |
;; |                                                       (test-and-set! (list false))
;; |                                                       (car cell) is false, we enter the else statement
;; |
;; |  (set-car! cell true)
;; |                                                       (set-car cell true)
;; |
;; |  ;; the mutex is acuired by two different processes
;; |
;; v
