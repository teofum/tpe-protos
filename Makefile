LD=gcc
GCC=gcc
GCCFLAGS=-g -std=c11 -Wall -Wno-missing-braces -Werror

SRC_DIR=src
OUT_DIR=out
OUTPUT=$(OUT_DIR)/tpe

SOURCES=$(wildcard $(SRC_DIR)/*.c)
HEADERS=$(wildcard $(SRC_DIR)/*.h)
OBJECTS=$(foreach I,$(notdir $(SOURCES:.c=.o)),$(OUT_DIR)/$I)

all: $(OUTPUT)

$(OUTPUT): $(LOADEROBJECT) $(OBJECTS) | $(OUT_DIR)
	$(LD) $(LDFLAGS) -o $(OUTPUT) $(OBJECTS)

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS) | $(OUT_DIR)
	$(GCC) $(GCCFLAGS) -I$(SRC_DIR) -c $< -o $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR)

run: $(OUTPUT)
	$(OUTPUT)

report:
	make -C doc/report

watch_report:
	make watch -C doc/report

.PHONY: clean run report watch_report
