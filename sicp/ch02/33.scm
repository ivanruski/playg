;; Exercise 2.33. Fill in the missing expressions to complete the following
;; definitions of some basic list-manipulation operations as accumulations:
;;
;; (define (map p sequence)
;;   (accumulate (lambda (x y) <??>) nil sequence))
;; (define (append seq1 seq2)
;;   (accumulate cons <??> <??>))
;; (define (length sequence)
;;   (accumulate <??> 0 sequence))


(define (accumulate fn zero-value sequence)
  (if (null? sequence)
      zero-value
      (fn (car sequence)
          (accumulate fn zero-value (cdr sequence)))))

(define (my-map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))

(define (my-append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (my-length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
