;; Exercise 2.76. As a large system with generic operations evolves, new types
;; of data objects or new operations may be needed. For each of the three
;; strategies -- generic operations with explicit dispatch, data-directed style,
;; and message-passing-style -- describe the changes that must be made to a
;; system in order to add new types or new operations. Which organization would
;; be most appropriate for a system in which new types must often be added?
;; Which would be most appropriate for a system in which new operations must
;; often be added?

;;;; Explicit dispatch
;;
;; When a new operation is being added we have to implement the new procedure
;; that will dispatch to the supported types.
;;
;; When a new type is being added we have to modify all of the existing
;; procedures which dispatch, to know about that type.

;;;; Data-directed
;;
;; When a new operation is being added we have to register it in the table for
;; each type.
;;
;; When a new type is being added we have to register it in the table.

;;;; Message-passing
;;
;; It looks like this style requires the least ammount of changes to a
;; system. Apart from the actual implementations of operations and types I can't
;; think of anything else.

;;;; IMO data-directed and message-passing styles are both more appropriate then explicit
;; dispatch for each use-case.
;;
;; Of DD or MP I don't know which one is more appropriate then the other for
;; each use-case, I think it is a matter of preference. If a dev want to have
;; all of the operations encapsulated in a object then message-passing is more
;; appropriate. On the other hand if she want to have a isolated package with
;; more traditional procedures then data-directed.
