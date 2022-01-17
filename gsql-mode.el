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

   ;; '("@@[a-zA-Z0-9_]*" . font-lock-variable-name-face)
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
                                   "abort" "accum" "add" "alter" "batch" "begin" "create" "define" "delete" "directed" "distributed" "drop" "edge" "end"
                                   "eol" "export" "exprfunctions" "exprutil" "filename" "get" "global" "graph" "header" "heapaccum" "install" "job"
                                   "listaccum" "load" "loading" "mapaccum"
                                   "max-accum" "post-accum" "print" "put" "query" "run" "schema_change" "separator" "setaccum" "show" "sumaccum"
                                   "tokenbank" "typedef"
                                   "undirected" "use" "user_defined_header" "upsert" "using" "version" "vertex")))

;; Interactive definition
;; (defcustom sql-gsql-program (or (executable-find "gsql")
;;                                 "gsql")
(defcustom sql-gsql-program "gsql"
  "Command to start the GSQL CLI"
  :type 'file)

(defcustom sql-gsql-login-params '(user password database)
  "List of login parameters needed to connect to GSQL and select a graph"
  :type 'sql-login-params
  :version "3.4.0")

(defcustom sql-gsql-options nil
  "List of additional options for `sql-gsql-program'."
  :type '(repeat string)
  :version "3.4.0")

(defcustom sql-gsql-user "tigergraph"
  "User for interactive usage with GSQL CLI."
  :type 'string
  :version "3.4.0")

(defcustom sql-gsql-graph ""
  "Graph to use with GSQL CLI - defaults to null graph, meaning GLOBAL context."
  :type 'string
  :version "3.4.0")

(defun sql-gsql (&optional buffer)
  "Run gsql CLI as an inferior process"
  (interactive "P")
  (sql-product-interactive 'gsql buffer))

(defun sql-comint-gsql (product options &optional buf-name)
  "Create a comint buffer and connect to GSQL."
  ;; TODO: deal with nonstandard gsPort - is there an option using local gsql cmd?
  ;; (sql-comint product '((concat "--user=" sql-gsql-user) (concat"--graph=" sql-gsql-graph)))
  (let ((params
         (append
          options
          (if (not (string= "" sql-user))
              (list (concat "-u" sql-user)))
          (if (not (string= "" sql-password))
              (list (concat "-p" sql-password)))
          (if (not (string= "" sql-database))
              (list (concat "-g" sql-database))))))
    (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
    (sql-comint product params buf-name)))


(sql-add-product
 'gsql "GSQL"
 :free-software nil
 :sqli-program sql-gsql-program
 :font-lock gsql-mode-font-lock-keywords
 :sqli-login sql-gsql-login-params
 :sqli-options sql-gsql-options
 :sqli-comint-func 'sql-comint-gsql
 :prompt-regexp "^.*GSQL > "
 :terminator
 ;; :syntax-alist '((?\" . "\"")
 ;;                 (?- . "@") ;;- is no longer a comment character; inherit from standard syntax table
 ;;                 (?/ . ". 12b")
 ;;                 )
 )

(add-to-list 'auto-mode-alist '("\\.gsql\\'" . (lambda ()
                                                 (sql-mode)
                                                 (sql-set-product 'gsql))))
;(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
(provide 'gsql)
;;; gsql.el ends here
