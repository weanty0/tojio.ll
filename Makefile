p:
	@echo "make compile|run"

compile: src/lib.ll tojio.ll
	clang -nostdlib -static tojio.ll src/elx.ll -o tojio

run: compile
	./tojio
