;;; publish.el

(require 'package)
(package-initialize)
(unless package-archive-contents
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents))
(dolist (pkg '(org-plus-contrib htmlize))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(require 'org)
(require 'ox-publish)
(require 'ox-rss)


(defvar ezup-url "https://ezup.dev/blog/")
(defvar ezup-title "Dash Eclipse's Blog | ezup.dev")

(setq org-html-postamble nil)
      ;;org-export-with-author nil)
      ;;org-export-with-toc nil)

(setq org-html-divs '((preamble "header" "top")
                      (content "main" "content"))
      org-html-container-element "section"
      org-html-metadata-timestamp-format "%Y-%m-%d"
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link t
      org-html-doctype "html5"
      org-html-htmlize-output-type 'css
      org-src-fontify-natively t)

(defvar ezup-html-head
  "<link rel='icon' type='image/x-icon' href='/favicon.svg'/>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='stylesheet' href='/styles/topnav.css' type='text/css'/>
<link rel='stylesheet' href='/styles/site.css' type='text/css'/>
<link rel='stylesheet' href='/styles/syntax-coloring.css' type='text/css'/>
<link rel='alternate' type='application/rss+xml' title='RSS' href='/blog/rss.xml'>")

(defun ezup/prepostamble-format (type)
  "Return the content for the preamble/postamble of TYPE."
  `(("en" ,(with-temp-buffer
             (insert-file-contents (expand-file-name (format "%s.html" type) "layouts"))
             (buffer-string)))))

;; org-html-publish-to-html
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/lisp/ox-html.el#L3868-L3880
(defun ezup/org-html-publish-to-html (plist filename pub-dir)
  "Wrapper function to publish an file to html.

PLIST contains the properties, FILENAME the source file and
  PUB-DIR the output directory."
  (let ((project (cons 'ezup plist)))
    (plist-put plist :subtitle
               (format "Published on %s by %s."
                       (format-time-string "%Y-%m-%d" (org-publish-find-date filename project))
                       (plist-get plist :author)))
    (org-html-publish-to-html plist filename pub-dir)))


;; org-publish-sitemap-default
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/lisp/ox-publish.el#L911-L917
(defun ezup/org-publish-sitemap (title list)
  "Generate sitemap as a string, having TITLE.
LIST is an internal representation for the files to include, as
returned by `org-list-to-lisp'."
  ;;(let ((filtered-list (cl-remove-if (lambda (x)
                                       ;;(and (sequencep x) (null (car x))))
                                     ;;list)))
    (concat "#+TITLE: " title "\n"
            ;"#+OPTIONS: title:nil\n"
            "#+META_TYPE: website\n"
            "#+DESCRIPTION: Dash Eclipse's Personal Blog\n"
            ;;"\n#+ATTR_HTML: :class sitemap\n"
            ; TODO use org-list-to-subtree instead
            (org-list-to-org list)))


;; org-publish-sitemap-default-entry
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/lisp/ox-publish.el#L898-L909
(defun ezup/org-publish-sitemap-entry (entry style project)
  "Default format for site map ENTRY, as a string.
ENTRY is a file name.  STYLE is the style of the sitemap.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (format "[[file:%s][%s]]
                 #+HTML: <p class='pubdate'>by %s on %s.</p>"
                 entry
                 (org-publish-find-title entry project)
                 (car (org-publish-find-property entry :author project))
                 (format-time-string "%b %d, %Y"
                   (org-publish-find-date entry project))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

;; org-publish-sitemap-default
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/lisp/ox-publish.el#L911-L917
(defun ezup/org-publish-sitemap-rss (title list)
  "Default site map, as a string.
TITLE is the the title of the site map.  LIST is an internal
representation for the files to include, as returned by
`org-list-to-lisp'.  PROJECT is the current project."
  (concat "#+TITLE: " title "\n\n"
          (org-list-to-subtree list 1 '(:icount "" :istart ""))))

;; org-rss-publish-to-rss
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/contrib/lisp/ox-rss.el#L204-L223
(defun ezup/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish rss.org to RSS."
  (if (equal "rss.org" (file-name-nondirectory filename))
    (org-rss-publish-to-rss plist filename pub-dir)))

;; org-publish-sitemap-default-entry
;; https://code.orgmode.org/bzg/org-mode/src/release_9.3.7/lisp/ox-publish.el#L898-L909
(defun ezup/format-rss-feed-entry (entry style project)
  "Format ENTRY for the RSS feed.
ENTRY is a file name.  STYLE is either 'list' or 'tree'.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (let* ((file (org-publish--expand-file-name entry project))
                (title (org-publish-find-title entry project))
                (date (format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
                (link (concat (file-name-sans-extension entry) ".html")))
           (with-temp-buffer
             (insert (format "* %s\n" title))
             (org-set-property "RSS_PERMALINK" link)
             (org-set-property "PUBDATE" date)
	     ;;(insert-file-contents file)
             (buffer-string))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

;; https://orgmode.org/manual/Complex-example.html#Complex-example
;; https://orgmode.org/manual/Site-map.html
(setq org-publish-project-alist
      `(("posts"
         :base-directory "posts"
         :recursive t
         ;;:section-numbers nil
         :with-toc nil
         :base-extension "org"
         :exclude "rss.org\\|index.org"
         ;:exclude ,(regexp-opt '("rss.org" "index.org"))
         :publishing-function ezup/org-html-publish-to-html
         :publishing-directory ".web/blog"
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Blog Index"
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         :sitemap-function ezup/org-publish-sitemap
         :sitemap-format-entry ezup/org-publish-sitemap-entry
         :author "Dash Eclipse"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-head ,ezup-html-head
         :html-preamble-format ,(ezup/prepostamble-format "preamble"))
        ("rss"
         :base-directory "posts"
         :base-extension "org"
         :recursive nil
         ;:exclude ,(regexp-opt '("rss.org" "index.org"))
         :exclude "rss.org\\|index.org"
         :publishing-directory ".web/blog"
         :org-rss-use-entry-url-as-guid t
         ;;:publishing-function org-rss-publish-to-rss
         :publishing-function ezup/org-rss-publish-to-rss
         :rss-extension "xml"
         :html-link-home ,ezup-url
         :html-link-use-abs-url t
         :html-link-org-files-as-html t
         :auto-sitemap t
         ;;:exclude ".*"
         ;;:include ("index.org")
         :sitemap-filename "rss.org"
         :sitemap-title ,ezup-title
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         :sitemap-function ezup/org-publish-sitemap-rss
         :sitemap-format-entry ezup/format-rss-feed-entry
         :with-author t
         :author "Dash Eclipse"
         :email "dash@ezup.dev")
        ("images"
         :base-directory "images"
         :base-extension "svg\\|jpg\\|png"
         :publishing-directory ".web/images"
         :publishing-function org-publish-attachment)
        ("favicon"
         :base-directory "."
         :base-extension "svg"
         :publishing-directory ".web"
         :publishing-function org-publish-attachment)
        ("css"
         :base-directory "styles"
         :base-extension "css"
         :publishing-directory ".web/styles"
         :publishing-function org-publish-attachment)
        ("fonts"
         :base-directory "fonts"
         :base-extension "woff2"
         :publishing-directory ".web/fonts"
         :publishing-function org-publish-attachment)
        ("html"
         :base-directory "."
         :base-extension "html"
         :publishing-directory ".web"
         :publishing-function org-publish-attachment)
        ("website" :components ("posts" "rss" "images" "css" "fonts" "html"))))

(provide 'publish)

