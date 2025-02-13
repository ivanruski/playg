;; Exercise 2.43. Louis Reasoner is having a terrible time doing exercise
;; 2.42. His queens procedure seems to work, but it runs extremely
;; slowly. (Louis never does manage to wait long enough for it to solve even the
;; 6x6 case.) When Louis asks Eva Lu Ator for help, she points out that he has
;; interchanged the order of the nested mappings in the flatmap, writing it as

(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position new-row k rest-of-queens))
        (queen-cols (- k 1))))
 (enumerate-interval 1 board-size))

;; Explain why this interchange makes the program run slowly. Estimate how long
;; it will take Louis's program to solve the eight-queens puzzle, assuming that
;; the program in exercise 2.42 solves the puzzle in time T.

(define (enumerate-interval from to)
  (if (> from to)
      '()
      (cons from
            (enumerate-interval (+ from 1) to))))

(define (accumulate op zero seq)
  (if (null? seq)
      zero
      (op (car seq)
          (accumulate op zero (cdr seq)))))

(define (flatmap op seq)
  (accumulate append '() (map op seq)))

;; count
(define slow-count 0)
(define fast-count 0)

(define (queens board-size)
  (define empty-board '())
  (define (adjoin-position row col rest-of-queens)
    (append (list (list row col)) rest-of-queens))
  (define (safe? k positions)
    (let ((newpos (car positions))
          (rest (cdr positions)))
      (not (any (lambda (pos)
                  (or (= (car pos) (car newpos))
                      (= (abs (- (car pos) (car newpos)))
                         (abs (- (cadr pos) (cadr newpos))))))
                rest))))

  ;; option 1
  (define (queen-cols k)
    (set! fast-count (+ fast-count 1))
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))

  ;; options 2
  (define (queen-slow k)
    (set! slow-count (+ slow-count 1))
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (new-row)
            (map (lambda (rest-of-queens)
                   (adjoin-position new-row k rest-of-queens))
                 (queen-slow (- k 1))))
          (enumerate-interval 1 board-size)))))
  
  (queen-slow board-size))

;; This interchange makes the program run slowly because, instead of solving
;; (queen-cols (- k 1)) once, it solves it multiple times and there are a lot of
;; repeated/needless computations. For example:
;;
;; fast
;;
;; (queen-cols 4)
;;   (queen-cols 3)
;;     (queen-cols 2)
;;       (queen-cols 1)
;;         (queen-cols 0)
;;
;; slow
;;
;; (queen-cols 4)
;;   (queen-cols 3) ;; 1/4
;;     (queen-cols 2) ;; 1/4
;;       (queen-cols 1) ;; 1/4
;;         (queen-cols 0) ;; 1/4
;;         (queen-cols 0) ;; 2/4
;;         (queen-cols 0) ;; 3/4
;;         (queen-cols 0) ;; 4/4
;;       (queen-cols 1) ;; 2/4
;;         ...
;;       (queen-cols 1) ;; 3/4
;;         ...
;;       (queen-cols 1) ;; 4/4
;;         ...
;;     (queen-cols 2) ;; 2/4
;;       ...
;;     (queen-cols 2) ;; 3/4
;;       ...
;;     (queen-cols 2) ;; 4/4
;;       ...
;;   (queen-cols 3) ;; 2/4
;;     ...
;;   (queen-cols 3) ;; 3/4
;;     ...
;;   (queen-cols 3) ;; 4/4
;;
;;
;; (queen-cols 3) is called 4 times in (queen-cols 4)
;; (queen-cols 2) is called 4 times in (queen-cols 3) 4 * 4
;; (queen-cols 1) is called 4 times in (queen-cols 2) 4 * 4 * 4
;; (queen-cols 0) is called 4 times in (queen-cols 1) 4 * 4 * 4 * 4
;;
;; To me the slow version is O(n^n) and if the fast is T, then the slow one will be T^n.
