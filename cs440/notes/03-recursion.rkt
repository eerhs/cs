#lang racket

(require racket/trace) ; for dynamic function call traces

#|--------------------------------------------------------------------------------
;; Recursion

- what is a recursive function?
  A function that calls itself (directly or indirectly)
- what are some common "rules" for writing recursive functions?
  Have a base case (terminal case)
  Each recursive call should be solving a "sub-problem" of the original
  Idea: make progress towards (a) base case in each recursive application
    Ensures termination
--------------------------------------------------------------------------------|#

;; Factorial: n! = n * (n - 1) * (n - 2) * ... * 1
(define (factorial n)
  (if (= n 1)
    1
    (* n (factorial (- n 1) ))))

; (trace factorial)

;; Integer summation: m + (m + 1) + (m + 2) + ... + n
(define (sum-from-to m n)
  (if (> m n)
    0
    (+ m (sum-from-to (add1 m) n))))

; (trace sum-from-to)

#|--------------------------------------------------------------------------------
 The above functions demonstrate *structural recursion*, because they recurse
 over the structure of the input data.
 
 We can represent natural numbers as self-referential structures to more
 explicitly demonstrate structural recursion.
--------------------------------------------------------------------------------|#

(struct Z () #:transparent)     ; zero
(struct S (pred) #:transparent) ; "successor" of pred

(define one   (S (Z)))
(define two   (S one))
(define three (S two))
(define four  (S three))

;; What is the general form of a structurally recursive function over the natural numbers?
(define (nats-rec-form n)
  (cond [(Z? n) '...]   ; base case
        [(S? n) ('... (nats-rec-form (S-pred n)) '...)]))
  
;; Add two natural numbers
;; add(m, n) = n, if m = 0
;;           = 1 + add(m-1, n), otherwise
(define (add-nats m n)
  (cond [(Z? m) n]  ; base case
        [(S? n) (S (add-nats (S-pred m) n))]))

#|--------------------------------------------------------------------------------
;; Proofs of correctness

- how can we prove that a structurally recursive function is correct?
  A variation on proofs by induction
    1. Prove the function is correct for the base case
    2. Assume that the funciton is correct for case k, prove that it is also correct for k+1
    3. Conclude that the function for all cases.

- can we apply this to `factorial` and the other functions above?


--------------------------------------------------------------------------------|#

#|--------------------------------------------------------------------------------
;; Tail recursion and Accumulators

- what is tail recursion?
  It means we are not doing anything on the way back, all the work is already done 
  and we are just wainting for the output from recursion.
  The final computation of the function is the recursive call

- what is an accumulator?
  Its job is to hold on to an intermediate value

- why would we use these techniques?
--------------------------------------------------------------------------------|#

(define (factorial-tail n [acc 1])
  ((if (= n 1)
    acc
    (factorial-tail (sub1 n) (* n acc)))))

; (trace factorial-tail)

(define (sum-from-to-tail m n [acc 0])
  ((if (> m n)
    acc
    (sum-from-to-tail (add1 m) n (+ m acc)))))

; (trace sum-from-to-tail)

(define (add-nats-tail m n [acc n])
  (cond [(Z? m) acc]  ; base case
        [(S? n) ((add-nats-tail (S-pred m) n (S (acc))))]))

; (trace add-nats-tail)

#|--------------------------------------------------------------------------------
;; Structural recursion on lists
--------------------------------------------------------------------------------|#

;; length: the number of elements in a list
(define (length lst)
  (if (empty? lst)
    0
    (add1 (length (rest lst)))))

(define (length-tail lst [acc 0])
  (if (empty? lst)
    acc
    (length-tail (rest lst) (add1 acc))))

;; concat: concatenate the elements of two lists
(define (concat l1 l2)
  (if (empty? l1)
    l2
    (cons (first l1)
          (concat (rest l1) l2))))

(define (concat-tail l1 l2 [acc l2])    ; doesn't work
  (if (empty? l1)
    acc
    (concat-tail (rest l1) l2)))

;; count-elements: count the number of elements in a tree (a nested list)
(define (count-elements tree)
  (cond [(empty? tree) 0]
        [(not (pair?) tree) 1]
        [else (+ (count-elements (car tree))    ; recursive case
                 (count-elements (cdr tree)))]))

;; repeat: create a list of n copies of x
(define (repeat n x)
  (if (= n 0)
    '()
    (cons x (repeat (sub1 n) x))))

(define (repeat-list n lst)
  (if (= n 0)
   '()
    (concat lst (repeat-list (sub1 n) lst))))


;; reverse: reverse the elements of a list
(define (reverse lst)
  (if (empty? lst)
    '()
    (concat (reverse (rest lst))
            (cons (first lst) '()))))

(define (reverse-tail lst [acc '()])
  (if (empty? lst)
    acc
    (reverse-tail (rest lst)
                  (cons (first lst) acc))))

#|--------------------------------------------------------------------------------
;; Generative recursion

- what is generative recursion, and how does it differ from structural recursion?
--------------------------------------------------------------------------------|#

(define (gcd m n)
  (cond
    [(= m 0) n]
    [(= n 0) m]
    [else (gcd n (remainder m n))]))
