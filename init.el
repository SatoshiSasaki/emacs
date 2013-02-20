(eval-after-load "package"
  '(progn
     (setq marmalade-server "http://marmalade-repo.org/"
           url-http-attempt-keepalives nil ; melpa
           ;;インストールするディレクトリを指定
           package-user-dir (concat user-emacs-directory "packages")
           package-archives '(
                              ("ELPA" . "http://tromey.com/elpa/")
                              ("gnu" . "http://elpa.gnu.org/packages/")
                              ("marmalade" . "http://marmalade-repo.org/packages/")
                              ("melpa" . "http://melpa.milkbox.net/packages/")
                              ))
     (package-initialize) ;インストールしたパッケージにロードパスを通してロードする
     (unless (file-directory-p package-user-dir)
         (package-refresh-contents))
     (require 'cl)
     (mapcar (lambda (x)
               (when (not (package-installed-p x))
                 (package-install x)))
             '(marmalade
               rainbow-delimiters
               auto-complete
               pos-tip
               popwin
               ac-ja
               key-combo
               smartrep
               jaunte
               flex-autopair
               undo-tree
               color-moccur
               yasnippet
               window-layout
               e2wm
               quickrun
               zencoding-mode
               cperl-mode
               pod-mode
               helm
               helm-migemo
               flycheck
               ))
     ))

(require 'package)

;; load-path にサブディレクトリごと追加
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/")
           (default-directory my-lisp-dir))
      (add-to-list 'load-path my-lisp-dir)
      (normal-top-level-add-subdirs-to-load-path)))

(require 'auto-complete-config)
(ac-config-default)
(setq
 ac-use-menu-map t
 )
(define-key ac-completing-map "\M-/" 'ac-stop)
(define-key ac-mode-map (kbd "C-c h") 'ac-last-quick-help)
(define-key ac-mode-map (kbd "C-c H") 'ac-last-help)
(global-auto-complete-mode t)

;;; cperl-mode

(defalias 'perl-mode 'cperl-mode)
(autoload 'cperl-mode
  "cperl-mode" "alternate mode for editing Perl programs" t)
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|f?cgi\\|t\\|al\\|psgi\\)$" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

(defadvice cperl-indent-command
  (around cperl-indent-or-complete)
  "Changes \\[cperl-indent-commnd] so it autocompletes when at the end of a word."
  (if (looking-at "\\>")
    (dabbrev-expand nil)
  ad-do-it))

(eval-after-load "cperl-mode"
  '(progn
     ;;; perl-completion
     ;http://svn.coderepos.org/share/lang/elisp/perl-completion/trunk/perl-completion.el
     (require 'auto-complete)
     (require 'perl-completion)
     (require 'pod-mode)
     (require 'perlbrew)
     (add-to-list 'auto-mode-alist '("\\.pod$" . pod-mode))
     (setq cperl-indent-level 4
           ;cperl-auto-newline t
           cperl-indent-parens-as-block t
           cperl-close-paren-offset -4
           cperl-label-offset -4
           cperl-continued-statement-offset 4
           cperl-comment-column 40
           cperl-tab-always-indent nil
           cperl-highlight-variables-indiscriminately t
           cperl-hairy t
           cperl-font-lock t)
        (ad-activate 'cperl-indent-command)
;      (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;        (setq flymake-check-was-interrupted t))
;      (ad-activate 'flymake-post-syntax-check)
     ))

(add-hook 'cperl-mode-hook
          '(lambda ()
             (perl-completion-mode t)
             (add-to-list 'ac-sources 'ac-sources-perl-completion)
             (hs-minor-mode 1)
             (perlbrew-switch "perl-5.14.3")
             (setq indent-tabs-mode nil
                   plcmp-use-keymap nil
                   tab-width nil)
             ;; 表示
             (set-face-bold-p 'cperl-array-face nil)
             (set-face-background 'cperl-array-face "#999999")
             (set-face-bold-p 'cperl-hash-face nil)
             (set-face-italic-p 'cperl-hash-face nil)
             (set-face-background 'cperl-hash-face "#999999")

             (define-key plcmp-mode-map (kbd "C-M-i") 'plcmp-cmd-smart-complete)
             (define-key plcmp-mode-map (kbd "C-c d") 'plcmp-cmd-show-doc-at-point)
             )
          )

;; Mozc用設定
(setq mozc-candidate-style 'overlay)

;; key-binds
(global-set-key (kbd "C-x C-b") 'helm-mini)

;; mode-line
(set-default 'mode-line-buffer-identification
             '(buffer-file-name ("%f") ("%b")))

;; タブ 全角スペース CR+LF を色つけする
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\　])
        (tab-mark   ?\t     [?\xBB ?\t])))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

;; 画面サイズ指定
(setq initial-frame-alist
  (append '((top . 0)
            (left . 0)
            (width . 200)
            (height . 45)
  ) initial-frame-alist))

