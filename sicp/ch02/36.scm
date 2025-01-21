;; Exercise 2.36. The procedure accumulate-n is similar to accumulate except
;; that it takes as its third argument a sequence of sequences, which are all
;; assumed to have the same number of elements. It applies the designated
;; accumulation procedure to combine all the first elements of the sequences,
;; all the second elements of the sequences, and so on, and returns a sequence
;; of the results. For instance, if s is a sequence containing four sequences,
;; ((1 2 3) (4 5 6) (7 8 9) (10 11 12)), then the value of (accumulate-n + 0 s)
;; should be the sequence (22 26 30). Fill in the missing expressions in the
;; following definition of accumulate-n:

(define (accumulate fn zero-value seq)
  (if (null? seq)
      zero-value
      (fn (car seq)
          (accumulate fn zero-value (cdr seq)))))

(define (accumulate-n fn zero-value seq-of-seqs)
  (if (or (null? seq-of-seqs)
          (null? (car seq-of-seqs)))
      '()
      (cons (accumulate fn zero-value (map car seq-of-seqs))
            (accumulate-n fn zero-value (map cdr seq-of-seqs)))))

(define s '((1 2 3) (4 5 6) (7 8 9) (10 11 12)))

(accumulate-n + 0 s)
(accumulate-n + 0 '())
