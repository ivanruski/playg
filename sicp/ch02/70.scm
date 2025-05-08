;; Exercise 2.70. The following eight-symbol alphabet with associated relative
;; frequencies was designed to efficiently encode the lyrics of 1950s rock
;; songs. (Note that the 'symbols' of an 'alphabet' need not be individual
;; letters.)
;;
;; A     2  NA   16
;; BOOM  1  SHA  3
;; GET   2  YIP  9
;; JOB   2  WAH  1
;;
;; Use generate-huffman-tree (exercise 2.69) to generate a corresponding Huffman tree, and use encode (exercise 2.68) to encode the following message:
;;
;; Get a job
;;
;; Sha na na na na na na na na
;;
;; Get a job
;;
;; Sha na na na na na na na na
;;
;; Wah yip yip yip yip yip yip yip yip yip
;;
;; Sha boom
;;
;; How many bits are required for the encoding? What is the smallest number of
;; bits that would be needed to encode this song if we used a fixed-length code
;; for the eight-symbol alphabet?

(define h-tree (generate-huffman-tree '((a 2) (boom 1) (get 2) (job 2) (na 16) (sha 3) (yip 9) (wah 1))))

(define lyrics '(Get a job
                     Sha na na na na na na na na
                     Get a job
                     Sha na na na na na na na na
                     Wah yip yip yip yip yip yip yip yip yip
                     Sha boom))

;; How many bits are required for the encoding?
(length (encode lyrics h-tree)) ; 84

;; What is the smallest number of bits that would be needed to encode this song
;; if we used a fixed-length code for the eight-symbol alphabet?
;;
;; We need a 3 bit fix-length code to encode the eight-symbol alphabet. That
;; would mean that we would be able to encode the lyrics in 108 bits.

;;;; copied from 68
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (cond ((and (leaf? tree) (equal? (symbol-leaf tree) symbol)) '())
        ((and (leaf? tree) (not (equal? (symbol-leaf tree) symbol)))
         (error "symbol not found in the encode tree -- ENCODE-SYMBOL" symbol))
        ((element-of-set? symbol (symbols (left-branch tree)))
         (cons 0 (encode-symbol symbol (left-branch tree))))
        (else
         (cons 1 (encode-symbol symbol (right-branch tree))))))

(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else
         (element-of-set? x (cdr set)))))

;; leaves
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

;; trees
(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

;;;; copied from 69

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

;; successive-merge does not return a tree for initial leaf-set of one element
(define (successive-merge leaf-set)
  (cond ((null? leaf-set) leaf-set)
        ((= (length leaf-set) 1) (car leaf-set))
        (else
         (let ((first (car leaf-set))
               (second (cadr leaf-set)))
           (successive-merge (adjoin-set (make-code-tree first second)
                                         (cddr leaf-set)))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))
