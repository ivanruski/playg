;; Exercise 3.31. The internal procedure accept-action-procedure! defined in
;; make-wire specifies that when a new action procedure is added to a wire, the
;; procedure is immediately run. Explain why this initialization is
;; necessary. In particular, trace through the half-adder example in the
;; paragraphs above and say how the system's response would differ if we had
;; defined accept-action-procedure! as

(define (accept-action-procedure! proc)
  (set! action-procedures (cons proc action-procedures)))


;; if we don't run the action procedure immediatelly, the half-adder won't work
;; as expected(at least initially), because of the inverter procedure
;; specifically.
;;
;; When we set A or B to 1, according to the half-adder description S should
;; become 1, however S depends on C being inverted and since, C's signal wasn't
;; changed, the first time we set A or B to 1 nothing happens. We would have to
;; set both A & B to 1, so that C's signal is changed and its post signal
;; change action is executed.
;;
;; I guess(even though it is a bit weird to me) we have to run the action proc
;; immediately, because some actions operate on signals which equal to 0 and
;; when we don't, we first have to set that signal to 1 somehow in order to
;; trigger the signal's post-change actions.


;; Playground

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
           (logical-or (get-signal a1) (get-signal a2))))
      (after-delay or-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))

  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

(define (logical-or s1 s2)
  (if (or (= s1 1) (= s2 1))
      1
      0))

(define (logical-and s1 s2)
  (if (and (= s1 1) (= s2 1))
      1
      0))

(define (after-delay delay proc)
  (proc))

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (debug-action d "d")
    (debug-action e "e")
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      ;; (proc)
      )
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            ((eq? m 'get-actions) action-procedures)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (call-each procedures)
  (if (null? procedures)
      'done
      (begin
        ((car procedures))
        (call-each (cdr procedures)))))


(define (add-action! wire action)
  ((wire 'add-action!) action))

(define (set-signal! wire signal)
  ((wire 'set-signal!) signal))

(define (get-signal wire)
  (wire 'get-signal))

(define (debug-action wire name)
  (add-action! wire
             (lambda ()
               (newline)
               (display name)
               (display "  New-value = ")
               (display (get-signal wire)))))

(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)
(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))

(half-adder input-1 input-2 sum carry)

(get-signal input-1)
(get-signal sum)

(debug-action sum "sum")
(debug-action carry "carry")

(set-signal! input-1 0)
(set-signal! input-2 1)

(set-signal! sum 0)

(get-signal input-1)
(get-signal input-2)
(get-signal sum)
(get-signal carry)
