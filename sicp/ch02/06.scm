;; Exercise 2.6. In case representing pairs as procedures wasn't mind-boggling
;; enough, consider that, in a language that can manipulate procedures, we can get
;; by without numbers (at least insofar as nonnegative integers are concerned) by
;; implementing 0 and the operation of adding 1 as

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;; This representation is known as Church numerals, after its inventor, Alonzo
;; Church, the logician who invented the lambda calculus.
;;
;; Define one and two directly (not in terms of zero and add-1). (Hint: Use
;; substitution to evaluate (add-1 zero)). Give a direct definition of the
;; addition procedure + (not in terms of repeated application of add-1).

;; -----------------------------------------------------------------------------

;; Some background - https://youtu.be/3VQ382QG-y4

;; λ - simple symbol manipulation framework for evaluating and defining functions.
;;
;; Alonzo Church was trying to create a system which can compute things which are
;; computable by some definiton of computable
;;
;; Combinator - a function with no free variables. Like the ones below

;; Identity - takes an a and returns it
;; λa.a
(define (I a) a)

;; Mockingbird - takes a function and calls that function passing in itself also
;; known as the self application combinator
;; λf.ff
(define (M f)
  (f f))

;; Kestrel - takes an 'a' and a 'b' and returns the 'a'
;; λa.λb.a
(define (K a)
  (lambda (b) a))

;; Kite - takes an 'a' and a 'b' and return the 'b'
;; λa.λb.b
(define (KI a)
  (lambda (b) b))

;; Cardinal - takes an 'f', 'a' and a 'b' and returns the result of f(b)(a)
;; λf.λa.λb.fba or λfab.fba
(define (C f)
  (lambda (a)
    (lambda (b)
      ((f b) a))))

;; Booleans
;; In modern programming languages we have sth like: bool ? first : second
;; We can translate this to λ - calculus, where bool will be a function
;; accepting two arguments and the TRUE boolean function will return the first
;; and the FALSE boolean function will return the second
(define T K)
(define F KI)

;; Negation - takes a boolean function and returns it's opposite
;; λp.pFT
(define (not p)
  ((p F) T))

;; And
;; λp.λq.pqp
(define (and* p)
  (lambda (q)
    ((p q) p)))

;; Or
;; λp.λq.ppq
(define (or* p)
  (lambda (q)
    ((p p) q)))

;; Boolean equality
;; λp.λq.p(qTF)(qFT) or
;; λp.λq.pq(not q)
(define (beq p)
  (lambda (q)
    ((p q) (not q))))

;; -----------------------------------------------------------------------------

;; Back to the Exercise

;; zero in scheme is
(define zero (lambda (f) (lambda (x) x)))
;; and in λ
;; λf.λx.x
;; λa.λb.b
;; if we change f with a and x with b we get the KI

;; add-1 in scheme is
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
;; and in λ
;; λn.λf.λx.f(nf)x

;; Using substitution to eval (add-1 zero)
(add-1 zero)
(lambda (f) (lambda (x) (f ((zero f) x))))
(lambda (f) (lambda (x) (f x)))

;; Using substition to eval it in λ
;; λn.λf.λx.f(nf)x λa.λb.b
;; λfx.f(λa.λb.b f)x
;; λfx.f(λb.b)x
;; λfx.fx
;;
;; I will try (add-1 (add-1 zero)) using λ
;; λn.λf.λx.f(nf)x λfx.fx
;; λf.λx.f(λfx.fx f)x
;; λf.λx.f(λx.fx)x
;; λf.fx.f(fx)
;;
;; zero is λfx.x
;; one is  λfx.fx
;; two is  λfx.f(fx)

;; defining one and two in scheme
(define (one f)
  (lambda (x) (f x)))

(define (two f)
  (lambda (x)
    (f (f x))))

;; Giving a direct definition of the addition procedure +
;;
;; λf.λa.λb.λx.((af)((bf)x))
(define (add f)
  (lambda (a)
    (lambda (b)
      (lambda (x)
        ((a f) ((b f) x))))))

(define (three f)
  (lambda (x)
    (f (f (f x)))))
