ifndef BUILD_TYPE
override BUILD_TYPE = Release
endif

ifndef VERBOSE
override VERBOSE = OFF
endif

.PHONY: install-format
install-format:
	pip3 install clang-format

.PHONY: check-format
check-format:
	find . -name "*.cpp" -exec clang-format -n --verbose {} \;
	find . -name "*.h" -exec clang-format -n --verbose {} \;

.PHONY: format
format:
	find . -name "*.cpp" -exec clang-format -i {} \;
	find . -name "*.h" -exec clang-format -i {} \;

.PHONY: install-python
install-python:
	pip install tensorflow

.PHONY: run-python
run-python:
	echo python python/djikstra.py
	python python/mytf.py

.PHONY: install-cmake
install-cmake:
	sudo apt-get update
	sudo apt-get install cmake -y

.PHONY: install-gtest
install-gtest:
	git clone https://github.com/google/googletest.git -b v1.14.0 googletest
	mkdir googletest-build
	cmake -S googletest -B googletest-build
	cmake --build googletest-build
	sudo make -C googletest-build install
	rm -rf googletest googletest-build

.PHONE: install-prerequisites
install-prerequisites: install-cmake install-gtest install-format

.PHONY: build
build:
	cmake -B build -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_VERBOSE_MAKEFILE=${VERBOSE}
	cmake --build build --config ${BUILD_TYPE}

.PHONY: clean
clean:
	rm -fR build
