;; Exercise 1.44. The idea of smoothing a function is an important concept in
;; signal processing. If f is a function and dx is some small number, then the
;; smoothed version of f is the function whose value at a point x is the average of
;; f(x - dx), f(x), and f(x + dx). Write a procedure smooth that takes as input a
;; procedure that computes f and returns a procedure that computes the smoothed f.
;; 
;; It is sometimes valuable to repeatedly smooth a function (that is, smooth the
;; smoothed function, and so on) to obtained the n-fold smoothed function.
;;
;; Show how to generate the n-fold smoothed function of any given function using
;; smooth and repeated from exercise 1.43.

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose (repeated f (- n 1)) f)))

(define dx 0.0001)

(define (smooth fn)
  (lambda (x)
    (/ (+ (fn (- x dx))
          (fn x)
          (fn (+ x dx)))
       3)))

(define (n-fold-smooth fn n)
  ((repeated smooth n) fn))


;; Using the substitution model for (repeated smooth 2)
(repeated smooth 2)
(compose (repeated smooth 1) smooth)
(compose smooth smooth)
(lambda (fn)
  (smooth (smooth fn)))

(lambda (fn)
  (smooth (lambda (x)
             (/ (+ (fn (- x dx))
                   (fn x)
                   (fn (+ x dx)))
                3))))
(lambda (fn)
  (lambda (X)
    (/ (+ ((lambda (x) (/ (+ (fn (- x dx)) (fn x) (fn (+ x dx))) 3)) (- X dx))
          ((lambda (x) (/ (+ (fn (- x dx)) (fn x) (fn (+ x dx))) 3)) X)
          ((lambda (x) (/ (+ (fn (- x dx)) (fn x) (fn (+ x dx))) 3)) (+ X dx)))
       3)))
