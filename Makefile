ASM=pasmo
SRC=src/kernel.asm
BUILD=build
TAP=build/kernel.tap
AFLAGS=--tapbas --alocal

.PHONY: all clean

all: $(TAP)

$(TAP): $(SRC) $(wildcard src/*.asm src/*.inc)
	mkdir -p $(BUILD)
	cd src && $(ASM) $(AFLAGS) kernel.asm ../$(TAP)

clean:
	rm -rf $(TAP)
