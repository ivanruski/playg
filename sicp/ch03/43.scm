;; Exercise 3.43. Suppose that the balances in three accounts start out as $10,
;; $20, and $30, and that multiple processes run, exchanging the balances in the
;; accounts. Argue that if the processes are run sequentially, after any number
;; of concurrent exchanges, the account balances should be $10, $20, and $30 in
;; some order. Draw a timing diagram like the one in figure 3.29 to show how
;; this condition can be violated if the exchanges are implemented using the
;; first version of the account-exchange program in this section. On the other
;; hand, argue that even with this exchange program, the sum of the balances in
;; the accounts will be preserved. Draw a timing diagram to show how even this
;; condition would be violated if we did not serialize the transactions on
;; individual accounts.

;; Part 1 - Argue that if the processes are run sequentially, after any number
;; of concurrent exchanges, the account balances should be $10, $20, and $30 in
;; some order
;;
;; P1  (exchange a1 a3)      P2 (exchange a3 a1)      P3 (exchange a1 a2)
;;     (exchange a2 a1)         (exchange a3 a2)         (exchange a2 a3)
;;
;; Reglardles of the order we execute P1, P2, and P3 the balances will be 10,
;; 20, and 30 - exchange will simply swap the balances from <ax> & <ay>.
;;
;;
;; Part 2 - If the processes run concurrently and we use the first version of
;; the exchange procedure bad things will happen
;;
;; | T1 (exchange a1 a3) (from P1)
;; |     - difference = -20
;; |     
;; |
;; | T2 (exchange a2 a1) 
;; |     - difference = 10
;; |     - ((a2 'withdraw 10)) -> a2 balance = 10
;; |     - ((a1 'deposit 10))  -> a1 balance = 20
;; |
;; |
;; | T3 continuing from T1
;; |     - ((a1 'withdraw) -20) -> a1 balance = 40
;; |     - ((a3 'deposit) -20)  -> a3 balance = 10
;; |
;; | a1 = 40    a2 = 10    a3 = 10 (the sum remains 60)
;; |
;; v
;;
;;
;; Part 3 - If the processes run concurrently and we don't serialize worse
;; things will happen
;;
;; | T1 (exchange a1 a3) (from P1)
;; |     - difference = -20
;; |     
;; |
;; | T2 (exchange a2 a1) 
;; |     - difference = 10
;; |     - ((a2 'withdraw) 10) -> a2 balance = 10
;; |
;; |
;; | T3 continuing from T1
;; |     - ((a1 'withdraw) -20)
;; |     - evaluate balance to be 10
;; |
;; |
;; | T4 continuing from T2
;; |     - ((a1 'deposit) 10)
;; |     - evaluate balance to be 10
;; |
;; | T5 continuing from T3
;; |     - set balance to 30 (- 10 -20)
;; |
;; | T6 continuing from T4
;; |     - set balance to 20 (+ 10 10) -> a1 balance = 20
;; |
;; | a1 = 20    a2 = 10    a3 = 10 (the sum is 40, $20 got lost)
;; v
;;
;; This issue is not present in Part 2 because when the accounts are protected
;; by the mutex each withdraw & deposit are executed sequentially.


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
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

