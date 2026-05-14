;; extends

;; =============================================================================
;; Global mkFunc
;; =============================================================================
(apply_expression
  function: (_) @_func
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ]
  (#match? @_func "(^|\\.)mkFunc$")
  (#set! injection.language "lua"))
