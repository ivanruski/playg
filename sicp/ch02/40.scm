;; Exercise 2.40. Define a procedure unique-pairs that, given an integer n,
;; generates the sequence of pairs (i,j) with 1 <= j < i <= n. Use unique-pairs
;; to simplify the definition of prime-sum-pairs given above.

(define (prime? num)
  (define (iter i)
    (cond ((> i (sqrt num)) #t)
          ((= (remainder num i) 0) #f)
          (else
           (iter (+ i 1)))))
  (iter 2))

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

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j)
                    (list i j))
                  (enumerate-interval (+ i 1) n)))
           (enumerate-interval 1 n)))

(define (prime-sum-pairs n)
  (define (prime-sum? l)
    (prime? (+ (car l) (cadr l))))
  (filter prime-sum? (unique-pairs n)))
