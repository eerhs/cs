#lang racket

(require macro-debugger/stepper
         (for-syntax racket/base)
         (for-syntax racket/list))

#|------------------------------------------------------------------------------
;; Syntax objects

- syntax objects attach syntactical context to sexps
------------------------------------------------------------------------------|#

(define s #'(if #t    ;; #' is shorthand for `syntax`
                (println " hi")
                (println "bye")))

#; (syntax-source s)
#; (syntax-line s)
#; (syntax-column s)
#; (syntax->datum s)

;; `eval-syntax` evaluates syntax objects, like `eval` for sexps
#; (eval-syntax s)

#|------------------------------------------------------------------------------
;; Syntax transformers, aka "Macros"
------------------------------------------------------------------------------|#

;; `define-syntax` defines a macro

;; define our own 'infix form' transformer
;; e.g., (infix (1 + 2)) ==> (+ 1 2)

(define-syntax (infix stx)
  (let ([sexp (second (syntax->datum stx))])
    #`(#,(second sexp) #,(first sexp) #,(third sexp))))


;; define our own `if` special form (based on cond)
;; e.g., (my-if test e1 e2)
;;        --> (cond [test e1]
;;                  [else e2])

(define-syntax (my-if stx)
  (let ([sexp (syntax->datum stx)])
    #`(cond [#,(second sexp) #,(third sexp)]
            [else #,(fourth sexp)])))

#|----------------------------------------------------------------------------|#

;; `syntax-case` lets us pattern match on syntax objects
(define-syntax (infix-2 stx)
  (syntax-case stx ()
    [(_ (lhs op rhs))
     #'(op lhs rhs)]))


(define-syntax (my-if-2 stx)
  (syntax-case stx () 
    [(_ test e1 e2)         ; matched ids can be used directly in syntax forms
     #'(cond [test e1]
             [else e2])]))

#|----------------------------------------------------------------------------|#

;; define-syntax-rule is shorthand for a limited form of `syntax-case`
(define-syntax-rule (infix-3 (lhs op rhs))
  (op lhs rhs))


(define-syntax-rule (my-if-3 test e1 e2)
  (cond [test e1]
        [else e2]))


(define-syntax-rule (swap! x y)
  (let ([tmp x])
    (set! x y)
    (set! y tmp)))


;; define a macro that implements a loop
(define-syntax-rule (loop n body)
  (let rec ([i 0])
    (when (< i n)
      body
      (rec (add1 i)))))


;; Can we interact with the `i` introduced in the `loop` macro from "outside"?
;; No, due to the "Hygenic" property of syntax transformers


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