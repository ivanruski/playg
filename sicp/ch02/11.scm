;; Exercise 2.11. In passing, Ben also cryptically comments: "By testing the
;; signs of the endpoints of the intervals, it is possible to break mul-interval
;; into nine cases, only one of which requires more than two multiplications."
;; Rewrite this procedure using Ben's suggestion.

;; We have 16 possibilities for the signs of the intervals' endpoints, of which
;; only 9 are valid.

;; Let's have:
;; i1 = [a, b]
;; i2 = [c, d]
;;
;; 1. a, b, c and d are pos., => [a*c, b*d]
;; 2. a is negative, => [a*d, b*d]
;; 3. b is negative, invalid scenario because b would be lass than a
;; 4. c is negative, => [b*c, b*d]
;; 5. d is negative, invalid scenario because d would be lass than c
;; 6. a, b are neg., => [a*d, b*c]

;; 7. a, c are neg., this is the case which requires more than 2 multiplications

;; 8. a, d are neg., not possible because d would be lass than c
;; 9. b, c are neg., not possible because b would be lass than a
;; 10. b, d are neg., not possible because b would be lass than a
;; 11. c, d are neg,. => [b*c, a*d]
;; 12. a, b and c are neg., => [a*d, a*c]
;; 13. a, b and d are neg., not possible because d would be lass than c
;; 14. a, c and d are neg., => [b*c, a*c]
;; 15. b, c and d are neg., not bossible because b would be lass than a
;; 16. a, b, c and d are neg., => [b*d, a*c]

;; Examples:
(mul-interval (make-interval 1 2) (make-interval 5 10))    ;; 1)    5, 20
(mul-interval (make-interval -1 2) (make-interval 5 10))   ;; 2)  -10, 20
(mul-interval (make-interval 1 2) (make-interval -5 10))   ;; 4)  -10, 20
(mul-interval (make-interval -10 -2) (make-interval 5 10)) ;; 6) -100, -10

;; In the 7th case the upper bound could be a*c or b*d
;; and the lower bound could be a*d or b*c
(mul-interval (make-interval -1 5) (make-interval -5 10)) ;; bc, bd) -25, 50
(mul-interval (make-interval -1 4) (make-interval -5 1))  ;; bc, ac) -20, 5
(mul-interval (make-interval -9 2) (make-interval -5 10)) ;; ad, ac) -90, 45
(mul-interval (make-interval -5 9) (make-interval -5 10)) ;; ad, bd) -50, 90

(mul-interval (make-interval 30 40) (make-interval -10 -5))   ;; 11) -400, -150
(mul-interval (make-interval -5 -2) (make-interval -5 10))    ;; 12)  -50,   25
(mul-interval (make-interval -1 2) (make-interval -15 -10))   ;; 14)  -30,   15
(mul-interval (make-interval -10 -2) (make-interval -15 -10)) ;; 16)   20,  100

;; 7. a, c are neg., this is the case which requires more than 2 multiplications
;; 11. c, d are neg,. => [b*c, a*d]
;; 12. a, b and c are neg., => [a*d, a*c]
;; 14. a, c and d are neg., => [b*c, a*c]
;; 16. a, b, c and d are neg., => [b*d, a*c]
(define (mul-interval-2 i1 i2)
  (let ((a (lower-bound i1))
        (b (upper-bound i1))
        (c (lower-bound i2))
        (d (upper-bound i2)))
          ;; a, b, c, d are positive
    (cond ((and (<= 0 a)
                (<= 0 c)) (make-interval (* a c) (* b d)))
          ;; a is negative
          ((and (< a 0)
                (<= 0 b)
                (<= 0 c)) (make-interval (* a d) (* b d)))
          ;; c is negative
          ((and (<= 0 a)
                (< c 0)
                (<= 0 d)) (make-interval (* b c) (* b d)))
          ;; a and b are negative
          ((and (< b 0)
                (<= 0 c)) (make-interval (* a d) (* b c)))
          ;; a and c are negative
          ((and (< a 0)
                (<= 0 b)
                (< c 0)
                (<= 0 d)) (make-interval (min (* a d) (* b c))
                                         (max (* a c) (* b d))))
          ;; c and d are negative
          ((and (<= 0 a)
                (< d 0)) (make-interval (* b c) (* a d)))
          ;; a, b and c are negative
          ((and (< b 0)
                (< c 0)
                (<= 0 d)) (make-interval (* a d) (* a c)))
          ;; a, c and d are negative
          ((and (< a 0)
                (<= 0 b)
                (< d 0)) (make-interval (* b c) (* a c)))
          ;; a, b, c and d are negative
          ((and (< b 0)
                (< d 0)) (make-interval (* b d) (* a c))))))
    

(mul-interval-2 (make-interval 1 2) (make-interval 5 10))    ;; 1)    5, 20
(mul-interval-2 (make-interval -1 2) (make-interval 5 10))   ;; 2)  -10, 20
(mul-interval-2 (make-interval 1 2) (make-interval -5 10))   ;; 4)  -10, 20
(mul-interval-2 (make-interval -10 -2) (make-interval 5 10)) ;; 6) -100, -10

;; In the 7th case the upper bound could be a*c or b*d
;; and the lower bound could be a*d or b*c
(mul-interval-2 (make-interval -1 5) (make-interval -5 10)) ;; bc, bd) -25, 50
(mul-interval-2 (make-interval -1 4) (make-interval -5 1))  ;; bc, ac) -20, 5
(mul-interval-2 (make-interval -9 2) (make-interval -5 10)) ;; ad, ac) -90, 45
(mul-interval-2 (make-interval -5 9) (make-interval -5 10)) ;; ad, bd) -50, 90

(mul-interval-2 (make-interval 30 40) (make-interval -10 -5))   ;; 11) -400, -150
(mul-interval-2 (make-interval -5 -2) (make-interval -5 10))    ;; 12)  -50,   25
(mul-interval-2 (make-interval -1 2) (make-interval -15 -10))   ;; 14)  -30,   15
(mul-interval-2 (make-interval -10 -2) (make-interval -15 -10)) ;; 16)   20,  100
