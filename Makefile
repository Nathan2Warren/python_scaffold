SHELL=/bin/bash

all: install format-check lint test

#set these
env_name = name
env_path = path

# f for file choice
ifdef f
	f = f
else
	f = .
endif

install:
	python3 -m venv ./${env_name}
	./${env_name}/bin/python3 -m pip install --upgrade pip
	./${env_name}/bin/pip3 install -r requirements.txt
	./${env_name}/bin/pre-commit install
	./${env_name}/bin/python3 -m ipykernel install --user --name ${env_name} --display-name "${env_name}"

install-conda:
	make install-kernel
	${env_path}/pip install --upgrade pip
	${env_path}/pip install -r requirements.txt
	${env_path}/pre-commit install

install-reqs:
	pip install --upgrade pip &&\
			pip install -r requirements.txt

install-kernel:
	conda create -n ${env_name} python=3.8 -y
	python -m ipykernel install --user --name ${env_name} --display-name "${env_name}"

format:
	black ${f}
	isort ${f}

format-check:
	black ${f} --check
	isort ${f} --check-only

lint:
        # stop the build if there are Python syntax errors or undefined names
	flake8 ${f} --select=E9,F63,F7,F82 --show-source
        # exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
	flake8 ${f} --exit-zero

test:
	echo "put tests here"

autolint:
	autoflake --remove-all-unused-imports ${f}

delete-env:
	conda env remove --name ${env_name}
