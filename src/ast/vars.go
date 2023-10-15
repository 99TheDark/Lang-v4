package ast

import (
	"fmt"
	. "sulfur/src/errors"
	"sulfur/src/lexer"
	"sulfur/src/typing"

	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
)

type VariableType int

const (
	Local VariableType = iota
	Global
	Parameter
)

type Variable struct {
	Name   string
	Id     int
	Type   typing.Type
	Status VariableType
	Value  *value.Value
}

type Scope struct {
	Parent   *Scope
	Vars     map[string]Variable
	Entrance *ir.Block
	Exit     *ir.Block
	Seperate bool
}

type FuncScope struct {
	Parent *FuncScope
	Return typing.Type
	Counts map[string]int
}

func (s *Scope) Lookup(name string, loc *lexer.Location) Variable {
	if vari, ok := s.Vars[name]; ok {
		return vari
	}
	if s.Parent == nil || s.Seperate {
		Errors.Error("'"+name+"' is not defined", loc)
	}
	return s.Parent.Lookup(name, loc)
}

func (s *Scope) Has(name string) bool {
	if _, ok := s.Vars[name]; ok {
		return true
	}
	if s.Parent == nil || s.Seperate {
		return false
	}
	return s.Parent.Has(name)
}

func (s *Scope) FindEntrance(loc *lexer.Location) *ir.Block {
	if s.Entrance != nil {
		return s.Entrance
	}
	if s.Parent == nil {
		Errors.Error("Something went wrong finding an entrance to a block", loc)
	}
	return s.Parent.FindEntrance(loc)
}

func (s *Scope) FindExit(loc *lexer.Location) *ir.Block {
	if s.Exit != nil {
		return s.Exit
	}
	if s.Parent == nil {
		Errors.Error("Something went wrong finding an exit to a block", loc)
	}
	return s.Parent.FindExit(loc)
}

func (v *Variable) LLName() string {
	if v.Id == 0 {
		return v.Name
	} else {
		return v.Name + "." + fmt.Sprint(v.Id)
	}
}

// TODO: Change to return a *Scope
func NewScope() Scope {
	return Scope{
		nil,
		make(map[string]Variable),
		nil,
		nil,
		false,
	}
}

func NewVariable(fscope *FuncScope, name string, typ typing.Type, status VariableType) Variable {
	vari := Variable{name, fscope.Counts[name], typ, status, new(value.Value)}
	fscope.Counts[name]++
	return vari
}
