;; Exercise 2.72. Consider the encoding procedure that you designed in exercise
;; 2.68. What is the order of growth in the number of steps needed to encode a
;; symbol? Be sure to include the number of steps needed to search the symbol
;; list at each node encountered. To answer this question in general is
;; difficult. Consider the special case where the relative frequencies of the n
;; symbols are as described in exercise 2.71, and give the order of growth (as a
;; function of n) of the number of steps needed to encode the most frequent and
;; least frequent symbols in the alphabet.

;; For the special case from 71:
;;
;; The complexity of encode-symbol for the most frequent can be O(1) if I check
;; first the right branch.
;;
;; The complexity of encode-symbol for the least frequent is O(n^2), because
;; element-of-set? has O(n) complexity and at each level in the tree I have
;; n - 1 elements which results in n + (n - 1) + ... + 1, which is the same as
;; (n * (n + 1))/2 which is O(n^2)
