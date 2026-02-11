;; Exercise 3.36. Suppose we evaluate the following sequence of expressions in
;; the global environment:
;;
;; (define a (make-connector))
;; (define b (make-connector))
;; (set-value! a 10 'user)
;;
;; At some time during evaluation of the set-value!, the following expression
;; from the connector's local procedure is evaluated:
;;
;; (for-each-except setter inform-about-value constraints)
;;
;; Draw an environment diagram showing the environment in which the above
;; expression is evaluated.

;; (in order for the examples below to work, import 33.scm)

(define a (make-connector))
(define b (make-connector))
(set-value! a 10 'user)

;; I hate drawing the environments!
;;
;; More is going on, but I omitted some of the enviroments created during the
;; call chain from set-value! to for-reach-except
;;
;; global-env:
;; +----------------------------------------------------------------------------------+
;; | make-connector     for-each-except     inform-about-value     set-value!         |
;; | has-value?         get-value           connect                                   |
;; |                                                                                  |<---- +
;; | a                                                                                |      |
;; +-|--------------------------------------------------------------------------------+      |
;;   |                                                               ^                       |
;;   |          a env                                                | parent env            |
;;   |         +---------------------------------------------------------------+             |
;;   |         | value       : false                                           |             |
;;   |         | informant   : false                                           |             |
;;   |         | constraints : ()                                              |             |
;;   |         |                                                               |             |
;;   |         | set-my-value    : <proc>                                      |             |
;;   |         | forget-my-value : <proc>                                      |             |
;;   |         | connect         : <proc>                                      |             |
;;   +---------> me              : <proc>                                      |             |
;;             +---------------------------------------------------------------+             |
;;                                                                     ^                     |
;;  (set-value! a 10 'user)                                            |                     |
;;                                                                     |                     |
;;             set-my-value env                                        | parent env          |
;;             +---------------------------------------------------------------+             |
;;             | newval  : 10                                                  |             |
;;             | setter  : 'user                                               |             |
;;             +---------------------------------------------------------------+             |
;; set-my-value invokes (for-each-except 'user infrom-about-value constraints)               |
;;                                                                                           |
;;                                                                                           |
;;             for-each-except env                                                           |
;;             +---------------------------------------------------------------+             | parent env
;;             | exception : 'user                                             |-------------+
;;             | procedure : inform-about-value                                |
;;             | list      : <list of constraints from a env>                  |
;;             +---------------------------------------------------------------+
