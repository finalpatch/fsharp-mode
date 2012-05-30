# About

This work is a fork of the fsharp-mode originally developed by Laurent
Le Brun (http://sourceforge.net/projects/fsharp-mode/).

The changes I have made over the original version are:

* Much better syntax highlighting.  Function names, including active
  patterns, nested functions, member functions and constructors and
  even overloaded operators are all correctly highlighted in
  font-lock-function-name-face.  User defined types are highlighted in
  font-lock-type-face.  Attributes and namespaces are also
  highlighted.

* Supports debugging F# code (or any .NET code) inside Emacs.  This is
  implemented through a slightly modified version of the mdbg debugger
  (https://github.com/finalpatch/mdbg4emacs).

* Removed syntax highlighting in F# interactive window.  I had to
  remove it because I don't know how to make font lock only fontify
  user input and ignore the outputs.  If I leave it on then as soon as
  the F# shell prints out a quotation mark, everything after it will
  be highlighted in wrong colors.

# Installation

Add these lines to your .emacs file (and changes the paths to point to
your F# installation):

``` elisp
(autoload 'fsharp-mode "fsharp" "Major mode for editing F# code." t)
(autoload 'run-fsharp "inf-fsharp" "Run an inferior F# process." t)
(autoload 'mdbg "mdbg" "The CLR debugger" t)
(setq inferior-fsharp-program "PATH_TO_YOUR_FSI_EXE")
(setq fsharp-compiler "PATH_TO_YOUR_FSC_EXE")
(add-to-list 'auto-mode-alist '("\\.fs[iylx]?$" . fsharp-mode))
```

You can optionally bytecompile the .el files.
