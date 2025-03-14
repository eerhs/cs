#lang racket

(provide (all-defined-out)) ; export all top-level definitions

;;;;; Part 1: HOFs (and some utility functions)

(define (deep-map fn lst)
  (cond
    [(empty? lst) '()]
    [(pair? lst) (cons (deep-map fn (car lst)) (deep-map fn (cdr lst)))]
    [(list? lst) (map (lambda (x) (deep-map fn x)) lst)]
    [else (fn lst)]))


(define (my-curry fn . rest)
  (cond [(equal? (procedure-arity fn) 0) fn]
        [(equal? (procedure-arity fn) (length rest)) (apply fn rest)]
        [else (lambda x (apply my-curry fn (append rest x)))]))


(define (lookup key lst)
  (cond
    [(null? lst) #f]
    [(equal? key (caar lst)) (cdar lst)]
    [else (lookup key (cdr lst))]))


(define (update key value lst)
  (cond
    [(null? lst) (list (cons key value))]
    [(equal? key (caar lst)) (cons (cons key value) (cdr lst))]
    [else (cons (car lst) (update key value (cdr lst)))]))


(define (make-object name)
  (let ((attributes (list (cons 'name name))))
    (lambda (msg key . val)
      (cond
        [(eq? msg 'get) (lookup key attributes)]
        [(eq? msg 'set) (set! attributes (update key (car val) attributes))]
        [(eq? msg 'update) (set! attributes (update key ((car val) (lookup key attributes)) attributes))]))))


;;;;; Part 2: Symbolic differentiation (no automated tests!)

; Check if exp is sum or product or power
(define (CheckSum exp)
  (and (pair? exp) (eq? (car exp) '+)))
(define (CheckProduct exp)
  (and (pair? exp) (eq? (car exp) '*)))
(define (CheckPower exp)
  (and (pair? exp) (eq? (car exp) '^)))

(define (MakeSum x y)
  (let rec ([ReturnLst '(+)]
            [lst (rest y)])
    (if (empty? lst)
        (reverse ReturnLst)
        (rec (cons (diff x (first lst)) ReturnLst) (rest lst)))))
(define (MakeSumProd x y)
  (list '+ x y))
(define (MakeProduct x y)
  (list '* x y))
(define (MakePower x y)
  (list '^ x y))

(define (diff var exp)
  (cond
    [(number? exp) 0]                                      ; Rule 1: derivative of constant is 0
    [(symbol? exp) (if (eq? exp var) 1 0)]                 ; Rule 2 and 3
    [(CheckSum exp) (MakeSum var exp)]                     ; Rule 5: sum rule
    [(CheckProduct exp)                                    ; Rule 6: product rule
     (MakeSumProd
      (MakeProduct (cadr exp)
                     (diff var (caddr exp)))
      (MakeProduct (diff var (cadr exp))
                     (caddr exp)))]
    [(CheckPower exp)                                      ; Rule 4: power rule
     (MakeProduct
      (caddr exp)
      (MakePower (cadr exp) (sub1 (caddr exp))))]))


;;;;; Part 3: Meta-circular evaluator

(define (my-eval rexp)
  (let my-eval-env ([rexp rexp]
                    [env '()])           ; environment (assoc list)
    (cond [(symbol? rexp)                ; variable
           (cdr (assoc rexp env))]
          [(eq? (first rexp) 'lambda)    ; lambda
           (lambda x (my-eval-env (third rexp) (cons (cons (car (second rexp)) (car x)) env)))]
          [else                          ; function
           ((my-eval-env (first rexp) env) (my-eval-env (second rexp) env))])))


;;;;; Part 4: Free variables

(define (free sexp)
  (let free-env ([sexp sexp]
                 [env '()])              ; environment (assoc list)
    (cond
      [(symbol? sexp)
       (let ([pair (assoc sexp env)])
                 (if pair
                     '() 
                     (cons sexp '())))]
          [(eq? (first sexp) 'lambda)    ; lambda
           (free-env (third sexp) (cons (cons (car (second sexp)) #f) env))]
          [else                          ; function
           (append (free-env (first sexp) env) (free-env (second sexp) env))])))


;;;;; Extra credit: algebraic simplification (add your own tests)

;; Implemented features:
;; - ...
(define (simplify exp)
  (void))
