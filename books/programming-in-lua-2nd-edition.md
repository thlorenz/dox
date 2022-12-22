---
file:    Programming in Lua Second Edition 2.pdf
date:    Fri Sep 11 05:37:08 2020
created with: https://github.com/thlorenz/pdf-annotations-converter
---

# [Programming in Lua Second Edition 2](https://www.amazon.com/exec/obidos/ASIN/8590379825/lua-pilindex-20)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Tables](#tables)
- [Functions](#functions)
- [Errors](#errors)
- [Error Messages and Tracebacks](#error-messages-and-tracebacks)
- [Coroutines](#coroutines)
- [Serialization](#serialization)
- [Metatables and Metamethods](#metatables-and-metamethods)
- [Arithmetic Metamethods](#arithmetic-metamethods)
- [Relational Metamethods](#relational-metamethods)
- [Table-Access Metamethods](#table-access-metamethods)
- [Tables with default values](#tables-with-default-values)
- [Tracking table accesses](#tracking-table-accesses)
- [The Environment](#the-environment)
- [Modules and Packages](#modules-and-packages)
- [Using Environments](#using-environments)
- [Object-Oriented Programming](#object-oriented-programming)
- [Classes](#classes)
- [Inheritance](#inheritance)
- [Privacy](#privacy)
- [Weak Tables](#weak-tables)
- [Debug Library](#debug-library)
- [Profiles](#profiles)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<p align='right' style="float: right;"><i>Page 13 (32)</i></p>

## Tables

<p align='right' style="float: right;"><i>Page 15 (34)</i></p>

- customary in Lua to start arrays with 1 (and not with 0
- length operator ‘#' returns the last index (or the size)

<p align='right' style="float: right;"><i>Page 35 (54)</i></p>

## Functions

- o:foo(x) is just another way to write o.foo(o, x)

<p align='right' style="float: right;"><i>Page 67 (86)</i></p>

## Errors

<p align='right' style="float: right;"><i>Page 68 (87)</i></p>

- assert function checks whether its first argument is not false and simply returns this argument
- an exception that is easily avoided should raise an error; otherwise, it should return an error code

<p align='right' style="float: right;"><i>Page 70 (89)</i></p>

## Error Messages and Tracebacks

<p align='right' style="float: right;"><i>Page 71 (90)</i></p>

- error function has an additional second parameter, which gives the level where it should report the error
- xpcall function
- function to be called, it receives a second argument, an error handler function
- calls this error handler before the stack unwinds
- debug.debug, which gives you a Lua prompt

<p align='right' style="float: right;"><i>Page 72 (91)</i></p>

- debug.traceback

<p align='right' style="float: right;"><i>Page 73 (92)</i></p>

## Coroutines

- are collaborative: at any given time, a program with coroutines is running only one
- coroutines suspends its execution only when it explicitly requests to be suspended

<p align='right' style="float: right;"><i>Page 74 (93)</i></p>

- coroutine.status
- coroutine.resume
- yield function, which allows a running coroutine to suspend its own execution
- coroutine.yield

<p align='right' style="float: right;"><i>Page 109 (128)</i></p>

## Serialization

<p align='right' style="float: right;"><i>Page 110 (129)</i></p>

- quote a string in a secure way is with the option “%q”

<p align='right' style="float: right;"><i>Page 117 (136)</i></p>

## Metatables and Metamethods

- change the behavior of a value when confronted with an undefined operation
- use setmetatable to set or change the metatable of any table

<p align='right' style="float: right;"><i>Page 118 (137)</i></p>

- group of related tables may share a common metatable
- describes their common behavior
- table can be its own metatable

## Arithmetic Metamethods

<p align='right' style="float: right;"><i>Page 119 (138)</i></p>

- mt.__add = Set.union

<p align='right' style="float: right;"><i>Page 120 (139)</i></p>

- mt.__mul = Set.intersection
- each arithmetic operator there is a corresponding field name in a meta-table
- __add and __mul
- __sub (for subtraction), __div (for di-vision)
- __unm (for negation), __mod (for modulo), and __pow (for exponentiation).
- __concat, to describe a behavior for the concatena-tion operator
- first value has a metatable with an __add field, Lua uses this field as the metamethod
- otherwise, if the second value has a metatable with an __add field, Lua uses this field
- __eq (equal to), __lt (less than), and __le (less than or equal to)
- translates a ~= b to not (a == b), a > b to b < a, and a >= b to b <= a

## Relational Metamethods

<p align='right' style="float: right;"><i>Page 122 (141)</i></p>

- value has a __tostring metamethod.
- mt.__metatable = "not your business"

## Table-Access Metamethods

<p align='right' style="float: right;"><i>Page 123 (142)</i></p>

- access an absent field in a table
- look for an __index metamethod
- will provide the result
- Window.mt.__index = function (table, key) return Window.prototype[key] end
- _index metamethod for inheritance is so common that Lua provides a shortcut
- Window.mt.__index = Window.prototype

<p align='right' style="float: right;"><i>Page 124 (143)</i></p>

- rawget(t, i) does a raw access to table t, that is, a primitive access without considering metatables
- __newindex metamethod does for table updates what __index does for table accesses
- interpreter calls it instead of making the assignment
- if the metamethod is a table, the interpreter does the assignment in this table, instead of in the original one
- bypass the metamethod: the call rawset(t, k, v)

## Tables with default values

- function setDefault (t, d) local mt = {__index = function () return d end} setmetatable(t, mt) end

<p align='right' style="float: right;"><i>Page 125 (144)</i></p>

- allow the use of a single metatable for tables with different default values
- store the default value of each table in the table itself, using an exclusive field
- local mt = {__index = function (t) return t.___ end}

## Tracking table accesses

- create a proxy for the real table
- proxy is an empty table, with proper __index and __newindex metamethods
- track all accesses and redirect them to the original table

<p align='right' style="float: right;"><i>Page 129 (148)</i></p>

## The Environment

- stores the environment itself in a global variable _G

<p align='right' style="float: right;"><i>Page 130 (149)</i></p>

- value = _G[varname]

<p align='right' style="float: right;"><i>Page 131 (150)</i></p>

- can use metatables to change its behavior when accessing global variables
- __newindex = function (_, n) error("attempt to write to undeclared variable " .. n, 2) end
- __index = function (_, n) error("attempt to read undeclared variable " .. n, 2) end
- function declare (name, initval) rawset(_G, name, initval or false) end

<p align='right' style="float: right;"><i>Page 132 (151)</i></p>

- debug.getinfo(2, "S")
- tells whether the function that called the metamethod is a main chunk, a regular Lua function, or a C function
- Lua distribution comes with a module strict.lua that implements a global-variable check
- use it when developing Lua code

<p align='right' style="float: right;"><i>Page 133 (152)</i></p>

- change the environment of a function with the setfenv function
- give a number, meaning the active function at that given stack level
- handy to write auxiliary functions that change the environment of their caller

<p align='right' style="float: right;"><i>Page 134 (153)</i></p>

- populate it with some useful values, such as the old environment
- setmetatable(newgt, {__index = _G})
- new environment inherits both print and a from the old one

<p align='right' style="float: right;"><i>Page 137 (156)</i></p>

## Modules and Packages

- module is a library that can be loaded through require
- defines one single global name containing a table
- require to return this table

<p align='right' style="float: right;"><i>Page 138 (157)</i></p>

- good programming practice always to require the modules you need
- even if you know that they would be already loaded
- may exclude the stan-dard libraries from this rule, because they are pre-loaded in Lua

<p align='right' style="float: right;"><i>Page 139 (158)</i></p>

- force require into loading the same library twice
- erase the li-brary entry from package.loaded

<p align='right' style="float: right;"><i>Page 143 (162)</i></p>

## Using Environments

- _G[modname] = M package.loaded[modname] = M
- setmetatable(M, {__index = _G}) setfenv(1, M)

<p align='right' style="float: right;"><i>Page 145 (164)</i></p>

- adding the statement

<p align='right' style="float: right;"><i>Page 149 (168)</i></p>

## Object-Oriented Programming

<p align='right' style="float: right;"><i>Page 150 (169)</i></p>

- a:withdraw(100.00)
- effect of the colon is to add an extra hidden parameter in a method definition and to add an extra argument in a method call

<p align='right' style="float: right;"><i>Page 151 (170)</i></p>

## Classes

- classes and prototypes work as a place to put behavior to be shared by several objects
- make b a prototype for a
- setmetatable(a, {__index = b})
- function Account:new (o)
- o = o or {}
- setmetatable(o, self)
- self.__index = self
- return o

<p align='right' style="float: right;"><i>Page 152 (171)</i></p>

## Inheritance

<p align='right' style="float: right;"><i>Page 153 (172)</i></p>

- SpecialAccount = Account:new()
- s = SpecialAccount:new{limit=1000.00}

<p align='right' style="float: right;"><i>Page 156 (175)</i></p>

## Privacy

<p align='right' style="float: right;"><i>Page 161 (180)</i></p>

## Weak Tables

<p align='right' style="float: right;"><i>Page 162 (181)</i></p>

- tell Lua that a reference should not prevent the reclamation of an object
- weak reference is a reference to an object that is not considered by the garbage collector
- weak table is a table whose entries are weak
- three kinds of weak tables
- tables with weak keys, tables with weak values, and fully weak tables
- given by the field __mode of its metatable
- contains the letter ‘k', the keys in the table are weak
- contains the letter ‘v', the values in the table are weak

<p align='right' style="float: right;"><i>Page 163 (182)</i></p>

- strings are values, not objects
- like a number or a boolean, a string is not removed from weak tables

<p align='right' style="float: right;"><i>Page 205 (224)</i></p>

## Debug Library

- offers all the primitives that you need for writing your own debugger
- two kinds of functions: introspective functions and hooks
- debug.getinfo(foo) for some function foo

<p align='right' style="float: right;"><i>Page 206 (225)</i></p>

- debug.getinfo(n) for some number n, you get data about the function active at that stack level

<p align='right' style="float: right;"><i>Page 207 (226)</i></p>

- inspect the local variables of any active function with debug.getlocal

<p align='right' style="float: right;"><i>Page 208 (227)</i></p>

- access the non-local variables used by a Lua function, with getupvalue

<p align='right' style="float: right;"><i>Page 210 (229)</i></p>

- register a hook, we call debug.sethook
- first argument is the hook function
- second argument is a string that describes the events we want to monitor
- optional third argument is a number that describes at what frequency we want to get count events
- monitor the call, return, and line events, we add their first letters (‘c', ‘r', or ‘l')

<p align='right' style="float: right;"><i>Page 211 (230)</i></p>

## Profiles

- run the program with this hook
- % lua profiler main-prog

<p align='right' style="float: right;"><i>Page 212 (231)</i></p>

- debug.sethook(hook, "c") -- turn on the hook for calls
- debug.sethook() -- turn off the hook
