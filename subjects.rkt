#lang racket

(require markdown
        racket/runtime-path)

(provide subjects)

(define test-footnote-prefix 'unit-test) ;fixed, not from (gensym)

;;  Parse Markdown source file to list of xexprs.
(define-runtime-path test.md "./subject.markdown")
(define xs (parse-markdown (file->string test.md #:mode 'text)
                          test-footnote-prefix))

; Split the xexpr into subjects

(define (first-section is-sep? xs)
  (define (fst-sec is-sep? xs section)
    (cond
      [(empty? xs) empty]
      [(empty? (rest xs)) (first xs)]
      [(is-sep? (second xs)) (cons (first xs) empty)]
      [else (cons (first xs) (fst-sec is-sep? (rest xs) section))]))
  (fst-sec is-sep? xs empty))

(define (rest-section is-sep?  xs)
  (cond
    [(empty? xs) empty]
    [(empty? (rest xs)) empty]
    [(is-sep? (second xs))  (rest xs)]
    [else (rest-section is-sep? (rest xs))]))


(define (split-to-subjects xs)
  (cond 
    [(empty? xs) empty]
    [(empty? (first-subject xs)) empty]
    [else (cons (first-subject xs) (split-to-subjects (rest-subject xs)))]))

(define (first-subject xs)
  (first-section is-h1? xs))

(define (rest-subject xs)
  (rest-section is-h1? xs))
    
(define (is-h1? piece)
  (equal? (first piece) 'h1))


(define subjects
  (split-to-subjects xs))
