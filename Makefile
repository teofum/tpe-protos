LD					=	gcc
GCC					=	gcc
GCCFLAGS		=	-std=gnu11 -Wall -pedantic -Wno-missing-braces -Werror
CHECK_LIBS 	= -lcheck -lsubunit -lpthread -lm

SRC_DIR			= src
OUT_DIR			= out
BUILD_DIR		= build
TEST_DIR		= $(BUILD_DIR)/test

OUTPUT			= $(OUT_DIR)/tpe

SOURCES = $(filter-out %_test.c,$(wildcard $(SRC_DIR)/*.c))
HEADERS = $(wildcard $(SRC_DIR)/*.h)
OBJECTS = $(foreach I,$(notdir $(SOURCES:.c=.o)),$(BUILD_DIR)/$I)

TEST_SOURCES 	= $(filter %_test.c,$(wildcard $(SRC_DIR)/*.c))
TEST_BINARIES = $(foreach I,$(notdir $(TEST_SOURCES:_test.c=_test)),$(TEST_DIR)/$I)

# Make all targets in the docker container
# This is the default target for convenience, to build locally use "make all"
remote:
	docker compose run -q --rm --user "$(id -u):$(id -g)" dev make all

# Run in the docker container
run:
	docker compose run -q --rm --user "$(id -u):$(id -g)" dev $(OUTPUT)

# Run tests in the docker container
test:
	docker compose run -q --rm --user "$(id -u):$(id -g)" dev make build_tests
	docker compose run -q --rm --user "$(id -u):$(id -g)" dev .script/test.sh

build_tests: $(TEST_BINARIES)

all: $(OUTPUT)

$(OUTPUT): $(LOADEROBJECT) $(OBJECTS) | $(OUT_DIR)
	$(LD) $(LDFLAGS) -o $(OUTPUT) $(OBJECTS)

$(TEST_DIR)/buffer_test: $(SRC_DIR)/buffer_test.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(TEST_DIR)/netutils_test: $(SRC_DIR)/netutils_test.c $(SRC_DIR)/netutils.c $(SRC_DIR)/buffer.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(TEST_DIR)/parser_test: $(SRC_DIR)/parser_test.c $(SRC_DIR)/parser.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(TEST_DIR)/parser_utils_test: $(SRC_DIR)/parser_utils_test.c $(SRC_DIR)/parser_utils.c $(SRC_DIR)/parser.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(TEST_DIR)/selector_test: $(SRC_DIR)/selector_test.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(TEST_DIR)/stm_test: $(SRC_DIR)/stm_test.c $(SRC_DIR)/stm.c | $(TEST_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) $^ $(CHECK_LIBS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS) | $(BUILD_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -I$(dir $<) -c $< -o $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(TEST_DIR): $(BUILD_DIR)
	mkdir -p $(TEST_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(OUT_DIR) $(BUILD_DIR)

report:
	make -C doc/report

watch_report:
	make watch -C doc/report

.PHONY: clean run report watch_report remote run_remote
