#lang racket

(require markdown
        racket/runtime-path)

(define test-footnote-prefix 'unit-test) ;fixed, not from (gensym)

;; 1. Parse Markdown source file to list of xexprs.
(define-runtime-path test.md "./subject.markdown")
(define xs (parse-markdown (file->string test.md #:mode 'text)
                          test-footnote-prefix))

(pretty-print xs)

;; 2. Optionally, process the xexprs somehow:
;; ... nom nom nom ...

;; 3. Splice them into an HTML `xexpr` and...
;; 4. Convert to HTML text:
;;(display-xexpr `(html ()
;;                     (head ())
;;                     (body () ,@xs)))