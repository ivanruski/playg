;; Exercise 2.24. Suppose we evaluate the expression (list 1 (list 2 (list 3 4))).
;; Give the result printed by the interpreter, the corresponding box-and-pointer
;; structure, and the interpretation of this as a tree (as in figure 2.6).

(list 1 (list 2 (list 3 4)))

;; value printed by the interpreter:
;; > (1 (2 (3 4)))
;;
;; Value in box-and-pointer notation:
;;
;; |---+---|       |---+---|
;; | o |   | ----> | o | x |
;; |---+---|       |---+---|
;;   |               |
;;   |               |
;; +---+           |---+---|       |---+---|
;; | 1 |           | o |   | ----> | o | x |
;; +---+           |---+---|       |---+---|
;;                   |               |
;;                   |               |
;;                 +---+           |---+---|      |---+---|
;;                 | 2 |           | o |   | ---> | o | x |
;;                 +---+           |---+---|      |---+---|
;;                                   |              |
;;                                   |              |
;;                                 +---+          +---+
;;                                 | 3 |          | 4 |
;;                                 +---+          +---+
;;
;; This is a list of two elements, the first element is 1, the second element is
;; another list.
