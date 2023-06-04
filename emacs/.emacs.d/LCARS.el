;; This sets up the load path so that we can override it
(setq warning-suppress-log-types '((package reinitialization)))  (package-initialize)
(setq custom-file "~/.config/emacs/custom-settings.el")

(setq use-package-always-ensure t)
(load custom-file t)

(defvar my-laptop-p (equal (system-name) "defiant"))
(defvar my-tablet-p (not (null (getenv "ANDROID_ROOT")))
  "If non-nil, GNU Emacs is running on Termux.")
(when my-tablet-p (setq gnutls-algorithm-priority "NORMAL: -VERS-TLS1.3"))
(global-auto-revert-mode) ; simplifies syncing

(setq user-full-name "Vicente Trincado"
      user-mail-address "vtrincado.h@gmail.com")

(require 'package)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(require 'use-package)

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)
(quelpa-use-package-activate-advice)

(setq use-short-answers t) ;; When emacs asks yes/no, answer with y/n
(setq vc-follow-symlinks t) ;; If file is symlinkd, and under vc, follow link

(setq dired-kill-when-opening-new-dired-buffer t)
(setq calendar-week-start-day 1)

(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/organizer.org"))

(setq register-preview-delay 0)

(set-register ?L (cons 'file "~/.emacs.d/LCARS.org"))
(set-register ?n (cons 'file org-default-notes-file))
(set-register ?O (cons 'file org-directory))

(setq backup-directory-alist '(("." . "~/.config/emacs/backups")))
(with-eval-after-load 'tramp
  (add-to-list 'tramp-backup-directory-alist
               (cons tramp-file-name-regexp nil)))

(use-package evil
  :config
  (evil-mode 1)
  (evil-select-search-module 'evil-search-module 'evil-search))
; (use-package evil-surround
  ; :after evil
  ; :defer 2
  ; :config
  ; (global-evil-surround-mode 1))

(evil-define-key 'motion help-mode-map "q" 'kill-this-buffer)

(use-package kbd-mode
 :quelpa (kbd-mode :fetcher github :repo "kmonad/kbd-mode")
 :mode "\\.kbd\\'"
 :commands kbd-mode)

(setq default-frame-alist '((undecorated . t)))
(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(if my-laptop-p (scroll-bar-mode -1))

(use-package telephone-line
  :config
  (telephone-line-mode 1))

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

(use-package evil-org
  :ensure t
  :diminish evil-org-mode
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "◈" "❖" "◬" "∿")
        org-modern-list '((42 . "◦") (43 . "•") (45 . "–"))
        ))

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t
        org-pretty-entities t
        org-appear-autoemphasis t
        org-appear-autolinks nil
        org-appear-autosubmarkers t))

(setq org-modules '(org-protocol))

(eval-after-load 'org
  '(org-load-modules-maybe t))

(defun my-org-setup ()
  (org-indent-mode)
  (visual-line-mode 1)
  (centered-cursor-mode)
  (evil-org-mode))

(use-package org
  :hook (org-capture-mode . evil-insert-state)
  :hook (org-mode . my-org-setup)
  :config

(setq org-fontify-whole-heading-line t)
(setq org-ellipsis "⤵")
(setq org-agenda-current-time-string "⭠ now ───────────────────────────────────────")
(setq org-pretty-entities t)

(setq org-src-tab-acts-natively t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "SOMEDAY(s)" "NEXT(n)" "PROJ(p)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

(setq org-capture-templates
      '(("t" "To-do" entry (file+headline org-default-notes-file "Inbox")
         "* TODO %?\n%u\n")
        ("n" "Next Task" entry (file+headline org-default-notes-file "Tareas")
         "* NEXT %? \nDEADLINE: %t")
        ("e" "Event" entry (file+headline org-default-notes-file "Agendados")
         "* %^{Title} \n%^t\n%?\n")
        ("i" "Idea" entry (file+headline org-default-notes-file "Inbox")
         "* %? :IDEA: \n%u\n")
        ("a" "Author" entry (file+headline org-default-notes-file "Inbox")
         "* %^{Author} :AUTHOR:\n%u\n Intereses: %^{Interests}\n%?\n")       
        ("p" "Protocol" entry (file+headline org-default-notes-file "Inbox")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ("l" "Protocol Link" entry (file+headline org-default-notes-file "Inbox")
         "* [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]] :BOOKMARK: \n%u ")
        ))

) ;; Este paréntesis termina =use-key org=

(bind-key "C-c c" 'org-capture)
(bind-key "C-c a" 'org-agenda)

(use-package emacs-conflict
    :quelpa (emacs-conflict :fetcher github :repo "ibizaman/emacs-conflict"))
(global-set-key (kbd "C-c r r") 'emacs-conflict-resolve-conflicts)
(global-set-key (kbd "C-c r d") 'emacs-conflict-resolve-conflict-dired)

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [] into (), other chars left unchanged."
  (concat
   (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform)))

(use-package magit :defer t)
(use-package centered-cursor-mode ;;Devuelve un error que aun no se arreglar en Termux
  :diminish centered-cursor-mode
)
(use-package diminish)

;; Aquí terminan las configuraciones
