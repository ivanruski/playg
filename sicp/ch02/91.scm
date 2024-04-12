;; Exercise 2.91 A univariate polynomial can be divided by another one to
;; produce a polynomial quotient and a polynomial remainder. For example,
;; (x^5 - 1) / (x^2 - 1) = x^3 + x, reminder x - 1
;;
;; Division can be performed via long division. That is, divide the
;; highest-order term of the dividend by the highest-order term of the
;; divisor. The result is the first term of the quotient. Next, multiply the
;; result by the divisor, subtract that from the dividend, and produce the rest
;; of the answer by recursively dividing the difference by the divisor. Stop
;; when the order of the divisor exceeds the order of the dividend and declare
;; the dividend to be the remainder. Also, if the dividend ever becomes zero,
;; return zero as both quotient and remainder.
;;
;; We can design a div-poly procedure on the model of add-poly and mul-poly. The
;; procedure checks to see if the two polys have the same variable. If so,
;; div-poly strips off the variable and passes the problem to div-terms, which
;; performs the division operation on term lists. Div-poly finally reattaches
;; the variable to the result supplied by div-terms. It is convenient to design
;; div-terms to compute both the quotient and the remainder of a
;; division. Div-terms can take two term lists as arguments and return a list of
;; the quotient term list and the remainder term list.
;;
;; Complete the following definition of div-terms by filling in the missing
;; expressions. Use this to implement div-poly, which takes two polys as
;; arguments and returns a list of the quotient and remainder polys.

;; Solution
;; For sparse term lists

;; this function is implemented in the install-sparse-term-list-package package
;; and registered in the generic table.
(define (div-sparse-lists L1 L2)
  (if (empty-termlist? L1)
      (list (the-empty-termlist) (the-empty-termlist))
      (let ((t1 (first-term L1))
            (t2 (first-term L2)))
        (if (> (order t2) (order t1))
            (list (the-empty-termlist) L1)
            (let ((new-c (div (coeff t1) (coeff t2)))
                  (new-o (- (order t1) (order t2))))
              ;; 1. I have to multiply new-c^new-o by L2
              ;; 2. Substract the result from 1. from L1 i.e. L3 = L1 - (new-c^new-o * L2)
              ;; 3. call div-terms with L3, L2
              (let ((quotient (make-term new-o new-c)))
                (let ((L3 (sub-sparse-lists L1
                                            (mul-sparse-lists (adjoin-term quotient '()) L2))))
                  (let ((rest-of-result (div-sparse-lists L3 L2)))
                    (let ((QL (car rest-of-result))
                          (RL (cadr rest-of-result)))
                      (list (adjoin-term quotient QL)
                            RL))))))))))

;; For dense term lists
(define (div-dense-lists L1 L2)
    (if (empty-termlist? L1)
        (list (the-empty-termlist) (the-empty-termlist))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-termlist) L1)
              (let ((new-c (div (coeff t1) (coeff t2)))
                    (new-o (- (order t1) (order t2))))
                ;; 1. I have to multiply new-c^new-o by L2
                ;; 2. Substract the result from 1. from L1 i.e. L3 = L1 - (new-c^new-o * L2)
                ;; 3. call div-terms with L3, L2
                (let ((quotient (cons new-c (map (lambda (x) 0) (enumerate-interval 0 (- new-o 1))))))
                  (let ((L3 (sub-dense-lists L1
                                             (mul-dense-lists quotient L2))))
                    (let ((rest-of-result (div-dense-lists L3 L2)))
                      (let ((QL (car rest-of-result))
                            (RL (cadr rest-of-result)))
                        (list (add-dense-lists quotient QL)
                              RL))))))))))

;; The two solutions are almost exactly the same. In the previous exercise I
;; created generic procedures for lists but not for terms. If I had generic
;; procedures for terms I could have only one div-dense-lists.
;;
;; Also I don't think than the representation of div-terms is correct, because
;; we return two lists and if I want to do something like (add (div l1 l2) (div
;; l3 l4)), it would break.

(define sp1 (make-polynomial 'x (make-sparse-term-list '((5 1) (0 -1)))))
(define sp2 (make-polynomial 'x (make-sparse-term-list '((2 1) (0 -1)))))

(div sp1 sp2)

(define dp1 (make-polynomial 'x (make-dense-term-list '(1 0 0 0 0 -1))))
(define dp2 (make-polynomial 'x (make-dense-term-list '(1 0 -1))))

(div dp1 dp2)
