;; Exercise 3.22. Instead of representing a queue as a pair of pointers, we can
;; build a queue as a procedure with local state. The local state will consist
;; of pointers to the beginning and the end of an ordinary list. Thus, the
;; make-queue procedure will have the form
;;
;; (define (make-queue)
;;   (let ((front-ptr ...)
;;         (rear-ptr ...))
;;     <definitions of internal procedures>
;;     (define (dispatch m) ...)
;;     dispatch))
;;
;; Complete the definition of make-queue and provide implementations of the
;; queue operations using this representation.

(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (empty?)
      (null? front-ptr))

    (define (front)
      (if (empty?)
          (error "FRONT called on an empty queue")
          (car front-ptr)))

    (define (insert element)
      (let ((new-entry (cons element '())))
        (if (empty?)
            (begin (set! front-ptr new-entry)
                   (set! rear-ptr new-entry))
            (begin (set-cdr! rear-ptr new-entry)
                   (set! rear-ptr new-entry)))))

    (define (delete)
      (if (empty?)
          (error "DELETE called on an empty queue")
          (set! front-ptr (cdr front-ptr))))

    (define (print)
      (define (print-elements front)
        (if (null? front)
            (newline)
            (begin (display (car front))
                   (display " ")
                   (print-elements (cdr front)))))
      (if (empty?)
          (begin (display "()")
                 (newline))
          (print-elements front-ptr)))
      
    (define (dispatch m)
      (cond ((eq? m 'empty?) (empty?))
            ((eq? m 'front) (front))
            ((eq? m 'insert) insert)
            ((eq? m 'delete) (delete))
            ((eq? m 'print) (print))
            (else (error "unknown operation -- QUEUE" m))))
    
    dispatch))
