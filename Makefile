# detect operating system
ifeq ($(OS),Windows_NT)
    CURRENT_OS := Windows
else
    CURRENT_OS := $(shell uname -s)
endif

all: update install

# setup
build: clean
	pyinstaller --clean --distpath=dist handy.spec

install:
	pip install -U handi

setup:
	#pip install -e git+http://github.com/gustavkkk/handy.git#egg=handy
	python setup.py install

test:
	pytest

pypi: copy register upkg

github: login upsrc

# config
config: login copy register

login:
ifeq ($(CURRENT_OS),Windows)
	@echo "type mail:"
	@set /p mail=""
	@echo "type username:"
	@set /p username=""
	@echo "type password:"
	@set /p password=""
	@git config --global user.email "%mail%"
	@git config --global user.name "%username%"
	@git remote set-url origin https://%username%:%GITHUB_PASSWORD%@github.com/gustavkkk/handy.git
else
	@read -p "type mail:" mail;\
	read -p "type username:" username;\
	read -p "type password: " password;\
	git config --global user.email "$$mail"\
	git config --global user.name "$$password"\
	git remote set-url origin https://$$username:$$password@github.com/gustavkkk/handy.git	
endif


copy:
ifeq ($(CURRENT_OS),Windows)
	@copy .pypirc %USERPROFILE%
else
	@cp .pypirc $(HOME)
	@read -p "type username:" username;\
	read -p "type password: " password;\
	sed -i s/usrname/$$username/g $(HOME)/.pypirc;\
	sed -i s/passphrase/$$password/g $(HOME)/.pypirc
endif

register:
	@python3 setup.py register

# update
update: upsrc uppkg

upsrc: clean
ifeq ($(CURRENT_OS),Windows)
	@git add .
	@echo "type comment:"
	@set /p comment=""
	@git commit -m "%comment%"
	@git push origin master
else
	@git add .
	@read -p "type comment: " comment;\
	git commit -m "$$comment";\
	git push origin master
endif

upkg: version
	@python3 setup.py sdist upload
	
# clean part
clean: 
ifeq ($(CURRENT_OS),Windows)
	@del /q /s *.bak
	@del /q /s *.pyc
	@rmdir /q /s __pycache__
	@rmdir /q /s .pytest_cache
	@rmdir /q /s src
	@rmdir /q /s dist
	@rmdir /q /s build
	@rmdir /q /s handi.egg-info
else
	@find -name "*.pyc" -exec rm -f {} \;
	@find -name "*.deb" -exec rm -f {} \;
	@find -name "*.bak" -exec rm -f {} \;
	@find -name "*.tar.gz" -exec rm -f {} \;
	@find -name dist | xargs rm -rf
	@find -name .cache | xargs rm -rf
	@find -name build | xargs rm -rf
	@find -name handi.egg-info | xargs rm -rf
	@find -name .pytest_cache | xargs rm -rf
	@find -name __pycache__ | xargs rm -rf
	@find -name deb_dist | xargs rm -rf
	@find -name debian | xargs rm -rf
endif

version:
	@echo current version: $$(version handy)
	@read -p "type new version: " ver;\
	 repl $$(version handy) $${ver} handy/_version.py

pre:
	@dpkg -P scala

deb:
	@python setup.py --command-packages=stdeb.command bdist_deb

deb-fpm:
	@fpm -s python -t deb ../handy/setup.py

install-deb:
	@dpkg --force-overwrite -i deb_dist/python-handi_$$(version handy)-1_all.deb

install-deb-fpm:
	@dpkg --force-overwrite -i python-handi_$$(version handy)_all.deb

clear:
	@rm -f $$(which handy) $$(which delkey) $$(which beautifyjson) $$(which rmempty) $$(which chkey) $$(which findkey) $$(which repl) $$(which deline)
	@rm -f $$(which version) $$(which commit) $$(which totalines) 
	@rm -f $$(which die) $$(which cls) $$(which bashrc) $$(which chkbashrc) $$(which flush) $$(which upload) $$(which download)
	@rm -f $$(which hash) $$(which encode) $$(which decode) $$(which encrypt) $$(which decrypt)
	@rm -f $$(which column) $$(which row) $$(which findstr) $$(which extractstr) $$(which fromstr) $$(which endstr) $$(which lenstr) $$(which upperstr) $$(which lowerstr)
	@rm -f $$(which dirsize) $$(which linecount)

