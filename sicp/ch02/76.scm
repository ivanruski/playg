;; Exercise 2.76. As a large system with generic operations evolves, new types
;; of data objects or new operations may be needed. For each of the three
;; strategies -- generic operations with explicit dispatch, data-directed style,
;; and message-passing-style -- describe the changes that must be made to a
;; system in order to add new types or new operations. Which organization would
;; be most appropriate for a system in which new types must often be added?
;; Which would be most appropriate for a system in which new operations must
;; often be added?

;;;; describe the changes that must be made to a system in order to add new types or new operations.

;; generic operations with explicit dispatch
;;
;; When we add a new type, we have to write the corresponding procedures for
;; that type and then update the generic procedures that doing the dispatching.
;;
;; When we add new operation, we have to implement the operation for each type
;; we have and then we have to write the generic procedure that will do the
;; dispatch.

;; data-directed style
;;
;; When we add a new type, we have to write the corresponding procedures for
;; that type and then we have to register them in the ddp table.
;;
;; When we add new operation, we have to implement that operation for each type
;; and register it in the ddp table for each type.

;; message-passing style
;;
;; When we add a new type, we have to implement the consturctor alongside each
;; operation.
;;
;; When we add new operation, we have to implement that operation for each type
;; and make sure that when the dispatch proc receives the new op as an argument
;; we recognize it.

;; Which organization would be most appropriate for a system in which new types
;; must often be added? Which would be most appropriate for a system in which
;; new operations must often be added?
;;
;; I think it boils down to personal preferences. I think that the generic
;; operations with explicit dispatch style is appropriate when the types and the
;; operations are static and new type/operation won't be added frequtently(or at
;; all).
;;
;; As for message-passing vs data-directed I think that it depends on what the
;; project is already using. Also I've never used any of them, so I am not sure
;; when the number of ops/types grow which style turns out to scale better.
