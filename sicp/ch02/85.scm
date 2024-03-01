;; Exercise 2.85. This section mentioned a method for ``simplifying'' a data
;; object by lowering it in the tower of types as far as possible. Design a
;; procedure "drop" that accomplishes this for the tower described in exercise
;; 2.83. The key is to decide, in some general way, whether an object can be
;; lowered. For example, the complex number 1.5 + 0i can be lowered as far as
;; real, the complex number 1 + 0i can be lowered as far as integer, and the
;; complex number 2 + 3i cannot be lowered at all. Here is a plan for
;; determining whether an object can be lowered: Begin by defining a generic
;; operation "project" that ``pushes'' an object down in the tower. For example,
;; projecting a complex number would involve throwing away the imaginary
;; part. Then a number can be dropped if, when we project it and raise the
;; result back to the type we started with, we end up with something equal to
;; what we started with. Show how to implement this idea in detail, by writing a
;; drop procedure that drops an object as far as possible. You will need to
;; design the various projection operations and install "project" as a generic
;; operation in the system. You will also need to make use of a generic equality
;; predicate, such as described in exercise 2.79. Finally, use "drop" to rewrite
;; apply-generic from exercise 2.84 so that it ``simplifies'' its answers.

;; the project procs are installed in each package
(define (project n)
  (apply-generic 'project n))

(project (make-scheme-number 5))
(project (make-rational 5 8))
(project (make-real (make-scheme-number 5)))
(project (make-real (make-rational 5 9)))

;; drop - if droppable, drop else original
(define (drop arg)
  (if (not (datum? arg))
      arg
      (let ((dropped (project arg)))
        (cond ((eq? (type-tag arg) (type-tag dropped)) arg)
              ((equ? (raise dropped) arg) (drop dropped))
              (else arg)))))

(drop 5)
(drop (make-rational 10 3))
(drop (make-rational 10 2))

(drop (make-real (make-scheme-number 10)))
(drop (make-real (make-rational 10 3)))
(drop (make-real 1))
(drop (make-real 1.5))

(drop (make-complex-from-real-imag 1.5 0))
(drop (make-complex-from-real-imag 1 0))
(drop (make-complex-from-real-imag 1 3))

(add (make-scheme-number 3) (make-rational 5 1))
(add 1 (make-rational 9 3))
(add 1 (make-rational 9 4))

(add (make-real 1.8) (make-real (make-rational 5 3)))
;; 11/3 because of the way I implemented add-real
;; round 1.8 to 2, then 2 will become 2/1 and we'll add them

(add (make-real 1.8) (make-rational 5 3))

(add (make-real 1.8) (make-complex-from-real-imag 8 1))
(add 1 (make-complex-from-real-imag 5 3))
