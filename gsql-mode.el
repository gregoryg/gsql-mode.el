;;; gsql.el --- TigerGraph GSQL support for sql-mode
;; Copyright (C) 2021 Gregory Grubbs

;; Author: Gregory Grubbs <gregory@dynapse.com>
;; Homepage: https://github.com/gregoryg/gsql.el
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: languages
;;; Commentary:

;; This package adds GSQL to the sql-mode product list.
;; TODO: Add support for a comint buffer to GSQL CLI

;;; Code:
;; Here are the various faces that can be used by sql-font-lock-keywords-builder
     ;; 10 'font-lock-builtin-face
     ;;  1 'font-lock-comment-face
     ;;  2 'font-lock-doc-face
     ;;  1 'font-lock-function-name-face
     ;; 12 'font-lock-keyword-face
     ;;  1 'font-lock-preprocessor-face
     ;;  8 'font-lock-type-face
     ;;  1 'font-lock-variable-name-face
     ;;  1 'font-lock-warning-face


(require 'sql)
;; (require 'newcomment)
   ;; '("\/\*\(.*\n\)+? *\*\/" . font-lock-comment-face)
   ;; '(" "
;; /\*\(.\|
;; \)+?\*/
   ;; '("/\\*\\(.\\|^J\\)+? *\\*/" . font-lock-comment-face)

(defvar gsql-mode-font-lock-keywords
  (list
   ;; '("#.*" . font-lock-comment-face)
   ;; '("/\\*\\(.\\|\n\\)*?\\*/" . font-lock-comment-face)

   ;; '("@[a-zA-Z0-9_]*" . font-lock-variable-name-face)
   (sql-font-lock-keywords-builder 'font-lock-type-face nil
                                   "bool" "datetime" "double" "float" "int" "list" "map" "set" "string" "tuple" "uint"  )
   (sql-font-lock-keywords-builder 'font-lock-builtin-face nil
                                   "abs" "acos" "addTags" "ascii" "asin" "atan" "atan2" "avg" "ceil"
                                   "chr" "clear" "coalesce" "concat" "contains" "containsKey" "cos" "cosh" "count"
                                   "datetime_add" "datetime_diff" "datetime_format" "datetime_sub"
                                   "datetime_to_epoch" "day" "degrees" "difference" "differenceTags"
                                   "edgeAttribute" "epoch_to_datetime" "evaluate" "exp" "filter" "find_in_set"
                                   "flatten" "flatten_json_array" "float_to_int" "floor" "fmod" "get" "getAttr"
                                   "getBool" "getDouble" "getInt" "getJsonArray" "getJsonObject" "getString"
                                   "getTags" "getvid" "gsql_concat" "gsql_current_time_epoch" "gsql_day"
                                   "gsql_day_epoch" "gsql_find" "gsql_is_false" "gsql_is_not_empty_string"
                                   "gsql_is_true" "gsql_length" "gsql_lower" "gsql_ltrim" "gsql_month"
                                   "gsql_month_epoch" "gsql_regex_match" "gsql_regex_replace"
                                   "gsql_replace" "gsql_reverse" "gsql_rtrim" "gsql_split_by_space"
                                   "gsql_substring" "gsql_to_bool" "gsql_to_int" "gsql_to_uint"
                                   "gsql_token_equal" "gsql_token_ignore_case_equal" "gsql_trim"
                                   "gsql_ts_to_epoch_seconds" "gsql_upper" "gsql_uuid_v4" "gsql_year"
                                   "gsql_year_epoch" "hasTags" "hour" "ignore_if_exists" "instr"
                                   "intersectTags" "isDirected" "isTaggable" "ldexp" "left" "length" "log" "log10"
                                   "log2" "lower" "lpad" "ltrim" "max" "min" "minute" "month" "neighborAttribute"
                                   "neighbors" "now" "outdegree" "overwrite" "parse_json_array"
                                   "parse_json_object" "PI" "pop" "pow" "primary_id" "primary_id_as_attribute" "println" "radians" "rand" "reallocate"
                                   "reduce" "remove" "removeAll" "removeAllTags" "removeTags" "replace" "resize"
                                   "right" "round" "rpad" "rtrim" "second" "selectVertex" "setAttr" "sign" "sin"
                                   "sinh" "size" "soundex" "space" "split" "sqrt" "square" "str_to_int" "substr"
                                   "sum" "tan" "tanh" "to_datetime" "to_float" "to_int" "to_string" "to_vertex"
                                   "to_vertex_set" "token_len" "top" "translate" "trim" "trunc" "type"
                                   "upper" "year"
                                   )
   (sql-font-lock-keywords-builder 'font-lock-keyword-face nil
                                   "abort" "add" "alter" "batch" "begin" "create" "define" "delete" "directed" "distributed" "drop" "edge" "end" "eol" "export" "filename" "get" "global" "graph" "header" "install" "job" "load" "loading" "put" "query" "run" "schema_change" "separator" "undirected" "use" "user_defined_header" "upsert" "using" "version" "vertex")))

(sql-add-product
  'gsql "GSQL"
  :font-lock 'gsql-mode-font-lock-keywords
  :syntax-alist '((?\" . "\"")
                  (?- . "@") ;;- is no longer a comment character; inherit from standard syntax table
                  (?/ . ". 12b")
                  ))

(add-to-list 'auto-mode-alist '("\\.gsql\\'" . (lambda ()
                                                 (sql-mode)
                                                 (sql-set-product 'gsql))))
(provide 'gsql)
;;; gsql.el ends here
