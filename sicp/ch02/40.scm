;; Exercise 2.40. Define a procedure unique-pairs that, given an integer n,
;; generates the sequence of pairs (i,j) with 1 <= j <= i < n. Use unique-pairs to
;; simplify the definition of prime-sum-pairs given above.

(define (enumerate-interval from to)
  (if (> from to)
      '()
      (cons from
            (enumerate-interval (+ 1 from) to))))

(define (accumulate op zero-value sequence)
  (if (null? sequence)
      zero-value
      (op (car sequence)
          (accumulate op zero-value (cdr sequence)))))

(define (flatmap op sequence)
  (accumulate append '() (map op sequence)))

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list j i))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(define (prime? num)
  (define (prime-iter i)
    (if (> i (sqrt num))
        #t
        (and (not (= 0 (remainder num i)))
             (prime-iter (+ i 1)))))
  (prime-iter 2))


(define (prime-sum-pairs n)
  (define (prime-sum? pair)
    (prime? (+ (car pair) (cadr pair))))

  (define (make-pair-sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))
