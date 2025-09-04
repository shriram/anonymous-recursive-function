#lang racket

(provide lam/anon♻️)

(define-syntax (lam/anon♻️ stx)
  (syntax-case stx ()
    [(lam args body ...)
     (with-syntax ([$MyInvocation
                    (datum->syntax (syntax lam)
                                   '$MyInvocation)])
       #'(letrec ([$MyInvocation
                   (lambda args body ...)])
           $MyInvocation))]))
