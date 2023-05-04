;; Exercise 2.41. Write a procedure to find all ordered triples of distinct
;; positive integers i, j, and k less than or equal to a given integer n that
;; sum to a given integer s.

(define (enumerate-interval from to)
  (if (> from to)
      ()
      (cons from
            (enumerate-interval (+ from 1) to))))

(define (accumulate op nil sequence)
  (if (null? sequence)
      nil
      (op (car sequence)
          (accumulate op nil (cdr sequence)))))

(define (flatmap proc sequence)
  (accumulate append () (map proc sequence)))

(define (unique-triples n)
  (flatmap (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                             (enumerate-interval (+ j 1) n)))
                      (enumerate-interval (+ i 1) n)))
           (enumerate-interval 1 (- n 2))))

(define (ordered-triples-n-equal-s n s)
  (filter (lambda (seq) (= (accumulate + 0 seq) s))
          (unique-triples n)))
