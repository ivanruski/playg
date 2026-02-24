;; Exercise 3.44. Consider the problem of transferring an amount from one
;; account to another. Ben Bitdiddle claims that this can be accomplished with
;; the following procedure, even if there are multiple people concurrently
;; transferring money among multiple accounts, using any account mechanism that
;; serializes deposit and withdrawal transactions, for example, the version of
;; make-account in the text above.
;;
;; (define (transfer from-account to-account amount)
;;   ((from-account 'withdraw) amount)
;;   ((to-account 'deposit) amount))
;;
;; Louis Reasoner claims that there is a problem here, and that we need to use a
;; more sophisticated method, such as the one required for dealing with the
;; exchange problem. Is Louis right? If not, what is the essential difference
;; between the transfer problem and the exchange problem? (You should assume
;; that the balance in from-account is at least amount.)

;; Ben's transfer procedure seems good enough for me. If multiple concurrent
;; transactions try to transfer an amount from account X to other accounts, they
;; will succeed as long as the balance is sufficient and since the bank account
;; is protected with the mutex if 2 transactions are racing to withdraw and the
;; balance is enough only for one of the withdrawals, the second one will fail.
;;
;; The only problem I see with Ben's transfer is that if the server crashes
;; right after (from-account 'withdraw) completes, the money will be lost.
;;
;; The difference between exchange & transfer is that exchange reads account's
;; balance and at a later point withdraws some amount, however between checking
;; the balance and withdrawing the difference other transactions can occur.
