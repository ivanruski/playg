;; Exercise 2.71. Suppose we have a Huffman tree for an alphabet of n symbols,
;; and that the relative frequencies of the symbols are 1, 2, 4, ...,
;; 2^n-1. Sketch the tree for n=5; for n=10. In such a tree (for general n) how
;; many bits are required to encode the most frequent symbol? the least frequent
;; symbol?

;;                                        (n = 10)  /\
;;                                                 /  \
;;                                                /    \
;;                                               /      \
;;                                              /        j(512)
;;                                             /\
;;                                            /  \
;;                                           /    \
;;                                          /      i(256)
;;                                         /\
;;                                        /  \
;;                                       /    \
;;                                      /      h(128)
;;                                     /\
;;                                    /  \
;;                                   /    \
;;                                  /      g(64)
;;                                 /\
;;                                /  \
;;                               /    \
;;                              /      f(32)
;;                    (n = 5)  /\
;;                            /  \
;;                           /    \
;;                          /      e(16)
;;                         /\
;;                        /  \
;;                       /    \
;;                      /      d(8)
;;                     /\
;;                    /  \
;;                   /    \
;;                  /      c(4)
;;                 /\
;;                /  \
;;               /    \
;;              a(1)   b(2)
;;
;; The most frequent symbol is always encoded in one bit, whereas the least
;; frequent one is encoded in n-1 bits.
