;; Exercise 2.42: The "eight-queens puzzle" asks how to place eight queens on a
;; chessboard so that no queen is in check from any other (i.e., no two queens
;; are in the same row, column, or diagonal). One possible solution is shown in
;; figure 2.8. One way to solve the puzzle is to work across the board, placing
;; a queen in each column. Once we have placed k - 1 queens, we must place the
;; kth queen in a position where it does not check any of the queens already on
;; the board. We can formulate this approach recursively: Assume that we have
;; already generated the sequence of all possible ways to place k - 1 queens in
;; the first k - 1 columns of the board. For each of these ways, generate an
;; extended set of positions by placing a queen in each row of the kth
;; column. Now filter these, keeping only the positions for which the queen in
;; the kth column is safe with respect to the other queens. This produces the
;; sequence of all ways to place k queens in the first k columns. By continuing
;; this process, we will produce not only one solution, but all solutions to the
;; puzzle.
;;
;; Figure 2.8
;; 
;; |---+---+---+---+---+---+---+---|
;; |   |   |   |   |   | Q |   |   |
;; |---+---+---+---+---+---+---+---|
;; |   |   | Q |   |   |   |   |   |
;; |---+---+---+---+---+---+---+---|
;; | Q |   |   |   |   |   |   |   |
;; |---+---+---+---+---+---+---+---|
;; |   |   |   |   |   |   | Q |   |
;; |---+---+---+---+---+---+---+---|
;; |   |   |   |   | Q |   |   |   |
;; |---+---+---+---+---+---+---+---|
;; |   |   |   |   |   |   |   | Q |
;; |---+---+---+---+---+---+---+---|
;; |   | Q |   |   |   |   |   |   |
;; |---+---+---+---+---+---+---+---|
;; |   |   |   | Q |   |   |   |   |
;; |---+---+---+---+---+---+---+---|
;; 
;; We implement this solution as a procedure queens, which returns a sequence of
;; all solutions to the problem of placing n queens on an n×n chessboard. Queens
;; has an internal procedure queen-cols that returns the sequence of all ways to
;; place queens in the first k columns of the board.
;;
;; In this procedure rest-of-queens is a way to place k - 1 queens in the first
;; k - 1 columns, and new-row is a proposed row in which to place the queen for
;; the kth column. Complete the program by implementing the representation for
;; sets of board positions, including the procedure adjoin-position, which
;; adjoins a new row-column position to a set of positions, and empty-board,
;; which represents an empty set of positions. You must also write the procedure
;; safe?, which determines for a set of positions, whether the queen in the kth
;; column is safe with respect to the others. (Note that we need only check
;; whether the new queen is safe -- the other queens are already guaranteed safe
;; with respect to each other.)

(define empty-board '())

(define (queens board-size)
  (define (queen-cols k)
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
  (queen-cols board-size))

;; new-row - is a proposed row in which to place the queen for the kth column
;; k - is the current column
;; rest-of-queens - is a way to place k - 1 queens in the first k - 1 columns
;; 
;; (list row k)

(define (make-chess-pos row col)
  (list row col))

(define (pos-row pos) (car pos))
(define (pos-col pos) (cadr pos))


;; append kth col to the fron of rest-of-queens, so that later it is easier to
;; check if the first element is in check? position with the rest
(define (adjoin-position row col rest-of-queens)
  (cons (make-chess-pos row col)
        rest-of-queens))

(define (safe? k positions)
  (define (positions-in-check? a b)
      (or (= (pos-row a) (pos-row b))
          (= (pos-col a) (pos-col b))
          ;; diag check
          (= (abs (- (pos-row b)
                     (pos-row a)))
             (abs (- (pos-col b)
                     (pos-col a))))))
  (define (iter pos positions)
    (if (null? positions)
        #t
        (and (not (positions-in-check? pos (car positions)))
             (iter pos (cdr positions)))))
  (if (<= k 1)
      #t
      (iter (car positions) (cdr positions))))

;; Doing this a second time a couple of months later

(define (enumerate-interval from to)
  (if (> from to)
      ()
      (cons from
            (enumerate-interval (+ from 1) to))))

(define (accumulate op nil-term sequence)
  (if (null? sequence)
      nil-term
      (op (car sequence)
          (accumulate op nil-term (cdr sequence)))))

(define (flatmap proc set)
  (accumulate append () (map proc set)))

(define (queens board-size)
  (define empty-board '())
  (define (adjoin-position row col rest-of-queens)
    (append (list (list row col)) rest-of-queens))
  (define (safe? k positions)
    (let ((row (caar positions))
          (col (cadar positions)))
      (= 0
         (length (filter (lambda (pos)
                           (let ((r (car pos))
                                 (c (cadr pos)))
                             (or (= row r)
                                 (= col c)
                                 (= (abs (- row r))
                                    (abs (- col c))))))
                         (cdr positions))))))
  (define (queen-cols k)  
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
  (queen-cols board-size))
