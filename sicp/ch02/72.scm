;; Exercise 2.72. Consider the encoding procedure that you designed in exercise
;; 2.68. What is the order of growth in the number of steps needed to encode a
;; symbol? Be sure to include the number of steps needed to search the symbol
;; list at each node encountered. To answer this question in general is
;; difficult. Consider the special case where the relative frequencies of the n
;; symbols are as described in exercise 2.71, and give the order of growth (as a
;; function of n) of the number of steps needed to encode the most frequent and
;; least frequent symbols in the alphabet.
;;
;; Explanation:
;; 
;; The number of steps needed to search the symbol is O(n). My list-contains
;; function starts from the beginning of the list and tries to find the symbol -
;; the worst case is when the element is not in the list and the whole list is
;; traversed.
;;
;; The order of growth for encoding the most frequent symbol is O(n). I have to
;; go through all of the elements and the right tree is always a leaf in my
;; case.
;;
;; The order of growth for encoding the least frequent symbol is O(n^2). I have
;; to call list-contains on every level of the tree and on every level of the
;; tree n decreases by one, so O(n + (n - 1) + (n - 2) .. + 1) which is O(n^2).
