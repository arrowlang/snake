SOURCES=$(shell find src -type f -iname '*.as')

all: build/snake

clean:
	@ -rm -rf ./build

build/snake.ll: $(SOURCES)
	@ mkdir -p ./build
	@ arrow --compile src/index.as > $@

build/snake-opt.ll: build/snake.ll
	@ opt -O3 -S $^ | opt -O3 -S | opt -O3 -S | opt -O3 -S > $@

build/snake.o: build/snake-opt.ll
	@ llc -filetype=obj -o $@ $^

build/snake: build/snake.o
	@ gcc -o $@ $^ -lc -lSDL2
