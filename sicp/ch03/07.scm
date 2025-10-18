;; Exercise 3.7. Consider the bank account objects created by make-account, with
;; the password modification described in exercise 3.3. Suppose that our banking
;; system requires the ability to make joint accounts. Define a procedure
;; make-joint that accomplishes this. Make-joint should take three
;; arguments. The first is a password-protected account. The second argument
;; must match the password with which the account was defined in order for the
;; make-joint operation to proceed. The third argument is a new
;; password. Make-joint is to create an additional access to the original
;; account using the new password. For example, if peter-acc is a bank account
;; with password open-sesame, then
;;
;; (define paul-acc
;;   (make-joint peter-acc 'open-sesame 'rosebud))
;;
;; will allow one to make transactions on peter-acc using the name paul-acc and
;; the password rosebud. You may wish to modify your solution to exercise 3.3 to
;; accommodate this new feature.

;; code from exercise 3.3
(define (make-account balance passwd)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (define (show-balance)
    balance)

  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          ((eq? m 'balance) show-balance)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))

  (define (password-protected-dispatch password m)
    (if (eq? passwd password)
        (dispatch m)
        (lambda x "Incorrect password")))

  password-protected-dispatch)

(define (make-joint acc acc-pwd additional-pwd)
  (define (password-protected-dispatch password m)
    (if (eq? password additional-pwd)
        (acc acc-pwd m)
        (lambda x "Incorrect joint account password")))

  password-protected-dispatch)

(define peter-acc (make-account 100 'open-sesame))

((peter-acc 'open-sesame 'balance))
((peter-acc 'open-sesame 'withdraw) 1)

(define paul-acc (make-joint peter-acc 'open-sesame 'rosebud))

((paul-acc 'rosebud 'balance))
((paul-acc 'rosebud 'deposit) 20)

((peter-acc 'open-sesame 'balance))
