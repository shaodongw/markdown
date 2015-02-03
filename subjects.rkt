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

(define (first-block is-sep? xs)
  (define (fst-sec is-sep? xs block)
    (cond
      [(empty? xs) empty]
      [(empty? (rest xs)) (first xs)]
      [(is-sep? (second xs)) (cons (first xs) empty)]
      [else (cons (first xs) (fst-sec is-sep? (rest xs) block))]))
  (fst-sec is-sep? xs empty))

(define (rest-block is-sep?  xs)
  (cond
    [(empty? xs) empty]
    [(empty? (rest xs)) empty]
    [(is-sep? (second xs))  (rest xs)]
    [else (rest-block is-sep? (rest xs))]))

(define (split-to-pieces first-b rest-b block)
  (cond 
    [(empty? block) empty]
    [(empty? (first-b block)) empty]
    [else (cons (first-b block) (split-to-pieces first-b rest-b (rest-b block)))]))

(define (split-to-subjects xs)
  (split-to-pieces first-subject rest-subject xs))

(define (first-subject xs)
  (first-block is-h1? xs))

(define (rest-subject xs)
  (rest-block is-h1? xs))

(define (is-h1? piece)
  (equal? (first piece) 'h1))

(define (first-section xs)
  (first-block is-h2? xs))

(define (rest-section xs)
  (rest-block is-h2? xs))

(define (is-h2? piece)
  (equal? (first piece) 'h2))

(define subjects
  (split-to-subjects xs))

(define (one-subject-to-sections subject)
  (split-to-pieces first-section rest-section subject))

(define (all-sections subjects)
  (map one-subject-to-sections subjects))


(define (compile-to-dictionary section)
  (define (compile sec ht)
    (let ([key (third (first section))]
          [val (rest section)])
      (hash-set! ht key val)
      ht))
  (compile section (make-hash)))

;(pretty-print (compile-to-dictionary (first sections)))
;(pretty-print  (all-sections subjects))
(for ([i subjects])
  (display "\n*****************************\n")
  (pretty-print i)
  (display "\n=============================\n")
  (for ([j (one-subject-to-sections i)])
    (display "\n++++++++++++++++++++++\n")
    (pretty-print j)
    (display "\n----------------------------------------\n")))


