;; Exercise 2.74. Insatiable Enterprises, Inc., is a highly decentralized
;; conglomerate company consisting of a large number of independent divisions
;; located all over the world. The company's computer facilities have just been
;; interconnected by means of a clever network-interfacing scheme that makes the
;; entire network appear to any user to be a single computer. Insatiable's
;; president, in her first attempt to exploit the ability of the network to
;; extract administrative information from division files, is dismayed to
;; discover that, although all the division files have been implemented as data
;; structures in Scheme, the particular data structure used varies from division
;; to division. A meeting of division managers is hastily called to search for a
;; strategy to integrate the files that will satisfy headquarters' needs while
;; preserving the existing autonomy of the divisions.
;;
;; Show how such a strategy can be implemented with data-directed
;; programming. As an example, suppose that each division's personnel records
;; consist of a single file, which contains a set of records keyed on employees'
;; names. The structure of the set varies from division to
;; division. Furthermore, each employee's record is itself a set (structured
;; differently from division to division) that contains information keyed under
;; identifiers such as address and salary. In particular:
;;
;; a. Implement for headquarters a get-record procedure that retrieves a
;; specified employee's record from a specified personnel file. The procedure
;; should be applicable to any division's file. Explain how the individual
;; divisions' files should be structured. In particular, what type information
;; must be supplied?
;;
;; b. Implement for headquarters a get-salary procedure that returns the salary
;; information from a given employee's record from any division's personnel
;; file. How should the record be structured in order to make this operation
;; work?
;;
;; c. Implement for headquarters a find-employee-record procedure. This should
;; search all the divisions' files for the record of a given employee and return
;; the record. Assume that this procedure takes as arguments an employee's name
;; and a list of all the divisions' files.
;;
;; d. When Insatiable takes over a new company, what changes must be made in
;; order to incorporate the new personnel information into the central system?


;; a. Implement for headquarters a get-record procedure that retrieves a
;; specified employee's record from a specified personnel file. The procedure
;; should be applicable to any division's file. Explain how the individual
;; divisions' files should be structured. In particular, what type information
;; must be supplied?
;;
;; In order for my solution to work each division must attach its name to the
;; records file e.g. ('hr . records) pair must be passed to my get-record
;; implementation.
;;
;; Also each division must register its get-employee-name implementation and
;; records values into a table which is used by the get-record proc e.g.
;;
;; (put 'get-employee-name 'hr (lambda (record) ()))
;; (put 'records 'it (cons 'hr hr-records))

;; reuse table, get and put from exercise 73
(define table '())

(define (put op type item)
  (cond ((null? (get op type))
         (set! table (cons (list op type item) table))
         table)
        (else table)))

(define (get op type)
  (define (iter-table table)
    (if (null? table)
        '()
        (let ((elem (car table))
              (rest (cdr table)))
          (if (and (equal? (car elem) op)
                   (equal? (cadr elem) type))
              (caddr elem)
              (iter-table rest)))))
  (iter-table table))

(define (get-record personnel-file person-name)

  (define (division-name) (car personnel-file))
  (define (records) (cdr personnel-file))
  
  (define (get-employee-name division-name record)
    (let ((get-name-proc (get 'get-employee-name division-name)))
      (if (null? get-name-proc)
          (error "get-employee implementation not found for division -- GET-EMPLOYEE-NAME" division-name)
          (get-name-proc record))))

  (define (iter-file file)
    (if (null? file)
        '()
        (let ((name (get-employee-name (division-name) (car file))))
          (if (equal? person-name name)
              (car file)
              (iter-file (cdr file))))))
  
  (iter-file (records)))

(define (install-it-division-package)

  (define division-records '(((name "Ivan Ivanov") (age 28) (position "MTS3"))
                             ((name "Boris Stoyanov") (age 31) (position "MTS4"))
                             ((name "Hristian Iliev") (age 25) (position "MTS3"))
                             ((name "Angel Bohosyan") (age 23) (position "MTS1"))))

  (define (get-employee-name record)
    (cadar record))

  (put 'get-employee-name 'it get-employee-name)
  (put 'records 'it (cons 'it division-records))

  'done)

(define (install-sales-division-package)

  (define division-records '(((age 28) (position "FYS") (name "Patrick Schmidt"))
                             ((age 31) (position "SYS") (name "Jamie Socks"))))

  (define (get-employee-name record)
    (define (iter tuples)
      (if (null? tuples)
          '()
          (let ((key (caar tuples))
                (value (cadar tuples)))
            (if (equal? key 'name)
                value
                (iter (cdr tuples))))))
    (iter record))

  (put 'get-employee-name 'sales get-employee-name)
  (put 'records 'sales (cons 'sales division-records))

  'done)

;; b. Implement for headquarters a get-salary procedure that returns the salary
;; information from a given employee's record from any division's personnel
;; file. How should the record be structured in order to make this operation
;; work?  
;;
;; The get-salary procedure will be analogous to get-employee-name defined
;; within the get-record procedure. Every division record accross all divisions
;; must have a salary column.
;;
;; An alternative solution would be to attach the division to each employee
;; record. This would make get-employee-salary and get-employee-name to need
;; only the record and from the record we can get the division. If we go this
;; route every record across all divisions must have a salary, name and division
;; columns.

(define (get-employee-salary division-name record)
  (let ((get-salary-proc (get 'get-salary division-name)))
    (if (null? get-name-proc)
        (error "get-salary implementation not found for division -- GET-EMPLOYEE-SALARY" division-name)
        (get-salary-proc record))))

;; c. Implement for headquarters a find-employee-record procedure. This should
;; search all the divisions' files for the record of a given employee and return
;; the record. Assume that this procedure takes as arguments an employee's name
;; and a list of all the divisions' files.

(define (get-divisions)
  (define (iter-table t division-names)
    (if (null? t)
        division-names
        (let ((item (car t))
              (rest (cdr t)))
          (if (equal? (car item) 'records)
              (iter-table rest (append (list (caaddr item)) division-names))
              (iter-table rest division-names)))))
  (iter-table table '()))

(define (find-employee-record employee-name all-divisions)
  (define (iter-divisions divisions)
    (if (null? divisions)
        '()
        (let ((record (get-record (get 'records (car divisions)) employee-name)))
          (if (null? record)
              (iter-divisions (cdr divisions))
              record))))
  (iter-divisions all-divisions))

;; d. When Insatiable takes over a new company, what changes must be made in
;; order to incorporate the new personnel information into the central system?
;;
;; With the current implementation, when a new company is acquired, we have to
;; implement a install procedure which will insert into our table the relevant
;; get-employee-name procedure and get 'records for that division
(define (install-new-company-division-package)

  (define division-records '(((salary 0) (name ""))
                             ((salary 0) (name ""))))

  (define (get-employee-name record) '())

  (put 'get-employee-name 'new-company get-employee-name)
  (put 'records 'sales (cons 'new-company division-records))

  'done)
