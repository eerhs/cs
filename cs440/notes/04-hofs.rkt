#lang racket

(require racket/trace)

(define (foo x)
  (* 2 x))

(define (bar y)
  (+ 100 y))

(define (flip f)
  (lambda (x y) (f y x)))

#|-----------------------------------------------------------------------------
;; Higher-order functions (HOFs)

HOFs either take a function as an argument or return a function.

Some useful built-in HOFs and related functions:

- `apply`: apply a function to a list of arguments

- `curry`: returns a version of a function that can be partially applied

- `compose`: returns a function that is the composition of two other functions

- `eval`: evaluates a sexp
-----------------------------------------------------------------------------|#

;; `apply` applies a function to lists

; (apply + '(1 2 3))
; (apply + 1 2 '(3))

;; `curry` gives us partial application

(define (repeat n x)
  (if (= n 0)
    '()
    (cons x (repeat (sub1 n) x))))

(define curried-repeat (curry repeat))
(define thrice ((curry repeat) 3))

;; compose is a simple but powerful form of "functional "glue"

(define sabs (compose sqrt abs))

;; eval is like having access to the Racket compiler in Racket!

(define (my-if test e1 e2)
  (eval '(cond [, test ,e1]
              [else ,e2])))

;; delay

(define p (delay (+ 1 2)))

;; force

(force p)

(struct mypromise (thunk val) #:mutable)

(define (my-delay sexp)
  (mypromise (lambda () (eval sexp))
             #f))

(define (my-force p)
  (if (not (mypromise-val p))
      (let ([res ((mypromise-thunk p ))])
        (set-mypromise-val! p res)
        res)
      (mypromise-val p)))

#|-----------------------------------------------------------------------------
;; Some list-processing HOFs

- `map`: applies a function to every element of a list, returning the results

- `filter`: collects the values of a list for which a predicate tests true

- `foldr`: implements *primitive recursion*

- `foldl`: like `foldr`, but folds from the left; tail-recursive
-----------------------------------------------------------------------------|#

;; `map` examples
#; (values
   (map add1 (range 10))

   (map (curry * 2) (range 10))
 
   (map string-length '("hello" "how" "is" "the" "weather?")))

(define (map f lst)
  (if (empty?)
    '()
    (cons (f (first lst))
          (map f (rest)))))

;; `filter` examples
#; (values 
   (filter even? (range 10))
   
   (filter (curry < 5) (range 10))

   (filter (compose (curry equal? "hi")
                    car)
           '(("hi" "how" "are" "you")
             ("see" "you" "later")
             ("hi" "med" "low")
             ("hello" "there"))))

(define (filter p lst)
  (cond [(empty? lst)'()]
        [(p (first lst)) (cons (first lst)
                               (filter p (rest lst)))]
        [else (filter p (rest lst))]))


;; `foldr` examples
#; (values
    (foldr + 0 (range 10))

    (foldr cons '() (range 10))

    (foldr cons '(a b c d e) (range 5))

    (foldr (lambda (x acc) (cons x acc)) ; try trace-lambda
           '()
           (range 5)))

#;
(define (summation lst)
  (if (empty? lst)
    0
    (+ (first lst)
        (summation (rest (lst))))))

(define summation (curry foldr + 0))

(define (foldr op v lst)
  (if (empty? lst)
    v
    (op (first lst)
        (foldr op v (rest (lst))))))

;; `foldl` examples
#; (values
    (foldl + 0 (range 10))
    
    (foldl cons '() (range 10))
    
    (foldl cons '(a b c d e) (range 5))
    
    (foldl (lambda (x acc) (cons x acc)) ; try trace-lambda
           '()
           (range 5)))

(define (foldl op acc lst)
  (if (empty? lst)
    acc
    (foldl op
          (op (first lst) acc)
          (rest lst))))

#|-----------------------------------------------------------------------------
;; Lexical scope

- A free variable is bound to a value *in the environment where it is defined*, 
  regardless of when it is used

- This leads to one of the most important ideas we'll see: the *closure*
-----------------------------------------------------------------------------|#
