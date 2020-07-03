;; publish.el
;; modified version of https://gitlab.com/psachin/psachin.gitlab.io/-/blob/blog_template/publish.el

;;; Commentary:
;; This script will convert the org-mode files in this directory into
;; html.

;;; Code:
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(package-refresh-contents)
(package-install 'htmlize)
(package-install 'org-plus-contrib)
(package-install 'ox-reveal)

(require 'org)
(require 'ox-publish)
;; (require 'htmlize)
;; (require 'ox-html)
;; (require 'ox-rss)
(require 'ox-reveal)

;; setting to nil, avoids "Author: x" at the bottom
(setq org-html-postamble nil
      org-export-with-author nil
      org-export-with-toc nil)

(defvar psachin-date-format "%b %d, %Y")

(setq org-html-divs '((preamble "header" "top")
                      (content "main" "content"))
      org-html-container-element "section"
      org-html-metadata-timestamp-format psachin-date-format
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link t
      org-html-doctype "html5"
      org-html-htmlize-output-type 'css
      org-src-fontify-natively t)


(defvar psachin-website-html-head
  "<link rel='icon' type='image/x-icon' href='/favicon.svg'/>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='stylesheet' href='/styles/topnav.css' type='text/css'/>
<link rel='stylesheet' href='/styles/site.css' type='text/css'/>
<link rel='stylesheet' href='/styles/syntax-coloring.css' type='text/css'/>")

(defun psachin-website-html-preamble (plist)
  "PLIST: An entry."
  ;; Skip adding subtitle to the post if :KEYWORDS don't have 'post' has a
  ;; keyword
  (when (string-match-p "post" (format "%s" (plist-get plist :keywords)))
    (plist-put plist
               :subtitle (format "Published on %s by %s."
                                 (org-export-get-date plist psachin-date-format)
                                 (car (plist-get plist :author)))))

  ;; Below content will be added anyways
"<div>
<ul class='topnav'>
<li class='home'><a href='/#dash'>ezup.dev</a></li>
<li><a class='active' href='./'>Blog</a></li>
<li><a href='/#pgp'>PGP</a></li>
<li><a href='/git/' target='_blank'><u>Git</u></a></li>
<li class='right'><a href='/#about'>About</a></li>
</ul>
</div>")


(defvar site-attachments
  (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                "ico" "cur" "css" "js" "woff" "html" "pdf"))
  "File types that are published as static files.")


(defun psachin/org-sitemap-format-entry (entry style project)
  "Format posts with author and published data in the index page.

ENTRY: file-name
STYLE:
PROJECT: `posts in this case."
  (cond ((not (directory-name-p entry))
         (format "*[[file:%s][%s]]*
                 #+HTML: <p class='pubdate'>by %s on %s.</p>"
                 entry
                 (org-publish-find-title entry project)
                 (car (org-publish-find-property entry :author project))
                 (format-time-string psachin-date-format
                                     (org-publish-find-date entry project))))
        ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(setq org-publish-project-alist
      `(("posts"
         :base-directory "posts"
         :base-extension "org"
         :recursive t
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public"
         :exclude ,(regexp-opt '("README.org" "draft"))
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Blog Index"
         :sitemap-format-entry psachin/org-sitemap-format-entry
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         ;;:html-link-home "/"
         ;;:html-link-up "/"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-head ,psachin-website-html-head
         :html-preamble psachin-website-html-preamble)
        ("rss"
         :base-directory "posts"
         :base-extension "org"
         :html-link-home "https://ezup.dev/blog/"
         :rss-link-home "https://ezup.dev/blog"
         :with-author t
         :author "Dash Eclipse"
         :email "dash@ezup.dev"
         :html-link-use-abs-url t
         ;;:org-rss-use-entry-url-as-guid t
         :html-link-org-files-as-html t
         :rss-extension "xml"
         :publishing-directory "./public"
         :publishing-function (org-rss-publish-to-rss)
         :section-number nil
         :exclude ".*"
         :include ("index.org")
         :table-of-contents nil)
        ("all" :components ("posts" "rss"))))

(provide 'publish)
;;; publish.el ends here
