;; Exercise 3.25. Generalizing one- and two-dimensional tables, show how to
;; implement a table in which values are stored under an arbitrary number of
;; keys and different values may be stored under different numbers of keys. The
;; lookup and insert! procedures should take as input a list of keys used to
;; access the table.

(define (assoc records key)
  (if (null? records)
      #f
      (let ((record (car records)))
        (if (equal? (car record) key)
            record
            (assoc (cdr records) key)))))

(define (_lookup table keys)
  (if (null? keys)
      table
      (let ((key (car keys)))
        (let ((record (assoc (cdr table) key)))
          (if record
              (_lookup record (cdr keys))
              #f)))))

(define (lookup table keys)
  (let ((p (_lookup table keys)))
    (if (pair? p)
        (cdr p)
        p)))

(define (insert! table keys value)
  (define (create-nested-tables table keys)
    (if (null? keys)
        table
        (let ((subtable (assoc (cdr table) (car keys))))
          (if subtable
              (create-nested-tables subtable (cdr keys))
              (let ((subtable (make-table (car keys))))
                (let ((record (list subtable)))
                  (set-cdr! record (cdr table))
                  (set-cdr! table record)
                  (create-nested-tables subtable (cdr keys))))))))

  (if (null? keys)
      (error "keys cannot be empty -- INSERT!")
      (let ((record (_lookup table keys)))
        (if record
            (begin (set-cdr! record value)
                   table)
            (let ((nested-table (create-nested-tables table (drop-right keys 1)))
                  (record (list (cons (last keys) value))))
              (set-cdr! record (cdr nested-table))
              (set-cdr! nested-table record)
              table)))))

(define (make-table name)
  (list name))

;; tests
(define m (make-table '*table*))

(insert! m (list 'math '+) 43)
(insert! m (list 'math '-) 45)
(insert! m (list 'math '*) 42)

(insert! m (list 'letters 'a) 97)
(insert! m (list 'letters 'b) 98)

(lookup m (list 'math '+))
(lookup m (list 'letters 'b))

(insert! m (list 'key1) 1)
(insert! m (list 'key2) 2)

(lookup m (list 'key2))

(insert! m (list 'math '**) 422)

(lookup m (list 'math '+))
(lookup m (list 'math '*))
(lookup m (list 'math '**))

(lookup m (list 'letters 'a))
(lookup m (list 'letters 'b))
