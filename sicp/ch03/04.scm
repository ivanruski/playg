;; Exercise 3.4. Modify the make-account procedure of exercise 3.3 by adding
;; another local state variable so that, if an account is accessed more than
;; seven consecutive times with an incorrect password, it invokes the procedure
;; call-the-cops.

(define (make-account balance passwd)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))

  (let ((unauth-attempts 0))
    (define (password-protected-dispatch password m)
      (define (authorize)
        (if (eq? password passwd)
            (begin (set! unauth-attempts 0)
                   #t)
            (begin (set! unauth-attempts (+ unauth-attempts 1))
                   #f)))
      (lambda (amount)
        (if (authorize)
            ((dispatch m) amount)
            (if (> unauth-attempts 7)
                (call-the-cops)
                "Incorrect password"))))

    password-protected-dispatch))

;; tests
(define acc (make-account 100 'secret-password))

((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'deposit) 50)
((acc 'secret-password 'deposit) 10)

(define unauth-deposit (acc 'some-other-password 'deposit))
(unauth-deposit 3)
