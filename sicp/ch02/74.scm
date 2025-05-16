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
;; For my implementation to work, each division's personnel file should be
;; tagged with the division's name. Based on the division name attached to the
;; personnel file I'll get the appropriate get-record procedure from the DDP
;; table

(define (get-record employee-name personnel-file)
  (let ((fn (get 'get-record (tag personnel-file))))
    (fn employee-name (contents personnel-file))))

(define (get-personnel-file division-name)
  (let ((fn (get 'get-personnel-file division-name)))
    (fn)))

(define (install-division-a-procs)
  (define personnel-file '(((name ivan) (salary 1000) (address sofia))
                            ((salary 2000) (name lori) (address la))
                            ((salary 3000) (address ny) (name gosh))))

  (define (get-employee-name employee-record)
    (let ((name-field (find (lambda (rec-elem) (eq? (car rec-elem) 'name))
                            employee-record)))
      (cadr name-field)))

  (define (get-record employee-name personnel-file)
    (find (lambda (record)
            (eq? employee-name (get-employee-name record)))
          personnel-file))

  (put 'get-record 'division-a get-record)
  (put 'get-personnel-file 'division-a (lambda () (attach-tag 'division-a
                                                              personnel-file)))
  )

(define (install-division-b-procs)
  (define personnel-file '((ivan 1001 sofia)
                           (lori 2001 la)
                           (gosh 3001 ny)))

  (define (get-employee-name employee-record)
    (car employee-record))

  (define (get-record employee-name personnel-file)
    (find (lambda (record)
            (eq? employee-name (get-employee-name record)))
          personnel-file))

  (put 'get-record 'division-b get-record)
  (put 'get-personnel-file 'division-b (lambda () (attach-tag 'division-b
                                                              personnel-file)))
  )

;; b. Implement for headquarters a get-salary procedure that returns the salary
;; information from a given employee's record from any division's personnel
;; file. How should the record be structured in order to make this operation
;; work?
;;
;; The record must include a type tag similarly to the personnel-file. I have to
;; change the implementation of get-record to attach a type-tag.

;; the function will crash if the employee-record is invalid
(define (get-salary employee-record)
  ((get 'get-salary (tag employee-record)) (contents employee-record)))

(define (install-division-a-procs)
  (define personnel-file '(((name ivan) (salary 1000) (address sofia))
                            ((salary 2000) (name lori) (address la))
                            ((salary 3000) (address ny) (name gosh))))

  (define (get-employee-field field employee-record)
    (let ((f (find (lambda (rec-elem) (eq? (car rec-elem) field))
                   employee-record)))
      (cadr f)))

  (define (get-record employee-name personnel-file)
    (find (lambda (record)
            (eq? employee-name (get-employee-field 'name record)))
          personnel-file))

  ;; new in (b)
  (define (get-salary employee-record)
    (get-employee-field 'salary employee-record))

  (put 'get-salary 'division-a get-salary)

  ;; change from (a)
  (put 'get-record 'division-a (lambda (name file)
                                 (attach-tag 'division-a (get-record name file))))

  (put 'get-personnel-file 'division-a (lambda () (attach-tag 'division-a
                                                              personnel-file)))
  )

(define (install-division-b-procs)
  (define personnel-file '((ivan 1001 sofia)
                           (lori 2001 la)
                           (gosh 3001 ny)
                           (pepi 4001 london)))

  (define (get-employee-name employee-record)
    (car employee-record))

  (define (get-record employee-name personnel-file)
    (find (lambda (record)
            (eq? employee-name (get-employee-name record)))
          personnel-file))

  ;; new in (b)
  (define (get-salary employee-record)
    (cadr employee-record))

  (put 'get-salary 'division-b get-salary)

  ;; change from (a)
  (put 'get-record 'division-b (lambda (name file)
                                 (attach-tag 'division-b (get-record name file))))

  (put 'get-personnel-file 'division-b (lambda () (attach-tag 'division-b
                                                              personnel-file)))
  )

;;;;
(define (attach-tag tag datum)
  (cons tag datum))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "invalid datum -- CONTENTS" datum)))

(define (tag datum)
  (if (pair? datum)
      (car datum)
      (error "invalid datum -- TAG" datum)))

(define table '())

(define (put op type item)
  (set! table (cons (list op type item) table)))

(define (get op type)
  (let ((item (find (lambda (entry)
                      (and (equal? op (car entry))
                           (equal? type (cadr entry))))
                    table)))
    (if item
        (caddr item)
        (error "unknown combination of operation and type -- GET" op type))))

;; c. Implement for headquarters a find-employee-record procedure. This should
;; search all the divisions' files for the record of a given employee and return
;; the record. Assume that this procedure takes as arguments an employee's name
;; and a list of all the divisions' files.

(define (find-employee-record employee-name divisions-files)
  (map (lambda (personnel-file)
         (get-record employee-name personnel-file))
       divisions-files))

;; d. When Insatiable takes over a new company, what changes must be made in
;; order to incorporate the new personnel information into the central system?
;;
;; A new install-division-X-proc package will have to be defined.

(define (install-division-X-procs)
  (define personnel-file '(((name . ivan) (salary . 1002) (address . sofia))
                           ((name . pepi) (salary . 4002) (address . london))
                           ((name . stas) (salary . 5002) (address . paris))))

  (define (get-employee-field field employee-record)
    (cdr (find (lambda (pair) (eq? (car pair) field)) employee-record)))

  (define (get-record employee-name personnel-file)
    (find (lambda (record)
            (eq? employee-name (get-employee-field 'name record)))
          personnel-file))

  (define (get-salary employee-record)
    (get-employee-field 'salary employee-record))

  (put 'get-salary 'division-x get-salary)

  (put 'get-record 'division-x (lambda (name file)
                                 (attach-tag 'division-x (get-record name file))))

  (put 'get-personnel-file 'division-x (lambda () (attach-tag 'division-x
                                                              personnel-file)))
  )
