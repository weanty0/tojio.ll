p:
	@echo "make compile|run"

compile: src/lib.ll tojio.ll
	clang -nostdlib -static tojio.ll src/lib.ll -o tojio

run: compile
	./tojio
