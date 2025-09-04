#lang racket

(require "anon-rec.rkt")
(require rackunit)

(define fact
  (lam/anon♻️ (n)
    (if (= n 0)
        1
        (* n ($MyInvocation (sub1 n))))))

(check-equal? (fact 0) 1)
(check-equal? (fact 5) 120)

(define (lucas-or-fib n0 n1)
  (lam/anon♻️ (n)
    (cond
      [(= n 0) n0]
      [(= n 1) n1]
      [(> n 1)
       (+ ($MyInvocation (- n 1))
          ($MyInvocation (- n 2)))])))

(define non-rec-fib (lucas-or-fib 0 1))
(check-equal? (non-rec-fib 5) 5)
(check-equal? (non-rec-fib 10) 55)

(define non-rec-lucas (lucas-or-fib 2 1))
(check-equal? (non-rec-lucas 5) 11)
(check-equal? (non-rec-lucas 10) 123)

(define grid
  (reverse ((lam/anon♻️ (n)
              (if (zero? n)
                  '()
                  (cons
                   (reverse ((lam/anon♻️ (n)
                               (if (zero? n)
                                   '()
                                   (cons n ($MyInvocation (sub1 n)))))
                             3))
                   ($MyInvocation (sub1 n)))))
            4)))

(check-equal? grid
              '((1 2 3)
                (1 2 3)
                (1 2 3)
                (1 2 3)))

(define (range from to)
  (unless (>= to from)
    (error 'range "~a must be at least as large as ~a" to from))
  (reverse
   ((lam/anon♻️ (n . args)
      (if (= n to)
          args
          (apply $MyInvocation
                 (add1 n)
                 (cons n args))))
    from)))

(check-exn exn:fail? (thunk (range 5 4)))
(check-equal? (range 5 5) empty)
(check-equal? (range 0 2) '(0 1))
(check-equal? (range 5 10) '(5 6 7 8 9))
