#lang racket

(provide (all-defined-out)) ; export all top-level definitions for testing

(require racket/trace)


;; 1. Integer exponentiation
(define (iexpt n e)
  (if (= e 0)
      1
      (* n (iexpt n (- e 1)))))


;; 2. Polynomial evaluation
(define (poly-eval coeffs x)
  (define (helper coeffs x exp acc)
    (cond
      [(null? coeffs) acc]  ; If coeffs is empty, return accumulated result
      [else (helper (cdr coeffs) x (+ exp 1) 
                    (+ acc (* (car coeffs) (iexpt x exp))))]))  ; Multiply coefficient with x^exp and accumulate
  (helper coeffs x 0 0))  ; Start exponent and accumulator at 0


;; 3. List concatenation
(define (concatenate . lsts)
  (define (helper lsts acc)
    (cond
      [(null? lsts) (reverse acc)]  ; Reverse the accumulated result at the end
      [(null? (car lsts)) (helper (cdr lsts) acc)]  ; Skip empty lists
      [else (helper (cons (cdr (car lsts)) (cdr lsts)) 
                    (cons (car (car lsts)) acc))]))  ; Accumulate elements one by one
  (helper lsts '()))  ; Start with empty accumulator


;; 4. List ordered merging (non-tail-recursive)
(define (merge l1 l2)
  (cond
    [(null? l1) l2]  ; If l1 is empty, return l2
    [(null? l2) l1]  ; If l2 is empty, return l1
    [(<= (car l1) (car l2))  ; Compare first elements
     (cons (car l1) (merge (cdr l1) l2))]
    [else
     (cons (car l2) (merge l1 (cdr l2)))]))


;; 5. List ordered merging (tail-recursive)
(define (merge-tail l1 l2)
  (define (helper l1 l2 acc)
    (cond
      [(null? l1) (reverse acc l2)]  ; Reverse acc and prepend rest of l2
      [(null? l2) (reverse acc l1)]  ; Reverse acc and prepend rest of l1
      [(<= (car l1) (car l2))
       (helper (cdr l1) l2 (cons (car l1) acc))]  ; Add l1's head to acc
      [else
       (helper l1 (cdr l2) (cons (car l2) acc))])) ; Add l2's head to acc

  (define (reverse lst acc)
    (if (null? lst) acc
        (reverse (cdr lst) (cons (car lst) acc))))

  (helper l1 l2 '()))  ; Start merging with empty accumulator


;; 6. List run-length encoding
(define (run-length-encode lst)
  (define (helper remaining current count acc)
    (cond
      [(null? remaining) (reverse (cons (list current count) acc))]
      [(equal? (car remaining) current) 
       (helper (cdr remaining) current (+ count 1) acc)] ; Increase count
      [else 
       (helper (cdr remaining) (car remaining) 1 (cons (list current count) acc))])) ; Store previous and start new
  (if (null? lst)
      '()
      (helper (cdr lst) (car lst) 1 '()))) ; Start with first element


;; 7. List run-length decoding
(define (run-length-decode lst)
  (define (expand element count acc)
    (if (= count 0)
        acc
        (expand element (- count 1) (cons element acc)))) ; Add element for count times

  (define (helper remaining acc)
    (if (null? remaining)
        (reverse acc)  ; Reverse at end for correct order
        (helper (cdr remaining) (expand (caar remaining) (cadar remaining) acc))))

  (helper lst '()))
                 

;; 8. Labeling sexps
(define (label-sexp sexp)
    (match sexp
      [(? integer?) `(int ,sexp)] ; Integers

      [(? symbol?) `(var ,sexp)] ; Variable symbols

      ;; Arithmetic expressions
      [(list (and op (or '+ '* '/ '-)) lhs rhs)
       `(arith (op ,op) ,(label-sexp lhs) ,(label-sexp rhs))]

      ;; Function calls
      [(list (and fname (? symbol?)) arg)
     `(funcall (name ,fname) ,(label-sexp arg))]

      [_ (error "Can't label!" sexp)]))
      