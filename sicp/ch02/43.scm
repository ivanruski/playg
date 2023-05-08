;; Exercise 2.43. Louis Reasoner is having a terrible time doing exercise
;; 2.42. His queens procedure seems to work, but it runs extremely
;; slowly. (Louis never does manage to wait long enough for it to solve even the
;; 6×6 case.) When Louis asks Eva Lu Ator for help, she points out that he has
;; interchanged the order of the nested mappings in the flatmap, writing it as
;;
;; (flatmap
;;  (lambda (new-row)
;;    (map (lambda (rest-of-queens)
;;           (adjoin-position new-row k rest-of-queens))
;;         (queen-cols (- k 1))))
;;  (enumerate-interval 1 board-size))
;;
;; Explain why this interchange makes the program run slowly. Estimate how long
;; it will take Louis's program to solve the eight-queens puzzle, assuming that
;; the program in exercise 2.42 solves the puzzle in time T.


;; The fast version solves (queen-cols (- k 1)) once and then for each of the
;; solutions adjoins the new row-column positions.
;;
;; Whereas the slow version solves (queen-cols (- k 1)) for every new row-column
;; position. The slow version solves (queen-cols (- k 1)) board-size number of
;; times for every queen-cols invocation. Each queen-cols spawns 8 new
;; (queen-cols (- k 1)).
;; 
;; - (queen-cols 8) will solve (queen-cols 7) eight times
;; - (queen-cols 7) will solve (queen-cols 6) eight times. We have eight
;;   (queen-cols 7), so in total (queen-cols 6) will be solved 64 times.
;; - (queen-cols 5) will be solved 8^3 times
;; ...
;; - (queen-cols 0) will be called 8^8 number of times
;; 
;;
;; If T = QC8 + QC7 + QC6 + QC5 + QC4 + QC3 + QC2 + QC1 + QC1
;; T slow should be: QC8 + 8*QC7 + 8^2*QC6 ... + 8^7*QC1
;; 
;; QC = (queen-cols)
