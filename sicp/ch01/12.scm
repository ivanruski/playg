;; Exercise 1.12. The following pattern of numbers is called Pascal's triangle.
;; 
;;        1
;;       1 1
;;      1 2 1
;;     1 3 3 1
;;    1 4 6 4 1
;;   1 5 10 10 5 1
;;  1 6 15 20 15 6 1
;; 1 7 21 35 35 21 7 1
;;
;; The numbers at the edge of the triangle are all 1, and each number inside the
;; triangle is the sum of the two numbers above it. Write a procedure that
;; computes elements of Pascal's triangle by means of a recursive process.


;; This should be the solution to this exercise, even though it's tree recursion
(define (pascal-el row i)
  (if (or (= i 0) (= i row))
      1
      (+ (pascal-el (- row 1) (- i 1))
         (pascal-el (- row 1) i))))

;; Finds the elements of nth row
(define (pascal-row n)  
  (define (generate-row i)
    (if (> i n)
        '()
        (cons (pascal-el n i)
              (generate-row (+ i 1)))))

  (generate-row 0))

;; Generate Pascal's triangle, where each row is a list
(define (pascal-triangle n)
  (define (generate-triangle i)
    (if (> i n)
        '()
        (cons (pascal-row i)
              (generate-triangle (+ i 1)))))
  (generate-triangle 0))

;; Print each row from a Pascal's triangle on a new line
(define (print-pascal rows)
  (cond ((= (length rows) 0) (newline))
        (else (display (car rows))
              (newline)
              (print-pascal (cdr rows)))))

