;; Exercise 2.14. Demonstrate that Lem is right. Investigate the behavior of
;; the system on a variety of arithmetic expressions. Make some intervals A and
;; B, and use them in computing the expressions A/A and A/B. You will get the
;; most insight by using intervals whose width is a small percentage of the
;; center value. Examine the results of the computation in center-percent form
;; (see exercise 2.12). 

;; code for the exercise

(define (make-interval a b) (cons a b))

(define (lower-bound a) (car a))
(define (upper-bound a) (cdr a))

(define (add-interval a b)
  (make-interval (+ (lower-bound a) (lower-bound b))
                 (+ (upper-bound a) (upper-bound b))))

(define (mul-interval a b)
  (let ((x1 (* (lower-bound a) (lower-bound b)))
        (x2 (* (lower-bound a) (upper-bound b)))
        (x3 (* (upper-bound a) (lower-bound b)))
        (x4 (* (upper-bound a) (upper-bound b))))
    (make-interval (min x1 x2 x3 x4)
                   (max x1 x2 x3 x4))))

(define (sub-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
                 (- (upper-bound a) (lower-bound b))))

(define (div-interval a b)
  (define (spans-zero? i)
    (and (<= (lower-bound i) 0) (>= (upper-bound i) 0)))
  (if (or (spans-zero? a) (spans-zero? b))
      (error "cannot divide by interval spanning zero")
      (mul-interval a
                    (make-interval (/ 1 (upper-bound b))
                                   (/ 1 (lower-bound b))))))

(define (make-center-percent center percent)
  (let ((p (/ percent 100.)))
    (let ((var (* center p)))
      (make-interval (- center var)
                     (+ center var)))))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i))
     2))

(define (percent interval)
  (let ((center (/ (+ (lower-bound interval) (upper-bound interval))
                   2)))
    (* (/ (width interval) center)
       100)))

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define i1 (make-center-percent 100 0.5))
(define i2 (make-center-percent 200 0.4))

(define i3 (make-center-percent 1000 0.5))
(define i4 (make-center-percent 2000 0.5))


;; Note: 2.14, 2.15 and 2.16 were really difficult for me and some of the
;; following paragraphs might be stupid/incorrect/both.
;; I guess this is due to lack of knowledge on my side.
;; 
;; I got some help from this link https://stackoverflow.com/a/14131196

;; For numbers the two expressions produce the same result.
(define (parnum1 r1 r2)
  (/ (* r1 r2)
     (+ r1 r2)))

(define (parnum2 r1 r2)
  (/ 1.0
     (+ (/ 1.0 r1)
        (/ 1.0 r2))))

(define i (make-interval 2 3))
(div-interval i i)

;; Lem is right and the problem lays in the fact that interval arithmetic is not
;; the same as number arithmetic. For example (div-interval i i) won't produce
;; 1 as with numbers, but it will produce [2/3, 3/2] (the lowest possible and
;; the biggest possible number)

;; Exercise 2.15. Eva Lu Ator, another user, has also noticed the different
;; intervals computed by different but algebraically equivalent expressions. She
;; says that a formula to compute with intervals using Alyssa's system will
;; produce tightner error bounds if it can be written in such a form that no
;; variable that represents an uncertain number is repeated. Thus, she says,
;; par2 is a "better" program for parallel resistances than par1. Is she right?
;; Why?

;; The more we work with uncertain values(intervals) the more incorrect the
;; final result will be, that is why par2 is better

;; Exercise 2.16 Exercise 2.16. Explain, in general, why equivalent algebraic
;; expressions may lead to different answers. Can you devise an
;; interval-arithmetic package that does not have this shortcoming, or is this
;; task impossible? (Warning: This problem is very difficult.)

;; When we perform interval arithmetic, once we perform some operation we can't
;; go back to reduce the results of those operations to the original intervals.
;; For example:

(sub-interval (add-interval i i) i)

;; instead of giving us i, will give us [1,4], so the more we work with
;; intervals the more incorrect our results are going to get, that is why Eva is
;; saying that par2 is better.


