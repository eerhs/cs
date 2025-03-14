#lang racket

(require racket/trace)

#|-----------------------------------------------------------------------------
;; Prelude: user defined types with `struct`
-----------------------------------------------------------------------------|#

;; define a `widget` type
(struct widget          ; type name
  (name purpose price)  ; attributes
  #:transparent)        ; when printing a widget, show its attributes

;; we get the following functions for free:
;; - `widget`: constructor
;; - `widget?`: predicate that returns #t for widget values
;; - `widget-name`: retrieve `name` attribute
;; - `widget-purpose`: retrieve `purpose` attribute
;; - `widget-price`: retrieve `price` attribute

(define w1 (widget "wrench" "wrenching" 9.99))
(define w2 (widget "plier" "pliering" 12.99))


;; define a `doohickey` type that is a sub-type of `widget`
(struct doohickey widget (special-power) #:transparent)

(define d1 (doohickey "thingamajig" "thinging" 199.99 "time travel"))

;; we can also match against structs
(define (which-widget? w)
  (match w
    [(widget "wrench" _ _) "It's a wrench!"]
    [(doohickey "thingamajig" _ _ _) "It's a thingamajig!"]
    [(? widget?) "It's some sort of widget"]
    [_ "I don't know what this is"]))


#|-----------------------------------------------------------------------------
;; Our language

We're going to start with a very simple language and slowly add to it. Our
first iteration will support integer literals, the binary arithmetic operations
 +` and `*`, and `let`-bound variables. The syntax will mirror Racket's. 
-----------------------------------------------------------------------------|#

;; Some test cases
(define p1 "(+ 1 2)")

(define p2 "(* 2 (+ 3 4))")

(define p3 "(+ x 1)")

(define p4 "(* w (+ x y))")

(define p5 "(let ([x 10])
              (+ x 1))")

(define p6 "(let ([x 10]
                  [y 20])
              (+ x y))")

(define p7 "(let ([x 10])
              (let ([y 20])
                (+ x (let ([w 30])
                       (* w y)))))")

;; for demonstrating strict/lazy evaluation
(define p8 "(let ([x (+ 1 2)])
              20)")

(define p9 "(let ([x (+ 1 2)])
              (* x (+ x x)))")


#|-----------------------------------------------------------------------------
;; Parser

Review: What is parsing?

- Input string (source language) => Syntax object

- A syntax object contains information about the structure of the code. Often,
  we use a *tree* as an underlying representation.

  - E.g., the code "(let ([x 10]) (+ x 1))"
          
          may be parsed to the syntax tree:

                    let
                   /   \
                  x     +
                 /     / \
                10    x   1

  - Racket sexps are a programmatic way of representing syntax trees!

- Since our syntax mirrors Racket's, we may rely on Racket's reader to parse
  our input to produce an initial syntax tree.
-----------------------------------------------------------------------------|#

;;; using Racket's reader
#; (read)

(define (read-string str)
  (read (open-input-string str)))

#|-----------------------------------------------------------------------------
;; Parser (continued)

- Our syntax tree doesn't currently contain much information besides tokens
  pulled directly from the input string.

- Next, we will recursively descend through the syntax tree, "decorating" its
  nodes with information that can help us expand and evaluate it.
-----------------------------------------------------------------------------|#

;;; Some types for decorating our syntax tree

;; integer value
(struct int-exp (val) #:transparent)

;; arithmetic expression
(struct arith-exp (op lhs rhs) #:transparent)

;; variable
(struct var-exp (id) #:transparent)

;; let expression
(struct let-exp (ids vals body) #:transparent)


;; Parser (recursive-descent)
(define (parse sexp)
  (match sexp
    ;; naked integers
    [(? integer?)
      (int-exp sexp)]

    ;; arithmetic expressions
    [(list '+ lhs rhs)
      (arith-exp "ADD" (parse lhs) (parse rhs))]
    [(list '* lhs rhs)
      (arith-exp "MUL" (parse lhs) (parse rhs))]

    ;; variables
    [(? symbol?)
      (var-exp sexp)]

    ;; let expressions (single var)
    [(list 'let (list (list id exp)) body)
      (let-exp (list id)
               (list (parse exp))
               (parse (body)))]
    ;; let expressions (multi var)
    [(list 'let (list (list id exp)...) body)
      (let-exp id
               (map (parse exp))
               (parse (body)))]
  ))


#|-----------------------------------------------------------------------------
;; Interpreter

- The interpreter's job is to take the (decorated) syntax tree and evalute it!
-----------------------------------------------------------------------------|#

;; Interpreter
(define (eval expr [env '()])
  (match expr
    [(int-exp val)
      val]

    [(arith-exp "ADD" lhs rhs)
      (+ (eval lhs env) (eval rhs env))]
    [(arith-exp "MUL" lhs rhs)
      (* (eval lhs env) (eval rhs env))]


    ; "strict" evaluation
    [(var-exp id)
      (cdr (assoc id env))]       

    [(let-exp (list id)
              (list exp)
              body)
    (let ([nenv (cons (cons id (eval exp env))
                      env)])
      (eval body nenv))]

    ; "lazy" evaluation
    [(var-exp id)
      (eval (cdr (assoc id env)) env)]

    [(let-exp (list id)
              (list exp)
              body)
    (let ([nenv (cons (cons id exp)
                      env)])
      (eval body nenv))]



    [(let-exp (list id ...)
              (list exp ...)  
              body)
    (let ([nvars (map cons 
                      id
                      (map (lambda (e) (eval e env))
                          exp))])
        (eval body (append nvars env)))]
  ))


;; REPL
(define (repl)
  (let ([stx (parse (read))])
    (when stx
      (println (eval stx))
      (repl))))