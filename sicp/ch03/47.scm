;; Exercise 3.47. A semaphore (of size n) is a generalization of a mutex. Like a
;; mutex, a semaphore supports acquire and release operations, but it is more
;; general in that up to n processes can acquire it concurrently. Additional
;; processes that attempt to acquire the semaphore must wait for release
;; operations. Give implementations of semaphores
;;
;; a. in terms of mutexes
;;
;; b. in terms of atomic test-and-set! operations.

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

;; a.

(define (make-semaphore n)
  (let ((m (make-mutex))
        (slots n))
    (define (acquire)
      (m 'acquire)
      (cond ((> slots 0)
             (set! slots (- slots 1))
             (m 'release))
            (else
             ;; if n is 0, release the mutex to allow for other processes to
             ;; release it and try again. With this implementation the processes
             ;; trying to release and acquire it will race for acquire the mutex
             (m 'release)
             (acquire))))

    (define (release)
      (m 'acquire)
      (if (< slots n) (set! slots (+ slots 1)))
      (m 'release))

    (define (the-semaphore m)
      (cond ((eq? m 'acquire) (acquire))
            ((eq? m 'release) (release))
            (else
             (error "unknown operation -- SEMAPHORE" m))))

    the-semaphore))

;; b. To me "b" is weird, it's "a" but with the mutex inlined

(define (make-semaphore n)
  (let ((slots n)
        (lock (list false)))
    
    (define (acquire)
      (if (test-and-set! lock)
          (acquire)
          (if (> slots 0)
              (begin (set! slots (- slots 1))
                     (clear! lock))
              (begin (clear! lock)
                     (acquire)))))

    (define (release)
      (if (test-and-set! lock)
          (release)
          (begin (set! slots (min n (+ slots 1)))
                 (clear! lock))))

    (define (the-semaphore m)
      (cond ((eq? m 'acquire) (acquire))
            ((eq? m 'release) (release))
            (else
             (error "unknown operation -- SEMAPHORE" m))))

    the-semaphore))
