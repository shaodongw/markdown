#lang racket

(require "subjects.rkt")


;; Splice subject into sections and combine them into key-value pair.

(define (tag section)
  (first section))

(define (properties section)
  (second section))

(define (content section)
  (third section))
