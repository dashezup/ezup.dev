all: publish

publish: publish.el
	@tidy --tidy-mark no --quiet yes -m index.html
	@echo "Publishing..."
	@emacs --batch --load publish.el --funcall org-publish-all
	@rm .web/keys/67965F307B110019691461A12463834FFD2CBDBB.asc
	@sed -i 's/dash@ezup.dev/\&#x64;\&#x61;\&#x73;\&#x68;\&#x40;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x2E;\&#x64;\&#x65;\&#x76;/g' .web/index.html
	@sed -i 's/dashezup@disroot.org/\&#x64;\&#x61;\&#x73;\&#x68;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x40;\&#x64;\&#x69;\&#x73;\&#x72;\&#x6F;\&#x6F;\&#x74;\&#x2E;\&#x6F;\&#x72;\&#x67;/g' .web/index.html
	@sed -i 's/dashezup@protonmail.com/\&#x64;\&#x61;\&#x73;\&#x68;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x40;\&#x70;\&#x72;\&#x6F;\&#x74;\&#x6F;\&#x6E;\&#x6D;\&#x61;\&#x69;\&#x6C;\&#x2E;\&#x63;\&#x6F;\&#x6D;/g' .web/index.html
	@rm -f .web/blog/*~

clean:
	@echo "Cleaning up..."
	@rm -rvf *.elc
	@rm -rvf .web
	@rm -rvf ~/.org-timestamps/*
