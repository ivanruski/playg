;; Exercise 2.27. Modify your reverse procedure of exercise 2.18 to produce a
;; deep-reverse procedure that takes a list as argument and returns as its value
;; the list with its elements reversed and with all sublists deep-reversed as
;; well. For example,
;;
;; (define x (list (list 1 2) (list 3 4)))
;;
;; x
;; ((1 2) (3 4))
;;
;; (reverse x)
;; ((3 4) (1 2))
;;
;; (deep-reverse x)
;; ((4 3) (2 1))

(define x (list (list 1 2) (list 3 4)))

(define (my-reverse x)
  (if (null? x)
      '()
      (append (my-reverse (cdr x))
              (list (car x)))))

(define (deep-reverse x)
  (if (null? x)
      '()
      (let ((first (car x))
            (rest (cdr x)))
        (if (list? first)
            (append (deep-reverse rest)
                    (list (deep-reverse first)))
            (append (deep-reverse rest)
                    (list first))))))

(define x (list (list 1 2) (list 3 4)))
(deep-reverse x)

(define y (list 1 2 (list 3 4)))
(deep-reverse y)

(define z (list (list 1 2) 3 4))
(deep-reverse z)

(define a (list (list (list 1) (list 2)) (list (list 3) (list 4))))
(deep-reverse a)
