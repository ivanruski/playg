;; Exercise 3.16. Ben Bitdiddle decides to write a procedure to count the number
;; of pairs in any list structure. ``It's easy,'' he reasons. ``The number of
;; pairs in any structure is the number in the car plus the number in the cdr
;; plus one more to count the current pair.'' So Ben writes the following
;; procedure:

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

;; Show that this procedure is not correct. In particular, draw box-and-pointer
;; diagrams representing list structures made up of exactly three pairs for
;; which Ben's procedure would return 3; return 4; return 7; never return at
;; all.

(count-pairs (list 1 2 3))
;; 3
;;
;;  +---+---+    +---+---+    +---+---+
;;  | . | -----> | . | -----> | . | / |
;;  +-|-+---+    +-|-+---+    +-|-+---+
;;    v            v            v
;;  +---+        +---+        +---+
;;  | 1 |        | 2 |        | 3 |
;;  +---+        +---+        +---+

(define one-pair (list 'x))
(count-pairs (cons one-pair (cons 2 one-pair)))
;; 4
;;
;;               +---+
;;               | x |
;;               +---+
;;                 ^
;;               +-|-+---+
;;  one-pair --> | . | / |
;;               +---+---+
;;                 ^
;;   +-------------+--+
;;   |                |
;; +-|-+---+    +---+-|-+
;; | . | -----> | | | . |
;; +---+----    +-|-+---+
;;                v
;;              +---+
;;              | 2 |
;;              +---+

(define z (cons one-pair one-pair))
(count-pairs (cons z z))
;; 7
;;
;;               +---+
;;               | x |
;;               +---+
;;                 ^
;;               +-|-+---+
;;  one-pair --> | . | / |
;;               +---+---+
;;                 ^
;;                 |
;;                 +---+
;;                 |   |
;; +---+---+     +-|-+-|-+
;; | . | ------> | . | . |
;; +-|-+----     +---+---+
;;   |             ^
;;   +-------------+

;; never return at all
;; Use make-cycle from exercise 3.13

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(count-pairs (make-cycle (list 1 2 3)))

;;         +-----------------------------------+
;;         v                                   |
;;       +---+---+    +---+---+     +---+---+  |
;;       | . | -----> | . | ----->  | . | -----+
;;       +-|-+---+    +-|-+---+     +-|-+---+
;;         v            v             v
;;       +---+        +---+         +---+
;;       | 1 |        | 2 |         | 3 |
;;       +---+        +---+         +---+
