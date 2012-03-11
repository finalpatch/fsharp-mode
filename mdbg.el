(require 'gud)

(defvar gud-mdbg-history nil)
(defvar gud-mdbg-lastfile nil)

(defun gud-mdbg-marker-filter (string)
  (setq gud-marker-acc
	(if gud-marker-acc (concat gud-marker-acc string) string))
  (let (start)
    ;; Process all complete markers in this chunk
    (while
	(cond
	 ((string-match "{\\(\\(?:[A-Za-z]:\\)?[^:]+\\):\\([0-9]+\\)}\n"
			gud-marker-acc start)
	  (setq gud-last-frame
		(cons (match-string 1 gud-marker-acc)
		      (string-to-number (match-string 2 gud-marker-acc)))))
	 (t
	  (setq gud-mdbg-lastfile nil)))
      (setq start (match-end 0)))

    ;; Search for the last incomplete line in this chunk
    (while (string-match "\n" gud-marker-acc start)
      (setq start (match-end 0)))

    ;; If we have an incomplete line, store it in gud-marker-acc.
    (setq gud-marker-acc (substring gud-marker-acc (or start 0))))
  string)

(defun gud-mdbg-find-file (f)
  (find-file-noselect f))

;;;###autoload
(defun mdbg (command-line)
  "Run mdbg on program FILE in buffer *gud-FILE*.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger."
  (interactive (list (gud-query-cmdline 'mdbg)))

  (gud-common-init command-line nil 'gud-mdbg-marker-filter 'gud-mdbg-find-file)
  (set (make-local-variable 'gud-minor-mode) 'mdbg)

  (gud-def gud-break  "b %f:%l" "\C-b"   "Set breakpoint at current line.")
  (gud-def gud-step   "step" "\C-s"   "Step one source line with display.")
  (gud-def gud-next   "next" "\C-n"   "Step one line (skip functions).")
  (gud-def gud-cont   "go"   "\C-r"   "Continue with display.")
  (gud-def gud-finish "out"  "\C-f"   "Finish executing current function.")
  (gud-def gud-up     "up"   "<"      "Up N stack frames (numeric arg).")
  (gud-def gud-down   "down" ">"      "Down N stack frames (numeric arg).")

  (setq comint-prompt-regexp  "^\\(\\[[^]]*] \\)?mdbg> ")
  (setq paragraph-start comint-prompt-regexp)
  (run-hooks 'mdbg-mode-hook))

(provide 'mdbg)
