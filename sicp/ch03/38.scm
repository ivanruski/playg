;; Exercise 3.38. Suppose that Peter, Paul, and Mary share a joint bank account
;; that initially contains $100. Concurrently, Peter deposits $10, Paul
;; withdraws $20, and Mary withdraws half the money in the account, by executing
;; the following commands:
;;
;; Peter:	(set! balance (+ balance 10))
;; Paul:	(set! balance (- balance 20))
;; Mary:	(set! balance (- balance (/ balance 2)))
;;
;; a. List all the different possible values for balance after these three
;; transactions have been completed, assuming that the banking system forces the
;; three processes to run sequentially in some order.
;;
;; b. What are some other values that could be produced if the system allows the
;; processes to be interleaved? Draw timing diagrams like the one in figure 3.29
;; to explain how these values can occur.

;; a. The possible executions are (permutations of the three)
;; 1. Peter, 2. Paul, 3. Mary - 110 -> 90 -> 45
;; 1. Peter, 2. Mary, 3. Paul - 110 -> 55 -> 35
;; 1. Paul, 2. Peter, 3. Mary -  80 -> 90 -> 45
;; 1. Paul, 2. Mary, 3. Peter -  80 -> 40 -> 50
;; 1. Mary, 2. Paul, 3. Peter -  50 -> 30 -> 40
;; 1. Mary, 2. Peter, 3. Paul -  50 -> 60 -> 40

;; b.
;;
;; b.1. One possible outcome is to look like the only thing that happend in the
;; account was Peter depositing his $10.
;;
;; |                        account: $100
;; |
;; | T1  Peter reads the balance: $100
;; |
;; | T2  Paul reads the balance: $100
;; |
;; | T3  Mary reads the balance: $100
;; |
;; | T4  Mary computing (- balance (/ balance 2)))
;; |
;; | T5  Mary setting balance to 50
;; |
;; | T6  Paul computing (- balance 20)
;; |
;; | T7  Peter computing (+ balance 10)
;; |
;; | T8  Paul setting balance to 80
;; |
;; | T9  Peter setting balance to 110
;; |
;; v
