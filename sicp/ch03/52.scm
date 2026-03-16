;; Exercise 3.52. Consider the sequence of expressions

(define sum 0)
(define cnt 0)

(define (accum x)
  (set! cnt (+ cnt 1))
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))

(define y (stream-filter even? seq))

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))

(stream-ref y 7)
(display-stream z)

;; What is the value of sum after each of the above expressions is evaluated?
;; What is the printed response to evaluating the stream-ref and display-stream
;; expressions? Would these responses differ if we had implemented (delay <exp>)
;; simply as (lambda () <exp>) without using the optimization provided by
;; memo-proc ? Explain.

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
;; sum will be 1, because stream-map will map the first element and delay the cdr
;;
;; sum is indeed 1 - my interpratation is correct

(define y (stream-filter even? seq))
;; sum will be 2, because stream-filter will iterate over 1 and 2 and it will
;; stop, but since 1 is already mapped, accum will be invoked only once
;;
;; sum is 6, my interpretation is waay incorrect.
;;
;; - stream-filter checks (stream-car seq), which is one and continues
;; - the 2nd element in seq is 3(not 2), because accum is 1 + 2 = 3
;;   - this is odd so filter continues
;;   - at this point sum is 3
;; - the 3rd element in seq is 6(sum + 3)
;;   - this is even, filter stops
;;   - sum is 6
;;
;; I've added logic which counts how many times, accum was invoked and after
;; this evaluation it was invoked 3 times

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
;; z starts iterating over seq from the beginning, but the first 3 elements are
;; already computed, so nothing happens.
;;
;; - the 4th element is 6 + 4 = 10
;;   - z returns
;;   - sum is 10
;;   - cnt is 4
;;
;; This time I got it right :)

(stream-ref y 7)
;; 120
;; the evaluated elements of the y stream would be: 6 10 28 36 66 78 120 136
;;
;; I got it almost right, the evalutated expression is 136 - zero-based index (facepalm)
;; the y stream is as I predicted it

(display-stream z)
;; 10
;; 15
;; 45
;; 55
;; 105
;; 120
;; 190
;; 210
;;
;; I got this right :)

;;;; Part 2:
;; Would these responses differ if we had implemented (delay <exp>)
;; simply as (lambda () <exp>) without using the optimization provided by
;; memo-proc ? Explain.
;;
;; Yes, the printed responses would have differed, because every time we map, we
;; change the value of sum and multiple iterations over seq would increase it
;; every time.
