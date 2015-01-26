#lang racket

(require markdown)

;; 1. Parse string to a list of xexprs
(define xs (parse-markdown "I am _emph_ and I am **strong**."))

(pretty-print xs)
; =>
'((p () "I am " (em () "emph") " and I am " (strong () "strong") "."))

;; 2. Optionally, process the xexprs somehow:
;; ... nom nom nom ...

;; 3. Splice them into an HTML `xexpr` and...
;; 4. Convert to HTML text:
(display-xexpr `(html ()
                      (head ())
                      (body () ,@xs)))
; =>
; <html>
;  <head></head>
;  <body>
;   <p>I am <em>emph</em> and I am <strong>strong</strong>.</p></body></html>