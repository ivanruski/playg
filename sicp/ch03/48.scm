;; Exercise 3.48. Explain in detail why the deadlock-avoidance method described
;; above, (i.e., the accounts are numbered, and each process attempts to acquire
;; the smaller-numbered account first) avoids deadlock in the exchange
;; problem. Rewrite serialized-exchange to incorporate this idea. (You will also
;; need to modify make-account so that each account is created with a number,
;; which can be accessed by sending an appropriate message.)

;; The method will work, because the order in which the accounts are locked will
;; be the same for everyone, and the first process to lock the account with the
;; lower id "wins" and can proceed to lock the higher id one.

;; We need some function which will produce the unique account ids and which can
;; be called concurrently
(define (make-protected-inc)
  (let ((num 0)
        (s (make-serializer)))

    (define (inc)
      (set! num (+ num 1))
      num)

    (s inc)))

(define protected-inc (make-protected-inc))

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer))
        (acc-id (protected-inc)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            ((eq? m 'get-id) acc-id)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (define (s-exchange account1 account2)
    (let ((serializer1 (account1 'serializer))
          (serializer2 (account2 'serializer)))
      ((serializer1 (serializer2 exchange))
       account1
       account2)))

  (let ((acc1-id (account1 'get-id))
        (acc2-id (account2 'get-id)))
    (if (< acc1-id acc2-id)
        (s-exchange account1 account2)
        (s-exchange account2 account1))))
    

;; copied from the book
(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))

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

