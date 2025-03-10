;; Exercise 2.49. Use segments->painter to define the following primitive
;; painters:
;;
;; a. The painter that draws the outline of the designated frame.
;;
;; b. The painter that draws an ``X'' by connecting opposite corners of the
;; frame.
;;
;; c. The painter that draws a diamond shape by connecting the midpoints of the
;; sides of the frame.
;;
;; d. The wave painter.

;; The exercise can be tested in drRacket
#lang sicp
(#%require sicp-pict)

;; a. The painter that draws the outline of the designated frame.
(define outline (vects->segments (list (make-vect 0 0)
                                       (make-vect 0 1)
                                       (make-vect 1 1)
                                       (make-vect 1 0)
                                       (make-vect 0 0))))
(paint (segments->painter outline))

;; b. The painter that draws an ``X'' by connecting opposite corners of the
;; frame.
(define x (list (make-segment (make-vect 0 0) (make-vect 1 1))
                (make-segment (make-vect 1 0) (make-vect 0 1))))

(paint (segments->painter x))

;; c. The painter that draws a diamond shape by connecting the midpoints of the
;; sides of the frame.

(define diamond (vects->segments (list (make-vect 0.5 0)
                                       (make-vect 1 0.5)
                                       (make-vect 0.5 1)
                                       (make-vect 0 0.5)
                                       (make-vect 0.5 0))))
(paint (segments->painter diamond))

;; d. The wave painter.
;;
;; Skipping that one.
