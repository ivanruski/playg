;; Exercise 2.52. Make changes to the square limit of wave shown in figure 2.9
;; by working at each of the levels described above. In particular:
;;
;; a. Add some segments to the primitive wave painter of exercise 2.49 (to add a
;; smile, for example).
;;
;; b. Change the pattern constructed by corner-split (for example, by using only
;; one copy of the up-split and right-split images instead of two).
;;
;; c. Modify the version of square-limit that uses square-of-four so as to
;; assemble the corners in a different pattern. (For example, you might make the
;; big Mr. Rogers look outward from each corner of the square.)

;; The exercise can be tested in drRacket
#lang sicp
(#%require sicp-pict)

;; a. Skipped the wave painter in 2.49, skipping here as well

;; b. Change the pattern constructed by corner-split (for example, by using only
;; one copy of the up-split and right-split images instead of two).

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left up)
              (bottom-right right)
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

;; c. Modify the version of square-limit that uses square-of-four so as to
;; assemble the corners in a different pattern. (For example, you might make the
;; big Mr. Rogers look outward from each corner of the square.)

;; I will use Einstein and I'll make it look inward

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

(define (square-limit painter n)
  (let ((combine4 (square-of-four flip-horiz identity
                                  rotate180 flip-vert)))
    (combine4 (corner-split (flip-horiz painter) n))))
;;                           ^^^^^ the difference is here
