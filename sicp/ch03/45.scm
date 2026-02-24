;; Exercise 3.45. Louis Reasoner thinks our bank-account system is unnecessarily
;; complex and error-prone now that deposits and withdrawals aren't
;; automatically serialized. He suggests that make-account-and-serializer should
;; have exported the serializer (for use by such procedures as
;; serialized-exchange) in addition to (rather than instead of) using it to
;; serialize accounts and deposits as make-account did. He proposes to redefine
;; accounts as follows:

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
            ((eq? m 'deposit) (balance-serializer deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

;; Then deposits are handled as with the original make-account:

(define (deposit account amount)
 ((account 'deposit) amount))

;; Explain what is wrong with Louis's reasoning. In particular, consider what
;; happens when serialized-exchange is called.

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
     account1
     account2)))

;; Using the serializer within the private withdraw and deposit as well as in
;; serialized-exchange will cause the program to halt. serialized-exchange must
;; complete in order for 'withdraw or 'deposit to execute. This is a classic
;; deadlock example.
