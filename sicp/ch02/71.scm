;; Exercise 2.71. Suppose we have a Huffman tree for an alphabet of n symbols,
;; and that the relative frequencies of the symbols are 1, 2, 4, ...,
;; 2n-1. Sketch the tree for n=5; for n=10. In such a tree (for general n) how
;; many bits are required to encode the most frequent symbol? the least frequent
;; symbol?

;; For n = 5, (a 1) (b 2) (c 4) (d 8) (e 16)
;; 
;;                 (a b c d e) 31
;;                  .
;;                 / \
;;   (a b c d) 15.    (e 16)
;;              / \
;;  (a b c) 7 .   (d 8)
;;           / \
;; (a b) 3 .  (c 4)
;;        / \
;;   (a 1)  (b 2)
;;
;;
;; For n = 10 the tree will have the same structure, just bigger height.
;;
;; In trees where the relative frequencies are 1, 2, ...., 2n-1, the most
;; frequent symbol will be encoded with 1 bit and the least frequent symbol will
;; be encoded with n-1 bits. Such trees are with n - 1 height.
