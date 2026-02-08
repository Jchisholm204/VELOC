# VELOC Makefile


# -- Configuration --
INSTALL_PREFIX ?= $(HOME)/.local
BUILD_TYPE ?= Debug
# Protocol between client and active backend (default: socket_queue). Only for advanced users.
PROTOCOL ?= socket_queue
# POSIX transfer method between scratch and persistent (default: direct, alternative: rw).
POSIX_IO ?= direct

# -- Internal Paths --
BUILD_DIR := build
PRJ_DEPS_DIR := $(CURDIR)/deps
SUBDEPS := $(wildcard $(PRJ_DEPS_DIR)/*/)
DEP_TARGETS := $(SUBDEPS:/=)
# Map directories to their generated Makefiles
DEP_MAKEFILES := $(patsubst %/, %/build/Makefile, $(SUBDEPS))

# -- Compiler + CMake Flags --
CMAKE := cmake
CMAKE_COMMON += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
				-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
				-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
				-G "Unix Makefiles"

.PHONY: all build $(DEP_TARGETS) clean
all: build_deps build

# --- Dependency Rules ---

# This target ensures all dependency Makefiles are generated and then built
build_deps: $(DEP_MAKEFILES)
	@for dir in $(SUBDEPS); do \
		$(MAKE) -C $$dir/${BUILD_DIR} install --no-print-directory -j$(nproc); \
	done

# The pattern rule: This ONLY runs if CMakeLists.txt is newer than the Makefile
%/build/Makefile: %/CMakeLists.txt
	@echo "--- Configuring Dependency: $* ---"
	@mkdir -p $*/build
	$(CMAKE) -S $* -B$*/${BUILD_DIR} $(CMAKE_COMMON)

${BUILD_DIR}/Makefile:
	$(CMAKE) \
		-B${BUILD_DIR} \
		-DCOMM_QUEUE=$(PROTOCOL) \
		-DPOSIX_IO=$(POSIX_IO) \
		$(CMAKE_COMMON)

cmake: ${BUILD_DIR}/Makefile

build: cmake
	$(MAKE) -C ${BUILD_DIR} install --no-print-directory -j$(nproc)

SRCS := $(shell find . -name '*.[ch]' -or -name '*.[ch]pp')
%.format: %
	clang-format -i $<
format: $(addsuffix .format, ${SRCS})

clean:
	rm -rf $(BUILD_DIR)
	@for dir in $(SUBDEPS); do rm -rf $$dir/build; done


