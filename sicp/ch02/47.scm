;; Exercise 2.47. Here are two possible constructors for frames:
;;
;; (define (make-frame origin edge1 edge2)
;;   (list origin edge1 edge2))
;;
;; (define (make-frame origin edge1 edge2)
;;   (cons origin (cons edge1 edge2)))
;; 
;; For each constructor supply the appropriate selectors to produce an
;; implementation for frames.

;; Option 1
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (caddr frame))

;; Option 2
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (cddr frame))
