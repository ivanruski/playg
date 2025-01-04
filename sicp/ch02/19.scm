;; Exercise 2.19. Consider the change-counting program of section 1.2.2. It
;; would be nice to be able to easily change the currency used by the program,
;; so that we could compute the number of ways to change a British pound, for
;; example. As the program is written, the knowledge of the currency is
;; distributed partly into the procedure first-denomination and partly into the
;; procedure count-change (which knows that there are five kinds of
;; U.S. coins). It would be nicer to be able to supply a list of coins to be
;; used for making change.
;;
;; We want to rewrite the procedure cc so that its second argument is a list of
;; the values of the coins to use rather than an integer specifying which coins
;; to use. We could then have lists that defined each kind of currency:
;;
;; (define us-coins (list 50 25 10 5 1))
;; (define uk-coins (list 100 50 20 10 5 2 1 0.5))
;;
;; We could then call cc as follows:
;;
;; (cc 100 us-coins)
;; 292
;;
;; To do this will require changing the program cc somewhat. It will still have
;; the same form, but it will access its second argument differently, as
;; follows:

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

;; Define the procedures first-denomination, except-first-denomination, and
;; no-more? in terms of primitive operations on list structures.

(define (no-more? coin-values)
  (null? coin-values))

(define (first-denomination coin-values)
  (car coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define us-coins (list 50 25 10 5 1))
(cc 100 us-coins)

(define uk-coins (list 100 50 20 10 5 2 1 0.5))
(cc 100 uk-coins)

;; Does the order of the list coin-values affect the answer produced by cc? Why
;; or why not?
;;
;; I thought it will affect the order, because if we have a (cc 100 (list 50 30 20))
;; at some point we'll try to compute (cc 100 (list 30 20)), whereas if the list was
;; reversed we wouldn't have such an invocation. However I was wrong. In both cases
;; all possible combinations are tested.
;; When the list is reversed to (cc 100 (list 20 30 50)), we don't have (cc 100 (list 20 30))
;; but the other branch covers it, we have (cc <n times 100 - 20 > (list 30 50))

(define coins (list 1 2 3 4 5))

(cc 123 coins)
(cc 123 (reverse coins))
