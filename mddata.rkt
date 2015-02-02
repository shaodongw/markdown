#lang racket

(require markdown
        racket/runtime-path)

(define test-footnote-prefix 'unit-test) ;fixed, not from (gensym)

;; 1. Parse Markdown source file to list of xexprs.
(define-runtime-path test.md "./subject.markdown")
(define xs (parse-markdown (file->string test.md #:mode 'text)
                          test-footnote-prefix))

(define (split-to-subjects xs)
  (cond 
    [(empty? xs) empty]
    [(empty? (first-subject xs) empty)]
    [else (cons (first-subject xs) (split-to-subjects (rest-subject xs)))]))

(define (first-subject xs)
  (define (fst-sbj xs subject)
    (cond
      [(empty? xs) empty]
      [(is-h1? (second xs)) (cons (first xs) empty)]
      [else (cons (first xs) (fst-sbj (rest xs) subject))]))
  (fst-sbj xs empty))

(define (rest-subject xs)
  (cond
    [(empty? xs) empty]
    [(empty? (rest xs)) empty]
    [(is-h1? (second xs)) (rest xs)]))

(define (is-h1? piece)
  (equal? (first piece) 'h1))

(pretty-print (first-subject xs))
;(pretty-print (rest-subject xs))





;; 2. Optionally, process the xexprs somehow:
;; ... nom nom nom ...

;;xs


;; 3. Splice them into an HTML `xexpr` and...
;; 4. Convert to HTML text:
;;(display-xexpr `(html ()
;;                     (head ())
;;                     (body () ,@xs)))