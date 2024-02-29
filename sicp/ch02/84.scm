;; Exercise 2.84. Using the raise operation of exercise 2.83, modify the
;; apply-generic procedure so that it coerces its arguments to have the same
;; type by the method of successive raising, as discussed in this section. You
;; will need to devise a way to test which of two types is higher in the
;; tower. Do this in a manner that is ``compatible'' with the rest of the system
;; and will not lead to problems in adding new levels to the tower.

(define (type-rank type)
  (let ((pt (parent-type type)))
    (if (null? pt)
        0
        (- (type-rank pt) 1))))

;; not a stable sort but it should do the job
(define (sort-types types)
  (if (null? types)
      '()
      (let ((head-type (car types))
            (head-rank (type-rank (car types)))
            (rest (cdr types)))
        (append (sort-types (filter (lambda (t) (<= (type-rank t) head-rank)) rest))
                (list head-type)
                (sort-types (filter (lambda (t) (> (type-rank t) head-rank)) rest))))))

(define (apply-generic op . args)
  (define (try-raise arg target-type)
    (if (eq? (type-tag arg) target-type)
        arg
        (try-raise (raise arg) target-type)))
  
  (let ((type-tags (map type-tag args)))
    (let ((broadest-type (last (sort-types type-tags)))
          (proc (get op type-tags)))
      (if (not (null? proc))
          (apply proc (map contents args))
          ;; attempt coercion and try again
          (let ((raised-args (map (lambda (arg) (try-raise arg broadest-type)) args)))
            (let ((proc (get op (map type-tag raised-args))))
              (if (null? proc)
                  (error "No method for these types" (list op (map type-tag raised-args)))
                  (apply proc (map contents raised-args)))))))))


;;;; examples
;; type-rank
(type-rank 'scheme-number)
(type-rank 'rational)
(type-rank 'real)
(type-rank 'complex)

;; sort + type-rank
(define nns (list (make-scheme-number 1)
                  (make-rational 1 1)
                  (make-complex-from-real-imag 1 1)
                  (make-real (make-rational 1 1))
                  (make-rational 1 2)
                  (make-scheme-number 1)
                  (make-real (make-rational 1 2))
                  (make-complex-from-real-imag 1 2)))

(sort-types (map type-tag nns))

;; raise-to
(try-raise (make-scheme-number 5) 'scheme-number)
(try-raise (make-scheme-number 5) 'rational)
(try-raise (make-scheme-number 5) 'real)
(try-raise (make-scheme-number 5) 'complex)

;; apply-generic
(add (make-scheme-number 5) (make-scheme-number 5))
(add (make-rational 5 5) (make-rational 5 5))
(add (make-scheme-number 5) (make-rational 5 5))
(add (make-scheme-number 5) (make-real (make-rational 5 5))) ;; fails, no add method for reals
(add (make-scheme-number 5) (make-complex-from-real-imag 5 0))

(add (make-rational 5 1) (make-complex-from-real-imag 10 0))

;; What will happen if we add a new type to the tower?
;;
;; We would have to implement our type package. In it we must put in the table a
;; parent-type function for that type e.g.
;;
;; (put 'parent-type 'scheme-number
;;      (lambda () 'rational))
;;
;; We would also have to put a 'raise function e.g
;;
;; (put 'raise '(scheme-number)
;;        (lambda (num) (make-rational num 1)))
;;
;; This two should be enough(I didn't tested it) and of course the op which we
;; are trying to execute(e.g. add).
