;; Exercise 2.70. The following eight-symbol alphabet with associated relative
;; frequencies was designed to efficiently encode the lyrics of 1950s rock
;; songs. (Note that the ``symbols'' of an ``alphabet'' need not be individual
;; letters.)
;;
;; A	2	NA	16
;; BOOM	1	SHA	3
;; GET	2	YIP	9
;; JOB	2	WAH	1
;;
;; Use generate-huffman-tree (exercise 2.69) to generate a corresponding Huffman
;; tree, and use encode (exercise 2.68) to encode the following message:
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

;; leaf
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

;; tree
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

;; decode
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (encode message tree)
   (if (null? message)
       '()
       (append (encode-symbol (car message) tree)
               (encode (cdr message) tree))))

(define (list-contains symbol list)
  (if (null? list)
      #f
      (or (eq? (car list) symbol)
          (list-contains symbol (cdr list)))))

(define (encode-symbol symbol tree)
  (if (null? tree)
      (error "symbol not found in tree -- ENCODE-SYMBOL" symbol)
      (let ((left (left-branch tree))
            (right (right-branch tree)))
        (cond ((list-contains symbol (symbols left))
               (if (leaf? left)
                   (list 0)
                   (append (list 0) (encode-symbol symbol left))))
              ((list-contains symbol (symbols right))
               (if (leaf? right)
                   (list 1)
                   (append (list 1)
                           (encode-symbol symbol right))))
              (else
               (error "symbol not found in tree -- ENCODE-SYMBOL" symbol))))))


(define null-leaf (make-leaf '_null-leaf 0))

(define (successive-merge leafs)
  (cond ((null? leafs) '())
        ;; if the initial call to successive-merge is a list of one leaf
        ((and (= (length leafs) 1) (leaf? (car leafs)))
         (make-code-tree (car leafs) null-leaf))
        ((= (length leafs) 1) (car leafs))
        (else
         (let ((tree (make-code-tree (car leafs) (cadr leafs)))
               (rest (cddr leafs)))
           (successive-merge (adjoin-set tree rest))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

;; solution

(define pairs '((a 2)
                (boom 1)
                (na 16)
                (sha 3)
                (get 2)
                (yip 9)
                (job 2)
                (wah 1)))


(define text '(Get a job
               Sha na na na na na na na na
               Get a job
               Sha na na na na na na na na
               Wah yip yip yip yip yip yip yip yip yip
               Sha boom))

(define song-tree (generate-huffman-tree pairs))

(equal? text
        (decode (encode text song-tree)
                song-tree))

;; How many bits are required for the encoding? What is the smallest number of
;; bits that would be needed to encode this song if we used a fixed-length code
;; for the eight-symbol alphabet?
;;
;; We need 5 bits to be able to encode the song, because the least used words
;; require that many bits.
(encode '(boom) song-tree)
(encode '(wah) song-tree)
;; 
;; The length of the encoded message is 84 bits
(length (encode text song-tree))

;; If we used a fixed-length code for the eight-symbol alphabed, we would need 3
;; bits per symbol. The lyrics consists of 36 words, which means that we would
;; need 108 bits to encode the text.
(length text)
(* 3 (length text))

