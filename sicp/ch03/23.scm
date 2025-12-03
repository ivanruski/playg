;; Exercise 3.23. A deque (``double-ended queue'') is a sequence in which items
;; can be inserted and deleted at either the front or the rear. Operations on
;; deques are the constructor make-deque, the predicate empty-deque?, selectors
;; front-deque and rear-deque, and mutators front-insert-deque!,
;; rear-insert-deque!, front-delete-deque!, and rear-delete-deque!. Show how to
;; represent deques using pairs, and give implementations of the operations.
;; All operations should be accomplished in O(1) steps.

;; constructor: make-deque
;; predicate: empty-deque?
;; selectors: front-deque, rear-deque
;; mutators: [front|rear]-insert-deque!, [front|rear]-delete-deque!

;; I will use a list with 3 elements for each "node" in my deque:
;; - The first element will point to the previous (nil for the front ptr)
;; - The second element will be the value
;; - The third element will point to the next (nil for the rear ptr)

(define (make-deque)
  (let ((front-ptr '())
        (rear-ptr '()))

    (define (empty?)
      ;; there shouldn't be a situation in which the front-ptr is null but the
      ;; rear-ptr is not nil
      (null? front-ptr))

    (define (front)
      (if (empty?)
          (error "FRONT called on an empty deque")
          (cadr front-ptr)))

    (define (rear)
      (if (empty?)
          (error "REAR called on an empty deque")
          (cadr rear-ptr)))

    (define (front-insert! element)
      (let ((entry (list '() element '())))
        (if (empty?)
            (begin (set! front-ptr entry)
                   (set! rear-ptr entry))
            (begin (set-cdr! (cdr entry) front-ptr)
                   (set-car! front-ptr entry)
                   (set! front-ptr entry)))))

    (define (rear-insert! element)
      (if (empty?)
          (front-insert! element)
          (let ((entry (list '() element '())))
            (set-car! entry rear-ptr)
            (set-cdr! (cdr rear-ptr) entry)
            (set! rear-ptr entry))))

    (define (front-delete!)
      (if (empty?)
          (error "FRONT-DELETE! called on an empty deque")
          (let ((element (cadr front-ptr)))
            (if (eq? front-ptr rear-ptr)
                (begin (set! front-ptr '())
                       (set! rear-ptr '())
                       element)
                (begin (set! front-ptr (cddr front-ptr))
                       element)))))

    (define (rear-delete!)
      (cond ((empty?) (error "REAR-DELETE! called on an empty deque"))
            ((eq? front-ptr rear-ptr) (front-delete!))
            (else
             (let ((element (cadr rear-ptr)))
               (set! rear-ptr (car rear-ptr))
               element))))

    (define (print)
      (define (iter ptr)
        (if (eq? ptr rear-ptr)
            (begin (display (cadr ptr))
                   (newline))
            (begin (display (cadr ptr)) (display " -> ")
                   (iter (cddr ptr)))))
      (if (empty?)
          (begin (display "()")
                 (newline))
          (iter front-ptr)))

    (define (dispatch m)
      (cond ((eq? m 'empty?) empty?)
            ((eq? m 'front) front)
            ((eq? m 'rear) rear)
            ((eq? m 'front-insert!) front-insert!)
            ((eq? m 'rear-insert!) rear-insert!)
            ((eq? m 'front-delete!) front-delete!)
            ((eq? m 'rear-delete!) rear-delete!)
            ((eq? m 'print) print)
            (else
             (error "unknown operation -- DEQUE" m))))

    dispatch))

(define (empty-deque? d)
  ((d 'empty?)))

(define (front-deque d)
  ((d 'front)))

(define (rear-deque d)
  ((d 'rear)))

(define (front-insert-deque! d element)
  ((d 'front-insert!) element))

(define (rear-insert-deque! d element)
  ((d 'rear-insert!) element))

(define (front-delete-deque! d)
  ((d 'front-delete!)))

(define (rear-delete-deque! d)
  ((d 'rear-delete!)))

;; Tests

(define d (make-deque))
(front-insert-deque! d 4)
(front-insert-deque! d 3)
(front-insert-deque! d 2)

((d 'print))
;; 2 -> 3 -> 4

(front-deque d)
;; 2

(rear-deque d)
;; 4

(rear-insert-deque! d 5)
(rear-insert-deque! d 6)
(rear-insert-deque! d 7)

((d 'print))
;; 2 -> 3 -> 4 -> 5 -> 6 -> 7

(front-deque d)
;; 2

(rear-deque d)
;; 7

;; Do multiple front and rear deletes
(front-delete-deque! d)
(rear-delete-deque! d)

((d 'print))
