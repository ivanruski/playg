;; Exercise 1.26. Louis Reasoner is having great difficulty doing exercise
;; 1.24. His fast-prime? test seems to run more slowly than his prime? test. Louis
;; calls his friend Eva Lu Ator over to help. When they examine Louis's code, they
;; find that he has rewritten the expmod procedure to use an explicit
;; multiplication, rather than calling square:

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

;; "I don't see what difference that could make," says Louis. "I do." says
;; Eva. "By writing the procedure like that, you have transformed the O(log n)
;; process into a O(n) process." Explain.

;; By doing explicit multiplication instead of squaring, Louis's version
;; generates a tree recursive process, where for each even exp, he is calling
;; expmod twice. For example with exp = 64, the process will be a perfectly
;; balanced binary tree with 63 nodes where each node is a call to expmod.
;; His version resembles the slow version of fibonacci from secion 1.2.2.
