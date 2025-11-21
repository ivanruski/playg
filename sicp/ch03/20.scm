;; Exercise 3.20. Draw environment diagrams to illustrate the evaluation of the
;; sequence of expressions
;;
;; (define x (cons 1 2))
;; (define z (cons x x))
;; (set-car! (cdr z) 17)
;; (car x)
;; 17
;;
;; using the procedural implementation of pairs given above. (Compare exercise 3.11.)


(define (pcons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
    (cond ((eq? m 'car) x)
          ((eq? m 'cdr) y)
          ((eq? m 'set-car!) set-x!)
          ((eq? m 'set-cdr!) set-y!)
          (else (error "Undefined operation -- CONS" m))))
  dispatch)

(define (pcar z) (z 'car))
(define (pcdr z) (z 'cdr))

(define (pset-car! z new-value)
  ((z 'set-car!) new-value)
  z)

(define (pset-cdr! z new-value)
  ((z 'set-cdr!) new-value)
  z)


(define x (pcons 1 2))
(define z (pcons x x))
(pset-car! (pcdr z) 17)
(pcar x)
17

;; global env:
;;
;; +-------------------------------------------------------------------------+
;; | pcons: <procedure 1>                                                    |
;; | pcar: <procedure 2>                                                     |
;; | pcdr: <procedure 3>                                                     |
;; | pset-car!: <procedure 4>                                                |
;; |                                                                         |
;; | x: -----+                                                               |
;; | z: --+  |                                                               |
;; +------|--|---------------------------------------------------------------+
;;        |  |                                                             ^
;;        |  |                                                             |
;;        |  |                                       +-------------------+-|-+
;;        |  |                                       | procedure x body  | | |
;;        |  |                                       +-------------------+---+
;;        |  |    x env
;;        |  |    +-----------------------+
;;        |  |    | x: 1                  |
;;        |  |    | y: 2                  |
;;        |  |    | set-x!: <procedure>   |
;;        |  |    | set-y!: <procedure>   |
;;        |  |    | dispatch: ------+     |
;;        |  |    +-----------------|-----+
;;        |  |                      |    ^
;;        |  |                      |    |
;;        |  |                      v    |
;;        |  |                  +------+-|-+
;;        |  +----------------> | body | | |
;;        |                     +------+---+
;;        |       y env            ^
;;        |       +----------------|------+
;;        |       | x: ------------+      |
;;        |       | y: ------------^      |
;;        |       | set-x!: <procedure>   |
;;        |       | set-y!: <procedure>   |
;;        |       | dispatch: ------+     |
;;        |       +-----------------|-----+
;;        |                         |    ^
;;        |                         |    |
;;        |                         v    |
;;        |                     +------+-|-+
;;        +-------------------> | body | | |
;;                              +------+---+
;;
;;
;; On (pset-car! (pcdr z) 17):
;;
;; - ephemeral environment for (pcdr z) is created and (z 'cdr) is invoked
;;   i.e. the dispatch procedure in the y env is invoked with 'cdr as argument
;;   and the dispatch procedure from the x env is returned
;;
;; - ephemeral environment for pset-car! is created and we invoke the dispatch proc from the x env with
;;   !set-car argument.
;;   - set-x! in x env is invoked (another ephemeral env is created) and x in x env is set to 17
