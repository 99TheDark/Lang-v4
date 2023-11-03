package main

import (
	"fmt"
	"log"
	"os"
	"sulfur/src/checker"
	"sulfur/src/compiler"
	"sulfur/src/errors"
	"sulfur/src/lexer"
	"sulfur/src/parser"
	"sulfur/src/settings"
	"sulfur/src/utils"
	"time"
)

func main() {
	start := time.Now()
	args := utils.NewQueue(os.Args[1:])

	// TODO: Add build vs run mode
	if _, ok := args.Next(); !ok {
		log.Fatalln("No mode given")
	}

	var input string
	if arg, ok := args.Next(); ok {
		input = *arg
	} else {
		log.Fatalln("No file given")
	}

	for !args.Empty() {
		name := *args.Consume()

		if name[0] == '-' { // Is a flag
			switch name[1:] {
			case "trace":
				settings.Stacktrace = true
			case "debug":
				settings.Debug = true
			case "colorless":
				settings.Colored = false
			}
		}
	}

	build(input)

	fmt.Println("Compile time:", time.Since(start))
}

func build(path string) {
	name := utils.FileName(path)

	code, err := lexer.GetSourceCode(path)
	if err != nil {
		log.Fatalln(err)
	}

	errors.Errors = errors.NewErrorGenerator(code)

	errors.Step = errors.Lexing
	unfiltered := lexer.Lex(code)
	if err := lexer.Save(unfiltered, "cli/debug/unfiltered.txt"); err != nil { // TODO: Only work in Debug mode
		log.Fatalln(err)
	}

	tokens := lexer.Filter(unfiltered)
	if err := lexer.Save(tokens, "cli/debug/tokens.txt"); err != nil { // TODO: Only work in Debug mode
		log.Fatalln(err)
	}

	errors.Step = errors.Parsing
	ast := parser.Parse(code, tokens)
	if err := parser.Save(ast, 1, "cli/debug/ast.json"); err != nil { // TODO: Only work in Debug mode
		log.Fatalln(err)
	}

	errors.Step = errors.Inferring
	props := checker.TypeCheck(ast)

	errors.Step = errors.Generating
	llcode := compiler.Generate(ast, props, path)
	if err := compiler.Save("; ModuleID = '"+path+"'\n"+llcode, "cli/tmp/"+name+".ll"); err != nil {
		log.Fatalln(err)
	}
}
