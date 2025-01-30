;; Exercise 2.41. Write a procedure to find all ordered triples of distinct
;; positive integers i, j, and k less than or equal to a given integer n that
;; sum to a given integer s.

(define (enumerate-interval from to)
  (if (> from to)
      '()
      (cons from (enumerate-interval (+ 1 from) to))))

(define (accumulate op zero seq)
  (if (null? seq)
      zero
      (op (car seq)
          (accumulate op zero (cdr seq)))))

(define (flatmap op seq)
  (accumulate append '() (map op seq)))

(define (ordered-pairs k n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval (+ i 1) n)))
           (enumerate-interval k n)))

(define (ordered-triplets n)
  (flatmap (lambda (num)
             (map (lambda (pair) (cons num pair))
                  (ordered-pairs (+ num 1) n)))
           (enumerate-interval 1 n)))

(define (triplets-sum-to-n sum n)
  (filter (lambda (triplet) (= sum (accumulate + 0 triplet)))
          (ordered-triplets n)))
