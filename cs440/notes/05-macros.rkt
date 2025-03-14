#lang racket

(require macro-debugger/stepper
         (for-syntax racket/base)
         (for-syntax racket/list))

#|------------------------------------------------------------------------------
;; Syntax objects

- syntax objects attach syntactical context to sexps
------------------------------------------------------------------------------|#

(define s1 (syntax "hello world"))

(define s2 (syntax (foo bar 1 2 3)))

(define s3 #'(foo bar 1 2 3)) ; #' is shorthand for `syntax`

(define s4 #'(if (< 1 2) "true" "false"))

(define s5 #`(if #,(< 1 2) "true" "false"))

#; (values
    (syntax-source s3)
    (syntax-line s3)
    (syntax-column s3)
    (syntax->datum s3))

;; `eval-syntax` evaluates syntax objects, like `eval` for sexps

#; (eval-syntax s4)



#|------------------------------------------------------------------------------
;; Syntax transformers, aka "Macros"
------------------------------------------------------------------------------|#

;; `define-syntax` defines a macro

(define-syntax say-hi
  (lambda (stx) ; `stx` refers to the original syntax object 
    #`(quote (hi #,stx))))


(define-syntax (say-hi2 stx) ; alternate form
  #`(quote (hi #,stx)))


;; define a macro that supports infix notation (for binary functions)
(define-syntax (infix stx)
  (void))

#; (syntax->datum (expand-once #'(infix (2 * 3))))


;; define our own `if` special form (based on cond)
(define-syntax (my-if stx)
  (void))

#; (syntax->datum
    (expand-once #'(my-if (< 1 2)
                          (println "yes")
                          (println "no"))))

#; (syntax->datum
    (expand #'(my-if (< 1 2)
                     (println "yes")
                     (println "no"))))


;; `syntax-case` lets us pattern match on syntax objects
(define-syntax (infix2 stx)
  (syntax-case stx ()
    [(_ (lhs op rhs))
     #'(op lhs rhs)]))


(define-syntax (my-if-2 stx)
  (syntax-case stx (then otherwise) ; parentheses enclose syntax "literals"
    [(_ test exp1 exp2) ; matched ids can be used directly in syntax forms
     #'(cond [test exp1]
             [else exp2])]
    [(_ test then exp1 otherwise exp2)
     #'(cond [test exp1]
             [else exp2])]))

#; (syntax->datum
    (expand-once #'(my-if-2 (< 1 2)
                            (println "yes")
                            (println "no"))))

#; (syntax->datum
    (expand-once #'(my-if-2 (< 1 2)
                            then (println "yes")
                            otherwise (println "no"))))


;; define-syntax-rule is shorthand for a limited form of `syntax-case`
(define-syntax-rule (my-if-3 test exp1 exp2)
  (cond [test exp1]
        [else exp2]))


(define-syntax-rule (swap! x y)
  (let ([tmp x])
    (set! x y)
    (set! y tmp)))


;; define a macro that implements a loop
(define-syntax-rule (loop n body)
  (void))

;; can we interact with the `i` introduced in the `loop` macro from "outside"?
#; (loop 10 (println i))
#; (let ([i 10]) (loop i (println i)))


;; define a macro that implements a "for" loop, exposing the iterator var
(define-syntax-rule (for-loop var n body)
  (void))



#|------------------------------------------------------------------------------
;; Hygiene

- Racket macros are "hygienic" by design -- i.e., identifiers introduced by
  a macro exist in a separate lexical context from where it is called, and
  so cannot be accidentally (or intentionally) used by call-site code.
------------------------------------------------------------------------------|#

;; syntax objects created with `syntax` are hygienic -- their bindings are
;; determined by their lexical context (i.e., where they are defined):
(define x 440)
(define-syntax (hygienic stx)
  #'(println x))

#; (values
    (hygienic)
    (let ([x 10]) (hygienic)))

(define-syntax (hygienic2 stx)
  #'(define foo 440))


;; but `datum->syntax` allows us to "break" hygiene by inheriting the lexical
;; context of some other syntax object (e.g., from the call site)
(define-syntax (unhygienic stx)
  (datum->syntax stx '(println x)))

#; (values
    (unhygienic)
    (let ([x 10]) (unhygienic)))

(define-syntax (unhygienic2 stx)
  (datum->syntax stx '(define bar 440)))

#; (begin (unhygienic2)
       (println bar))


;; "Anaphoric if": a convenient programmer-defined control structure
;; 
;; an·a·phor | ˈanəˌfôr | (Noun)
;; - a word or phrase that refers to an earlier word or phrase
;;   (e.g., in "my cousin said she was coming", "she" is used as an
;;   anaphor for my cousin).

#; (aif (compute-test-result ...)  ; may be a lengthy computation
        (use it)      ; `it` refers to the result of the computation
        (else-case))  


;; what's wrong with the following attempt?
(define-syntax-rule (aif test exp1 exp2)
  (let ([it test])
    (if it
        exp1
        exp2)))


;; can you "fix" this? (need to manually break hygiene)
(define-syntax (aif-2 stx)
  (void))


;; still not perfect!