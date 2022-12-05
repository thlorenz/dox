---
file:    Programming Rust.pdf
date:    Mon Nov 28 13:36:09 2022
created with: https://github.com/thlorenz/pdf-annotations-converter
---

# Programming Rust.pdf

<p align='right' style="float: right;"><i>Page 97</i></p>

## Arrays, Vectors, and Slices

- `[T; N]` represents an array of N values, each of type T
- array's size is a constant determined at compile time
- Vec<T>, called a vector of Ts, is a dynamically allocated, growable sequence of values of type T
- `&[T]` and `&mut [T]`, called a shared slice of Ts and mutable slice of Ts
- pointer to its first element, together with a count of the number of elements you can access

<p align='right' style="float: right;"><i>Page 101</i></p>

- `Vec::with_capacity` to create a vector with a buffer large enough

<p align='right' style="float: right;"><i>Page 105</i></p>

## Slices

- always passed by reference
- fat pointer: a two-word value comprising a pointer to the slice's first element, and the number of elements in the slice
- reference to a slice is a non-owning pointer to several values

<p align='right' style="float: right;"><i>Page 106</i></p>

- slice references a good choice when you want to write a function that operates on any homogeneous data series
- stored in an array, vector, stack, or heap
- `fn print(n: &[f64])`
- `print(&v[0..2])`
- `print(&a[2..])`

<p align='right' style="float: right;"><i>Page 210</i></p>

## if let

- `if let pattern = expr`
- `if let Some(cookie) = request.session_cookie {`
- `let` expression is shorthand for a match with just one pattern

<p align='right' style="float: right;"><i>Page 211</i></p>

## Loops

- `while condition {`
- `while let pattern = expr {`
- `for pattern in collection {`

<p align='right' style="float: right;"><i>Page 212</i></p>

- `..` operator produces a range, a simple struct with two fields: start and end
- loop over a reference to the collection
- `for rs in &strings`
- `println!("String {:?} is at address {:p}.", *rs, rs)`
- `for rs in &mut strings`

<p align='right' style="float: right;"><i>Page 213</i></p>

- loop can be labeled with a lifetime
- `'search:` is a label for the outer for loop. Thus `break 'search` exits that loop
- Labels can also be used with continue

<p align='right' style="float: right;"><i>Page 214</i></p>

## return Expressions

- `return` can abandon work in progress
- exit the enclosing function

<p align='right' style="float: right;"><i>Page 216</i></p>

- Expressions that don't finish normally are assigned the special type !
- `fn exit(code: i32) -> !`
- `!` means that `exit()` never returns. It's a divergent function

<p align='right' style="float: right;"><i>Page 217</i></p>

## Function and Method Calls

- `player.location()`, player might be a `Player`, a reference of type `&Player`, or a smart pointer of type `Box<Player>` or `Rc<Player>`
- `.` operator automatically _dereferences_ player or borrows a reference to it as needed

<p align='right' style="float: right;"><i>Page 218</i></p>

- syntax for generic types, `Vec<T>`, does not work
- writing `::<T>` instead of `<T>`
- `Vec::<i32>::with_capacity(1000)`
- `(0 .. n).collect::<Vec<i32>>()`
- often possible to omit the type parameters and let Rust infer them

<p align='right' style="float: right;"><i>Page 219</i></p>

## Fields and Elements

- Square brackets access the elements of an array, a slice, or a vector
- value to the left of the brackets is automatically dereferenced
- called lvalues, because they can appear on the left side of an assignment

<p align='right' style="float: right;"><i>Page 220</i></p>

- `a .. // RangeFrom { start: a }`
- `.. b // RangeTo { end: b }`
- `a .. b // Range { start: a, end: b }`
- ranges are half-open
- include the start value, if any, but not the end value

<p align='right' style="float: right;"><i>Page 221</i></p>

## Reference Operators

- Rust automatically follows references when you use the `.` operator
- `*` operator is necessary only when we want to read or write the entire value

<p align='right' style="float: right;"><i>Page 225</i></p>

## Type Casts

- types `bool, char`, or of a C-like enum type, may be cast to any integer

<p align='right' style="float: right;"><i>Page 226</i></p>

- `u8` may be cast to type `char`, since all integers from 0 to 255 are valid Unicode code points
- `&String` auto-convert to type `&str`
- `&Vec<i32>` auto-convert to `&[i32]`
- `&Box<Chessboard>` auto-convert to `&Chessboard`
- types that implement the `Deref` built-in trait

<p align='right' style="float: right;"><i>Page 227</i></p>

## Closures

- argument list, given between vertical bars, followed by an expression
- `let is_even = |x| x % 2 == 0`
- `let is_even = |x: u64| -> bool { x % 2 == 0 }`

<p align='right' style="float: right;"><i>Page 233</i></p>

## Panic

- `panic!()` accepts optional println!()-style arguments
- unwind the stack when a panic happens

<p align='right' style="float: right;"><i>Page 234</i></p>

- set the `RUST_BACKTRACE` environment variable, as the messages suggests, Rust will also dump
  the stack
- stack is unwound. This is a lot like C++ exception handling
- Once the current function call is cleaned up, we move on to its caller

<p align='right' style="float: right;"><i>Page 235</i></p>

- thread exits. If the panicking thread was the main thread, then the whole process exits
- behavior is well-defined; it just shouldn't be happening
- Panic is per thread
- can use threads and `catch_unwind()` to handle panic

<p align='right' style="float: right;"><i>Page 236</i></p>

- compile with `-C panic=abort`, the first panic in your program immediately aborts the process

<p align='right' style="float: right;"><i>Page 237</i></p>

## Result

<p align='right' style="float: right;"><i>Page 238</i></p>

- `result.is_ok()` and `result.is_err()`
- `result.ok()` returns the success value, if any, as an `Option<T>`
- `result.err()` returns the error value, if any, as an `Option<E>`
- `result.unwrap_or(fallback)`

<p align='right' style="float: right;"><i>Page 239</i></p>

- `result.unwrap_or_else(fallback_fn)`
- `result.expect(message)` is the same as `.unwrap()`, but lets you provide a message
- `result.as_ref()` converts a `Result<T, E>` to a `Result<&T, &E>`
- `result.as_mut()` is the same, but borrows a mutable reference
  - to access data inside a result without destroying it

<p align='right' style="float: right;"><i>Page 246</i></p>

## Working with Multiple Error Types

<p align='right' style="float: right;"><i>Page 247</i></p>

- all of the standard library error types can be converted to the type
  `Box<std::error::Error>`kj:w
- `type GenError = Box<std::error::Error>`
- `type GenResult<T> = Result<T, GenError>`
- handle one particular kind of error
- use the generic method `error.downcast_ref::<ErrorType>()`
  - if let Some(mse) = err.downcast_ref::<MissingSemicolonError>()

<p align='right' style="float: right;"><i>Page 254</i></p>

## Custom Error Type

- `pub struct JsonError`
- `return Err(JsonError)`
- `impl fmt::Display for JsonError`
- `impl std::error::Error for JsonError`

<p align='right' style="float: right;"><i>Page 262</i></p>

## Build Profiles

- configuration settings you can put in your `Cargo.toml` file that affect the rustc command
  lines that cargo generates
- `cargo build [profile.debug]`
- `cargo build --release [profile.release]`
- `cargo test [profile.test]`
- get the best data from a profiler
- need both optimizations (usually enabled only in release builds) and debug symbols
- `[profile.release] debug = true`

<p align='right' style="float: right;"><i>Page 263</i></p>

## Modules

- Modules are Rust's namespaces
- crates are about code sharing between projects
- modules are about code organization within a project

<p align='right' style="float: right;"><i>Page 265</i></p>

- When Rust sees `mod spores;`, it checks for both `spores.rs` and `spores/mod.rs`

<p align='right' style="float: right;"><i>Page 267</i></p>

## Paths and Imports

- `::std::mem::swap`, is an absolute path, because it starts with a double colon
- import features into the modules where they're used
  - `use std::mem;`
- causes the name `mem` to be a local alias for `::std::mem`
- paths in use declarations are automatically absolute paths
- import types, traits, and modules (like `std::mem`)
- then use relative paths to access the functions, constants, and other members within

<p align='right' style="float: right;"><i>Page 268</i></p>

- super has a special meaning in imports: it's an alias for the parent module

<p align='right' style="float: right;"><i>Page 269</i></p>

- `// import names from an enum`
- `use self::AminoAcid::*;`
- submodules can access private items in their parent modules
- import each one by name. `use super::*;` only imports items that are marked `pub`
- analogy between modules and the files and directories of a Unix filesystem
- use keyword creates aliases, just as the ln command creates links
- `self` and `super` are like the `.` and `..` special directories
- extern crate grafts another crate's root module into your project. It is a lot like mounting
  a filesystem

<p align='right' style="float: right;"><i>Page 280</i></p>

## Attributes

- disable warnings by adding an `#[allow]` attribute
- Conditional compilation is another feature that's written using an attribute, the `#[cfg]` attribute

<p align='right' style="float: right;"><i>Page 281</i></p>

- mark one with `#[cfg(X)]` and the other with `#[cfg(not(X))]`
- attach an attribute to a whole crate, add it at the top of the `main.rs` or `lib.rs` file
- write `#!` instead of `#`

<p align='right' style="float: right;"><i>Page 282</i></p>

- `#![allow(non_camel_case_types)]`
- `#![feature]` attribute is used to turn on unstable features of the Rust language
- `#![feature(i128_type)]`

<p align='right' style="float: right;"><i>Page 283</i></p>

## Tests and Documentation

<p align='right' style="float: right;"><i>Page 284</i></p>

- test error cases, add the `#[should_panic]` attribute
- `#[should_panic(expected="divide by zero")]`

<p align='right' style="float: right;"><i>Page 286</i></p>

- Integration tests are `.rs` files that live in a `tests` directory alongside your project's
  src directory
- test the crate's public API
- run only the integration tests in a particular file
- `cargo test --test unfurl`

<p align='right' style="float: right;"><i>Page 289</i></p>

- comments that start with three slashes, it treats them as a `#[doc]` attribute
- comments starting with `//!` are treated as `#![doc]` attributes, and are attached to the
  enclosing feature, typically a module
- comment is treated as Markdown

<p align='right' style="float: right;"><i>Page 293</i></p>

- hide a line of a code sample, put a `#` followed by a space
- Rustdoc therefore treats any code block containing the exact string fn main as a complete program
- uses Rust to compile your example, but stop short of actually running it


<p align='right' style="float: right;"><i>Page 294</i></p>

- `/// ```no_run`
- code isn't even expected to compile, use `ignore` instead of no_run
- code block isn't Rust code at all, use the name of the language, like `c++` or `sh`, or
  `text`
- disables code highlighting as well as doc-testing

<p align='right' style="float: right;"><i>Page 295</i></p>

## Specifying Dependencies

- specifying a Git repository URL and revision
- `image = { git = "https://github.com/Piston/image.git", rev = "528f19c" }`
- can specify the particular rev, tag, or branch to use
- specify a directory that contains the crate's source code
- `image = { path = "vendor/image" }`

<p align='right' style="float: right;"><i>Page 297</i></p>

## Versions

- compatibility rules are adapted from Semantic Versioning
- starts with `0.0` is so raw that Cargo never assumes it's compatible with any other version
- starts with `0.x`, where `x` is nonzero, is considered compatible with other point releases
  in the `0.x` series
- once a project reaches `1.0`, only new major versions break compatibility
- specify an exact version or range of versions by using operators
- `"=0.10.0"` Use only the exact version `0.10.0`

<p align='right' style="float: right;"><i>Page 298</i></p>

- wildcard `*.` This tells Cargo that any version will do

<p align='right' style="float: right;"><i>Page 299</i></p>

- `Cargo.lock` file that records the exact version of every crate it used
- upgrades to newer versions only when you tell it to
- manually bumping up the version number in your `Cargo.toml` file, or by running cargo update

<p align='right' style="float: right;"><i>Page 300</i></p>

- project is an executable, you should commit `Cargo.lock` to version control
- project is an ordinary Rust library, don't bother committing `Cargo.lock`

<p align='right' style="float: right;"><i>Page 301</i></p>

## Publishing Crates

- `cargo package --list` to see which files are included

<p align='right' style="float: right;"><i>Page 302</i></p>

- can specify both a path, which takes precedence for your own local builds, and a version for all other users
- image = { path = "vendor/image", version = "0.6.1" }

<p align='right' style="float: right;"><i>Page 304</i></p>

## Workspaces

- many crates. They live side by side in a single source repository
- can't share any compiled code. this is wasteful
- workspace, a collection of crates that share a common build directory and `Cargo.lock` file
- create a `Cargo.toml` file in your repository's root directory
- `[workspace] members = ["fern_sim", "fern_img", "fern_video"]`

<p align='right' style="float: right;"><i>Page 305</i></p>

- `cargo build --all` builds all crates in the current workspace
- `cargo test` and `cargo doc` accept the `--all` option

<p align='right' style="float: right;"><i>Page 308</i></p>

## Named-Field Structs

<p align='right' style="float: right;"><i>Page 309</i></p>

- a struct expression, if the named fields are followed by `.. EXPR`, then any fields not
  mentioned take their values from `EXPR`
- must be another value of the same `struct` type

<p align='right' style="float: right;"><i>Page 310</i></p>

- `Broom { name: broom1.name.clone(), .. broom1 }`

<p align='right' style="float: right;"><i>Page 312</i></p>

## Tuple-Like Structs

- `struct Bounds(usize, usize)`

<p align='right' style="float: right;"><i>Page 314</i></p>

## Unit-Like Structs

- `struct Onesuch`
- occupies no memory, much like the unit type `()`
- type of which there is only a single value

<p align='right' style="float: right;"><i>Page 316</i></p>

- lay out structures in a way compatible with `C` and `C++`, using the `#[repr(C)]` attribute

<p align='right' style="float: right;"><i>Page 317</i></p>

## Defining Methods with impl

<p align='right' style="float: right;"><i>Page 318</i></p>

- collection of `fn` definitions, each of which becomes a method on the struct type
- also known as associated functions
- `self`, &`self` or `&mut self`

<p align='right' style="float: right;"><i>Page 320</i></p>

- methods that don't take self as an argument
- associated with the struct type itself, not with any specific value of the type
- static methods. They're often used to provide constructor functions

<p align='right' style="float: right;"><i>Page 322</i></p>

## Generic Structs

- `pub struct Queue<T>`
- `impl<T> Queue<T>`

<p align='right' style="float: right;"><i>Page 323</i></p>

- for any type `T`, here are some methods available on `Queue<T>`

<p align='right' style="float: right;"><i>Page 325</i></p>

- given any specific lifetime `'elt`, you can make an `Extrema<'elt>` that holds references with
  that lifetime

<p align='right' style="float: right;"><i>Page 327</i></p>

## Deriving Common Traits for Struct Types

- Rust can automatically implement them for you
- `#[derive(Copy, Clone, Debug, PartialEq)]`

<p align='right' style="float: right;"><i>Page 329</i></p>

## Interior Mutability

- mutable data (a File) inside an otherwise immutable value

<p align='right' style="float: right;"><i>Page 330</i></p>

- `Cell<T>` is a struct that contains a single private value of type `T`
- get and set the field even if you don't have mut access to the `Cell`
- `cell.get()` returns a copy of the value
- `cell.set(value)` stores the given value in the cell, dropping the previously stored value
- safe way of bending the rules on immutability

<p align='right' style="float: right;"><i>Page 331</i></p>

- works only if `T` implements the `Copy` trait
- `RefCell` supports _borrowing_ references to its `T` value
- `ref_cell.borrow()` returns a `Ref<T>,` which is essentially just a shared reference
- panics if the value is already mutably borrowed
- `ref_cell.borrow_mut()` returns a `RefMut<T>`, essentially a mutable reference
- panics if the value is already borrowed

<p align='right' style="float: right;"><i>Page 332</i></p>

- Rust checks at compile time to ensure that you're using the reference safely
- `RefCell` enforces the same rule using runtime checks
- `log_file: RefCell<File>`
- `let mut file = self.log_file.borrow_mut(`
- cells—and any types that contain them—are not thread-safe

<p align='right' style="float: right;"><i>Page 335</i></p>

## Enums

- `use std::cmp::Ordering::*`

<p align='right' style="float: right;"><i>Page 336</i></p>

- considered better style not to import them except when it makes your code much more readable
- import the constructors of an enum declared in the current module
- `use self::Pet::*`
- tell Rust which integers to use for discriminants
- `Ok = 200`
- Rust stores C-style enums using the smallest built-in integer type that can accommodate them
- Casting a C-style enum to an integer is allowed

<p align='right' style="float: right;"><i>Page 337</i></p>

- Enums can have methods, just like structs

<p align='right' style="float: right;"><i>Page 339</i></p>

## Enums with Data

- `InThePast(TimeUnit, u32)`
- can also have struct variants
- `enum Shape { Sphere { center: Point3d, radius: f32 }`
- Tuple variants look and function just like tuple structs

<p align='right' style="float: right;"><i>Page 341</i></p>

- enums with data are stored as a small integer tag
- plus enough memory to hold all the fields of the largest variant

<p align='right' style="float: right;"><i>Page 342</i></p>

- `Box<HashMap>` is a single word: it's just a pointer to heap-allocated data
- compact by boxing more fields

<p align='right' style="float: right;"><i>Page 349</i></p>

- only way to access the data in an enum is the safe way: using patterns

<p align='right' style="float: right;"><i>Page 350</i></p>

## Patterns

- Expressions produce values; patterns consume values

<p align='right' style="float: right;"><i>Page 351</i></p>

- `RoughTime::InTheFuture(unit, 1)`
- matches only if the count field is exactly `1`

<p align='right' style="float: right;"><i>Page 352</i></p>

## Patterns

- Literal: `100`, `"name"`
- Range: `0 ... 100`, `'a' ... 'k'`
- Variable name `mut count` Like `_` but moves
- `ref variable`, `ref field`, `ref mut field`, _borrows_ a reference
- binding with subpattern val `@ 0 ... 99 ref circle`, `@ Shape::Circle { .. }` matches the
  pattern to the right of `@`
- Reference `&value`, `&(k, v)` matches only reference values

<p align='right' style="float: right;"><i>Page 353</i></p>

- Guard expression `x if x * x <= r2` in match only (not valid in `let`)

<p align='right' style="float: right;"><i>Page 357</i></p>

## Tuple and Struct Patterns

- `Point { x: 0, y: height } =>`

<p align='right' style="float: right;"><i>Page 358</i></p>

- `Some(Account { name, language, .. }) =>`

<p align='right' style="float: right;"><i>Page 359</i></p>

- `Account { ref name, ref language, .. } =>`
- account is only being borrowed, not consumed

<p align='right' style="float: right;"><i>Page 360</i></p>

- `Ok(ref mut line) =>`
- pattern starting with `&` matches a reference
- `&Point3d { x, y, z } =>`
- patterns and expressions are natural opposites
- expression `(x, y)` makes two values into a new tuple, but the pattern `(x, y)` does the opposite
- In an expression, `&` creates a reference. In a pattern, `&` matches a reference

<p align='right' style="float: right;"><i>Page 361</i></p>

- `match &Point3d { x, y, z }`, the variables `x`, `y`, and `z` receive copies of the coordinates
- works because those fields are copyable
- `Some(&Car { engine, .. }) => // error: can't move out of borrow`
- `Some(&Car { ref engine, .. }) => // ok, engine is a reference`
- `Option<&char>`
- use an `&` pattern to get the pointed-to character
- `Some(&c) =>`

<p align='right' style="float: right;"><i>Page 362</i></p>

- Ranges in patterns are inclusive

<p align='right' style="float: right;"><i>Page 363</i></p>

## Pattern Guards

- `if` keyword to add a guard to a match arm
- `Some(point) if self.distance_to(point) < 10 =>`
- If a pattern moves any values, you can't put a guard on it
- change the pattern to borrow point instead of moving it: `Some(ref point)`

<p align='right' style="float: right;"><i>Page 364</i></p>

## `@` patterns

- `x @` pattern matches exactly like the given pattern
- creates a single variable `x` and moves or copies the whole value into it
- `rect @ Shape::Rect(..) => optimized_paint(&rect)`
- `Some(digit @ '0' ... '9') => read_number(digit, chars)`

<p align='right' style="float: right;"><i>Page 365</i></p>

- patterns that are guaranteed to match
- irrefutable patterns
- refutable pattern is one that might not match

<p align='right' style="float: right;"><i>Page 367</i></p>

- `*self = BinaryTree::NonEmpty(Box::new(TreeNode {`

<p align='right' style="float: right;"><i>Page 371</i></p>

## Traits and Generics

- Rust supports polymorphism with two related features: traits and generics
- approach inspired by Haskell's typeclasses

<p align='right' style="float: right;"><i>Page 373</i></p>

- compiler generates custom machine code for each type `T` that you actually use

<p align='right' style="float: right;"><i>Page 374</i></p>

- trait itself must be in scope, otherwise, all its methods are hidden

<p align='right' style="float: right;"><i>Page 375</i></p>

- prelude is mostly a carefully chosen selection of traits

<p align='right' style="float: right;"><i>Page 376</i></p>

## Trait Objects

- reference to a trait type, like writer, is called a trait object
- Rust usually doesn't know the type of the referent at compile time
- trait object includes a little extra information about the referent's type

<p align='right' style="float: right;"><i>Page 378</i></p>

- In memory, a trait object is a fat pointer
- pointer to the value, plus a pointer to a table representing that value's type

<p align='right' style="float: right;"><i>Page 380</i></p>

## Generic Functions

- `fn say_hello<W: Write>(out: &mut W) `

<p align='right' style="float: right;"><i>Page 381</i></p>

- `fn top_ten<T: Debug + Hash + Eq>(values: &Vec<T>) { ... }`

<p align='right' style="float: right;"><i>Page 382</i></p>

- `fn run_query<M, R>`
- `where M: Mapper + Serialize, R: Reducer + Serialize`

<p align='right' style="float: right;"><i>Page 383</i></p>

- `fn nearest<'t, 'c, P>(target: &'t P, candidates: &'c [P]) -> &'c P`

<p align='right' style="float: right;"><i>Page 385</i></p>

- Trait objects are the right choice whenever you need a collection of values of mixed types,
  all together
- `Box<Vegetable>` can own any type of vegetable, but the box itself has a constant size

<p align='right' style="float: right;"><i>Page 386</i></p>

- for a generic function, it knows which types it's working with

<p align='right' style="float: right;"><i>Page 387</i></p>

- Rust never knows what type of value a trait object points to until run time

<p align='right' style="float: right;"><i>Page 392</i></p>

## Traits and Other People's Types

- implement any trait on any type, as long as either the trait or the type is introduced in the
  current crate
- add a method to an existing type, char. This is called an extension trait
- use a generic impl block to add an extension trait to a whole family of types at once
- `impl<W: Write> WriteHtml for W {`

<p align='right' style="float: right;"><i>Page 397</i></p>

## Subtraits

- extension of another trait
- `trait Creature: Visible`
- type that implements `Creature` must also implement the `Visible` trait

<p align='right' style="float: right;"><i>Page 398</i></p>

- Rust traits can include static methods and constructors
- `fn new() -> Self`

<p align='right' style="float: right;"><i>Page 399</i></p>

- trait objects don't support static methods
- must change the trait, adding the bound `where Self: Sized` to each static method
- trait objects are excused from supporting this method

<p align='right' style="float: right;"><i>Page 400</i></p>

## Fully Qualified Method Calls

- `ToString::to_string("hello")`
- `<str as ToString>::to_string("hello")`

<p align='right' style="float: right;"><i>Page 401</i></p>

- `.map(<str as ToString>::to_string)`

<p align='right' style="float: right;"><i>Page 403</i></p>

## Associated Types

- `pub trait Iterator { type Item;`
- `type Item;, is an associated type`
- `impl Iterator for Args { type Item = String;`

<p align='right' style="float: right;"><i>Page 404</i></p>

- Generic code can use associated types
- `fn collect_into_vector<I: Iterator>(iter: I) -> Vec<I::Item>`

<p align='right' style="float: right;"><i>Page 405</i></p>

- `fn dump<I>(iter: I) where I: Iterator, I::Item: Debug`
- `fn dump<I>(iter: I) where I: Iterator<Item=String>`
- `Iterator<Item=String>` is a subset of Iterator
- syntax can be used anywhere the name of a trait can be used, including trait object types

<p align='right' style="float: right;"><i>Page 408</i></p>

## Generic Traits

- `pub trait Mul<RHS=Self>`
- syntax `RHS=Self` means that `RHS` defaults to `Self`
- `lhs * rhs` is shorthand for `Mul::mul(lhs, rhs)`

<p align='right' style="float: right;"><i>Page 410</i></p>

## Buddy Traits

- buddy traits are simply traits that are designed to work together

<p align='right' style="float: right;"><i>Page 411</i></p>

- `pub trait Rand: Sized { fn rand<R: Rng>(rng: &mut R) -> Self;`
- `random()` is nothing but a thin wrapper that passes a globally allocated `Rng` to this `rand` method
- `pub fn random<T: Rand>() -> T { T::rand(&mut global_rng()) }`
- traits that use other traits as bounds, the way `Rand::rand()` uses `Rng`

<p align='right' style="float: right;"><i>Page 413</i></p>

## Reverse-Engineering Bounds

<p align='right' style="float: right;"><i>Page 415</i></p>

- `fn dot<N>(v1: &[N], v2: &[N]) -> N where N: Add<Output=N> + Mul<Output=N> + Default + Copy`
- reverse-engineering the bounds on `N,` using the compiler to guide

<p align='right' style="float: right;"><i>Page 418</i></p>

## Operator Overloading

### traits for operator overloading

<p align='right' style="float: right;"><i>Page 421</i></p>

- `a + b` is actually shorthand for `a.add(b)`
- `use std::ops::Add`
- `10.add(20)`
- `trait Add<RHS=Self> { type Output; fn add(self, rhs: RHS) -> Self::Output; }`

<p align='right' style="float: right;"><i>Page 422</i></p>

- `impl<T> Add for Complex<T> where T: Add<Output=T>`
- restrict `T` to types that can be added to themselves, yielding another `T` value

<p align='right' style="float: right;"><i>Page 430</i></p>

### Equality Tests

- `==` and `!=,` are shorthand for calls to the `std::cmp::PartialEq` trait's `eq` and `ne` methods
- `trait PartialEq<Rhs: ?Sized = Self> { fn eq(&self, other: &Rhs) -> bool; fn ne(&self, other: &Rhs) -> bool { !self.eq(other) } }`

<p align='right' style="float: right;"><i>Page 432</i></p>

- `assert_eq!(0.0/0.0 == 0.0/0.0, false)`

<p align='right' style="float: right;"><i>Page 433</i></p>

- partial equivalence relation, so Rust uses the name `PartialEq` for the `==` operator's
  built-in trait
- almost every type that implements `PartialEq` should implement `Eq` as well

<p align='right' style="float: right;"><i>Page 435</i></p>

- `PartialOrd<Rhs> extends PartialEq<Rhs>`

<p align='right' style="float: right;"><i>Page 438</i></p>

### Index and IndexMut

- specify how an indexing expression like a[i] works on your type
- `a[i]` is normally shorthand for `*a.index(i)`
- if the expression is being assigned to or borrowed mutably, it's instead shorthand for
  `*a.index_mut(i)`

<p align='right' style="float: right;"><i>Page 445</i></p>

## Drop

- Dropping a value entails freeing whatever other values, heap storage, and system resources
  the value owns
- customize how Rust drops values of your type by implementing the `std::ops::Drop` trait
- analogous to a destructor in _C++_

<p align='right' style="float: right;"><i>Page 447</i></p>

- value may be moved from place to place, Rust drops it only once
- won't need to implement `std::ops::Drop` unless you're defining a type that owns resources
  Rust doesn't already know about

<p align='right' style="float: right;"><i>Page 448</i></p>

- if a type implements `Drop,` it cannot implement the `Copy` trait

<p align='right' style="float: right;"><i>Page 449</i></p>

## Sized

- sized type is one whose values all have the same size in memory
- `enum` always occupies enough space to hold its largest variant
- `Vec<T>` owns a heap-allocated buffer whose size can vary
- `Vec` value itself is a pointer to the buffer, its capacity, and its length, so `Vec<T>` is a
  sized type
- `string` slice type `str` (note, without an `&`) is unsized
- Array slice types like `[T]` (again, without an `&)` are unsized
- common kind of unsized type in Rust is the referent of a trait object
  - pointer to some value that implements a given trait

<p align='right' style="float: right;"><i>Page 450</i></p>

- Rust can't store unsized values in variables or pass them as arguments
- deal with them through pointers like `&str` or `Box<Write>`, which themselves are sized
- sized types implement the `std::marker::Sized` trait
- Rust implements it automatically for all types to which it applies
- use for `Sized` is as a bound for type variables: a bound like `T: Sized`
- must explicitly opt out, writing struct `S<T: ?Sized>`

<p align='right' style="float: right;"><i>Page 451</i></p>

- almost always means that the given type is only pointed to
- questionably sized: it might be `Sized,` or it might not
- struct type's last field (but only its last) may be unsized
- such a struct is itself unsized
- can't build an `RcBox<Display>` value directly
- create an ordinary, sized `RcBox` whose value type implements `Display,` like `RcBox<String>`
- convert a reference `&RcBox<String>` to a fat reference `&RcBox<Display>`

<p align='right' style="float: right;"><i>Page 452</i></p>

- happens implicitly when passing values to functions
- pass a `&RcBox<String>` to a function that expects an `&RcBox<Display>`

<p align='right' style="float: right;"><i>Page 453</i></p>

## Clone

- types that can make copies of themselves
- clone can be expensive, in both time and memory
- reference-counted pointer types like `Rc<T>` and `Arc<T>` are exceptions
- simply increments the reference count and hands you a new pointer
- `clone_from` method modifies self into a copy of source
- `s = t.clone();` must clone `t,` drop the old value of `s`, and then move the cloned value into `s`
- `s` has enough capacity to hold `t`'s contents, no allocation or deallocation is necessary
- In generic code, you should use `clone_from` whenever possible

<p align='right' style="float: right;"><i>Page 455</i></p>

## Copy

- `std::marker::Copy` marker trait
- `trait Copy: Clone { }`
- Rust permits a type to implement `Copy` only if a shallow byte-for-byte copy is all it needs
- type that implements the `Drop` trait cannot be `Copy`

<p align='right' style="float: right;"><i>Page 456</i></p>

## Deref and DerefMut

- specify how dereferencing operators like `*` and `.` behave on your types
- `fn deref(&self) -> &Self::Target`
- `fn deref_mut(&mut self) -> &mut Self::Target;`
- `Target` should be something that `Self` contains, owns, or refers to
- `self` remains borrowed for as long as the returned reference lives
- if inserting a `deref` call would prevent a type mismatch, Rust inserts one for you
- deref coercions: one type is being _coerced_ into behaving as another

<p align='right' style="float: right;"><i>Page 457</i></p>

- `String implements Deref<Target=str>`
- `Vec<T> implements Deref<Target=[T]>`

<p align='right' style="float: right;"><i>Page 459</i></p>

- does not apply `deref` coercions to satisfy bounds on type variables
- can spell out the coercion using the as operator

<p align='right' style="float: right;"><i>Page 460</i></p>

## Default

- returns a fresh value of type `Self`
- `let (powers_of_two, impure): (HashSet<i32>, HashSet<i32>) = squares.iter().partition(|&n| n & (n-1) == 0)`
- partition isn't specific to HashSets

<p align='right' style="float: right;"><i>Page 461</i></p>

- implements `Default`, to produce an empty collection to start with, and `Extend<T>`, to add a
  `T` to the collection

<p align='right' style="float: right;"><i>Page 463</i></p>

## AsRef and AsMut

- type implements `AsRef<T>`, that means you can borrow a `&T` from it efficiently
- `trait AsRef<T: ?Sized> { fn as_ref(&self) -> &T; }`
- typically used to make functions more flexible in the argument types they accept
- `fn open<P: AsRef<Path>>(path: P) -> Result<File>`
- accepts anything it can borrow a `&Path` from—that is, anything that implements `AsRef<Path>`

<p align='right' style="float: right;"><i>Page 464</i></p>

- `if T: AsRef<U>`, then `&T: AsRef<U>` as well

<p align='right' style="float: right;"><i>Page 465</i></p>

- similar to `AsRef`
- type should implement `Borrow<T>` only when a `&T` hashes and compares the same way as the value
  it's borrowed from
- valuable in dealing with keys in hash tables and trees

<p align='right' style="float: right;"><i>Page 466</i></p>

- `fn get<Q: ?Sized>(&self, key: &Q) -> Option<&V> where K: Borrow<Q>, Q: Eq + Hash`
- allows you to pass either `&String` or `&str` as a key

<p align='right' style="float: right;"><i>Page 468</i></p>

## From and Into

- use `Into` to make your functions more flexible in the arguments they accept
- `where A: Into<Ipv4Addr>`

<p align='right' style="float: right;"><i>Page 469</i></p>

- `from` method serves as a generic constructor for producing an instance of a type from some
  other single value
- write them as implementations of `From<T>` for the appropriate types; you'll get the
  corresponding Into implementations for free
- conversion can reuse the original value's resources to construct the converted value

<p align='right' style="float: right;"><i>Page 470</i></p>

- `From` and `Into` conversions may allocate, copy, or otherwise process the value's contents

<p align='right' style="float: right;"><i>Page 471</i></p>

## ToOwned

- `clone`, which must return exactly `Self`
- `to_owned` can return anything you could borrow a `&Self` from

<p align='right' style="float: right;"><i>Page 472</i></p>

## Cow

- decide whether to borrow or own until the program is running; the `std::borrow::Cow` type (for
  _clone on write_) provides one way

<p align='right' style="float: right;"><i>Page 473</i></p>

- `Cow` helps describe and its callers put off allocation until the moment it becomes necessary

<p align='right' style="float: right;"><i>Page 474</i></p>

## Closures

<p align='right' style="float: right;"><i>Page 479</i></p>

- closure is subject to the rules about borrowing and lifetimes
- contains a reference to stat, Rust won't let it outlive stat

<p align='right' style="float: right;"><i>Page 481</i></p>

- tell Rust to move cities and stat into the closures that use them instead of borrowing references to them
- let key_fn = move |city: &City| -> i64 { -city.get_statistic(stat) }
- thread::spawn(move || {
- two ways for closures to get data from enclosing scopes: moves and borrowing

<p align='right' style="float: right;"><i>Page 483</i></p>

- fn value is the memory address of the function's machine code
- test_fn: fn(&City) -> bool

<p align='right' style="float: right;"><i>Page 484</i></p>

- closures do not have the same type as functions
- To support closures, we must change the type signature of this function
- test_fn: F) -> usize where F: Fn(&City) -> bool
- F implements the special trait Fn(&City) -> bool

<p align='right' style="float: right;"><i>Page 485</i></p>

- implemented by all functions and closures that take a single &City as an argument and return a Boolean value
- every closure you write has its own type, because a closure may contain data

<p align='right' style="float: right;"><i>Page 486</i></p>

- closures have none of these performance drawbacks
- Rust compiler knows the type of the closure you're calling, it can inline the code for that particular closure

<p align='right' style="float: right;"><i>Page 490</i></p>

- let f = || drop(my_str)
- this closure can't be called twice

<p align='right' style="float: right;"><i>Page 492</i></p>

- Closures that drop values, like f, are not allowed to have Fn
- implement a less powerful trait, FnOnce, the trait of closures that can be called once

<p align='right' style="float: right;"><i>Page 494</i></p>

- FnMut, the category of closures that write
- FnMut closures are called by mut reference

<p align='right' style="float: right;"><i>Page 495</i></p>

- Fn is the family of closures and functions that you can call multiple times without restriction. This highest category also includes all fn functions
- FnMut is the family of closures that can be called multiple times if the closure itself is declared mut
- FnOnce is the family of closures that can be called once, if the caller owns the closure
- Fn the most exclusive and most powerful category
- FnMut and FnOnce are broader categories

<p align='right' style="float: right;"><i>Page 497</i></p>

## Callbacks

<p align='right' style="float: right;"><i>Page 499</i></p>

- want to support a variety of types, we need to use boxes and trait objects
- type BoxedCallback = Box<Fn(&Request) -> Response>
- routes: HashMap<String, BoxedCallback>

<p align='right' style="float: right;"><i>Page 500</i></p>

- fn add_route<C>(&mut self, url: &str, callback: C) where C: Fn(&Request) -> Response + 'static
- 'static bound. Without it, the call to Box::new(callback) would be an error, because it's not safe to store a closure if it contains borrowed references to variables

<p align='right' style="float: right;"><i>Page 506</i></p>

## Iterator and IntoIterator Traits

- iterator is any value that implements the std::iter::Iterator trait
- trait Iterator { type Item; fn next(&mut self) -> Option<Self::Item>;
- next method either returns Some(v), where v is the iterator's next value
- returns None to indicate the end of the sequence
- into_iter method takes a value and returns an iterator over it
- trait IntoIterator where Self::IntoIter::Item == Self::Item { type Item; type IntoIter: Iterator; fn into_iter(self) -> Self::IntoIter;
- IntoIter is the type of the iterator value itself
- Item is the type of value it produces
- type that implements IntoIterator an iterable

<p align='right' style="float: right;"><i>Page 507</i></p>

- for loop is just shorthand for calls to IntoIterator and Iterator methods
- uses IntoIterator::into_iter to convert its operand &v into an iterator
- then calls Iterator::next repeatedly
- All iterators automatically implement IntoIterator, with an into_iter method that simply returns the iterator
- iterator is any type that implements Iterator
- iterable is any type that implements IntoIterator
- get an iterator over it by calling its into_iter method

<p align='right' style="float: right;"><i>Page 509</i></p>

## iter and iter_mut

- iterators over the type, producing a shared or mutable reference to each item

<p align='right' style="float: right;"><i>Page 510</i></p>

## IntoIterator Implementations

- shared reference to the collection, into_iter returns an iterator that produces shared references to its items
- (&favorites).into_iter() would return an iterator whose Item type is &String
- mutable reference to the collection, into_iter returns an iterator that produces mutable references to the items
- (&mut vector).into_iter() returns an iterator whose Item type is &mut String
- collection by value, into_iter returns an iterator that takes ownership of the collection and returns items by value
- original collection is consumed in the process

<p align='right' style="float: right;"><i>Page 511</i></p>

- loop applies IntoIterator::into_iter to its operand
- for element in &collection { ... }
- for element in &mut collection { ... }
- for element in collection { ... }
- Not every type provides all three implementations
- first two IntoIterator variants, for shared and mutable references, are equivalent to calling iter or iter_mut on the referent

<p align='right' style="float: right;"><i>Page 512</i></p>

- favorites.iter() is clearer than (&favorites).into_iter()
- iter and iter_mut are still valuable for their ergonomics
- use a bound like T: IntoIterator to restrict the type variable T to types that can be iterated over
- T: IntoIterator<Item=U> to further require the iteration to produce a particular type U
- iter and iter_mut, since they're not methods of any trait
- iterable types just happen to have methods by those names

<p align='right' style="float: right;"><i>Page 516</i></p>

## Iterator Adapters

- consume one iterator and build a new one with useful behaviors

<p align='right' style="float: right;"><i>Page 517</i></p>

- adapter lets you transform an iterator by applying a closure to its items

<p align='right' style="float: right;"><i>Page 518</i></p>

- `fn map<B, F>(self, f: F) -> some Iterator<Item=B> where Self: Sized, F: FnMut(Self::Item) -> B;`
- `fn filter<P>(self, predicate: P) -> some Iterator<Item=Self::Item> where Self: Sized, P: FnMut(&Self::Item) -> bool;`

<p align='right' style="float: right;"><i>Page 521</i></p>

## filter_map and flat_map

- same as map's signature, except that here the closure returns `Option<B>`
- When the closure returns None, the item is dropped from the iteration

<p align='right' style="float: right;"><i>Page 522</i></p>

- `flat_map` iterator produces the concatenation of the sequences the closure returns

<p align='right' style="float: right;"><i>Page 523</i></p>

- `countries.iter().flat_map(|country| &major_cities[country])`
- effect is that of a nested loop

<p align='right' style="float: right;"><i>Page 524</i></p>

## scan

- given a mutable value it can consult, and has the option of terminating the iteration early
- takes an initial state value, and then a closure that accepts a mutable reference to the
  state, and the next item from the underlying iterator

<p align='right' style="float: right;"><i>Page 525</i></p>

## take and take_while

- `take` iterator returns `None` after producing at most n items
- `take_while` iterator applies predicate to each item, and returns `None` in place of the first
  item for which predicate returns false

<p align='right' style="float: right;"><i>Page 527</i></p>

## skip and skip_while

- complement of take and take_while
- drop a certain number of items from the beginning of an iteration, or drop items until a
  closure finds one acceptable

<p align='right' style="float: right;"><i>Page 529</i></p>

## peekable

- `peek` at the next item that will be produced without actually consuming it
- additional method `peek` that returns an `Option<&Item>`
- `peek` tries to draw the next item from the underlying iterator, and if there is one, caches it
  until the next call to next
- essential when you can't decide how many items to consume from an iterator until you've gone
  too far

<p align='right' style="float: right;"><i>Page 531</i></p>

## fuse

- takes any iterator and turns into one that will definitely continue to return None once it
  has done so the first time

<p align='right' style="float: right;"><i>Page 532</i></p>

## Reversible Iterators and rev

- implement the `std::iter::DoubleEndedIterator` trait
- pair of pointers to the start and end of the range of elements we haven't yet produced

<p align='right' style="float: right;"><i>Page 533</i></p>

- can reverse it with the rev adapter
- returned iterator is also double-ended: its next and next_back methods are simply exchanged

<p align='right' style="float: right;"><i>Page 534</i></p>

## inspect

- applies a closure to a shared reference to each item, and then passes the item through
- `.inspect(|c| println!("before: {:?}", c))`

<p align='right' style="float: right;"><i>Page 535</i></p>

## chain

- `i1.chain(i2)` returns an iterator that draws items from i1 until it's exhausted, and then
  draws items from i2
- reversible, if both of its underlying iterators are

<p align='right' style="float: right;"><i>Page 536</i></p>

## enumerate

- attaches a running index to the sequence
- iterator that produces items `A, B, C, ...` and returning an iterator that produces pairs `(0,
  A), (1, B), (2, C)`

<p align='right' style="float: right;"><i>Page 537</i></p>

## zip

- combines two iterators into a single iterator that produces pairs holding one value from each
  iterator
- ends when either of the two underlying iterators ends

<p align='right' style="float: right;"><i>Page 538</i></p>

## by_ref

- borrows a mutable reference to the iterator, so that you can apply adaptors to the reference
- done consuming items from these adaptors, you drop them, the borrow ends, and you regain
  access to your original iterator
- `for header in lines.by_ref().take_while(|l| !l.is_empty())`
- `for body in lines`

<p align='right' style="float: right;"><i>Page 540</i></p>

## cloned

- takes an iterator that produces references, and returns an iterator that produces values
  cloned from those references

<p align='right' style="float: right;"><i>Page 541</i></p>

## cycle

- returns an iterator that endlessly repeats the sequence produced by the underlying iterator

<p align='right' style="float: right;"><i>Page 542</i></p>

## Consuming Iterators

<p align='right' style="float: right;"><i>Page 543</i></p>

- `count, sum, product`

<p align='right' style="float: right;"><i>Page 544</i></p>

- `min` and `max` methods on Iterator return the least or greatest item the iterator produces

<p align='right' style="float: right;"><i>Page 545</i></p>

- `max_by` and `min_by` methods return the maximum or minimum item the iterator produces, as
  determined by a comparison function you provide

<p align='right' style="float: right;"><i>Page 546</i></p>

- `max_by_key` and `min_by_key` methods on Iterator let you select the maximum or minimum item
  as determined by a closure applied to each item
- `.max_by_key(|&(_name, pop)| pop)`

<p align='right' style="float: right;"><i>Page 548</i></p>

- use the `<` and `==` operators to compare strings, vectors, and slices, assuming their
  individual elements can be compared
- provide the `eq` and `ne` methods for equality comparisons, and `lt`, `le`, `gt`, and `ge` methods
  for ordered comparisons

<p align='right' style="float: right;"><i>Page 549</i></p>

- any and all methods apply a closure to each item the iterator produces, and return `true` if
  the closure returns true for any item, or for all

<p align='right' style="float: right;"><i>Page 550</i></p>

- `position` method applies a closure to each item from the iterator and returns the index of the
  first item for which the closure returns true
- closure returns `true` for no item, position returns `None`
- `rposition` method is the same, except that it searches from the right

<p align='right' style="float: right;"><i>Page 551</i></p>

## fold

- repeatedly applies the closure to the current accumulator and the next item from the iterator
- accumulator values are moved into and out of the closure, so you can use fold with non-Copy
  accumulator types

<p align='right' style="float: right;"><i>Page 553</i></p>

## nth

- takes an index `n,` skips that many items from the iterator, and returns the next item
- doesn't take ownership of the iterator the way an adapter would

<p align='right' style="float: right;"><i>Page 554</i></p>

## last

- consumes items until the iterator returns `None`, and then returns the last item

<p align='right' style="float: right;"><i>Page 555</i></p>

## find

- returning the first item for which the given closure returns `true`, or `None`

<p align='right' style="float: right;"><i>Page 556</i></p>

## Building Collections: collect and FromIterator

- can build any kind of collection from Rust's standard library, as long as the iterator
  produces a suitable item type
- `let args: HashSet<String> = std::env::args().collect()`
- `let args: LinkedList<String> = std::env::args().collect()`
- `Vec` or `HashMap` knows how to construct itself from an iterator, it implements the
  `std::iter::FromIterator` trait

<p align='right' style="float: right;"><i>Page 559</i></p>

## Extend Trait

- `extend` method adds an iterable's items to the collection
- standard collections implement `Extend`
- Arrays and slices, which have a fixed length, do not

<p align='right' style="float: right;"><i>Page 560</i></p>

## partition

- divides an iterator's items among two collections
- `partition(|name| name.as_bytes()[0] & 1 != 0)`

<p align='right' style="float: right;"><i>Page 562</i></p>

## Implementing Your Own Iterators

- implement the `IntoIterator` and `Iterator` traits for your own types
- standard library provides a blanket implementation of

<p align='right' style="float: right;"><i>Page 563</i></p>

- `IntoIterator` for every type that implements `Iterator`
- `enum BinaryTree<T>`
- `struct TreeIter<'a, T: 'a>`

<p align='right' style="float: right;"><i>Page 564</i></p>

- give `BinaryTree` an iter method that returns an iterator over the tree
- `impl<T> BinaryTree<T> { fn iter(&self) -> TreeIter<T>`
- implement `IntoIterator` on a shared reference to a tree with a call to `BinaryTree::iter`
- `impl<'a, T: 'a> IntoIterator for &'a BinaryTree<T> `
- `type Item = &'a T`
- `type IntoIter = TreeIter<'a, T>`

<p align='right' style="float: right;"><i>Page 565</i></p>

- establishes `TreeIter` as the iterator type for a `&BinaryTree`
- in the `Iterator` implementation, we get to actually walk the tree
- `impl<'a, T> Iterator for TreeIter<'a, T>`
- `type Item = &'a T`

<p align='right' style="float: right;"><i>Page 568</i></p>

## Collections

- Rust uses moves to avoid deep-copying values

<p align='right' style="float: right;"><i>Page 570</i></p>

## Summary of the standard collections

<p align='right' style="float: right;"><i>Page 571</i></p>

- `LinkedList<T>` supports fast access to the front and back of the list, like `VecDeque<T>`, and
  adds fast concatenation
- `BTreeMap<K, V>` is like `HashMap<K, V>`, but it keeps the entries sorted by key
- `BTreeSet<T>` is like `HashSet<T>`, but it keeps the elements sorted by value

<p align='right' style="float: right;"><i>Page 572</i></p>

## `Vec<T>`

<p align='right' style="float: right;"><i>Page 574</i></p>

- `let first_line = &lines[0]`
- `let fifth_number = numbers[4]; // requires Copy`
- `let second_line = lines[1].clone(); // requires Clone`
- `slice.first()`
- `slice.last()`
- `slice.get(index)` returns `Some` reference

<p align='right' style="float: right;"><i>Page 575</i></p>

- `slice.first_mut()`, `slice.last_mut(),` and `slice.get_mut(index)`
- `slice.to_vec()` clones a whole slice
- available only if the elements are cloneable

<p align='right' style="float: right;"><i>Page 576</i></p>

- Iterating over a `Vec<T>` produces items of type T
- Iterating over a value of type `&[T; N]`, `&[T]`, or `&Vec<T>` - that is, a reference to an
  `array`, `slice,` or vector—produces items of type `&T`
- Iterating over a value of type &mut `[T; N]`, `&mut [T]`, or `&mut Vec<T>` produces items of
  type `&mut T`

<p align='right' style="float: right;"><i>Page 577</i></p>

- `Vec::with_capacity(n)` creates a new, empty vector with capacity n
- `vec.reserve(n)` makes sure the vector has at least enough spare capacity for n more elements
- `vec.reserve_exact(n)` is like vec.reserve(n), but tells vec not to allocate any extra capacity
- `vec.shrink_to_fit()` tries to free up the extra memory

<p align='right' style="float: right;"><i>Page 578</i></p>

- `vec.insert(index, value)` inserts the given value at `vec[index]`, sliding any existing values
  in `vec[index..]` one spot to the right
- `vec.remove(index)` removes and returns `vec[index],` sliding any existing values in
  `vec[index+1..]` one spot to the left
- doing `vec.remove(0)` a lot, consider using a `VecDeque`
- `vec.resize(new_len, value)` sets vec's length to `new_len`

<p align='right' style="float: right;"><i>Page 579</i></p>

- `vec.truncate(new_len)` reduces the length of vec to `new_len`, dropping any elements
- `vec.clear()` removes all elements from vec. It's the same as `vec.truncate(0)`
- `vec.extend(iterable)` adds all items from the given iterable value at the end of vec, in order
- `vec.split_off(index)` is like `vec.truncate(index)`, except that it returns a `Vec<T>`
  containing the values removed from the end of vec
- `vec.append(&mut` vec2), where `vec2` is another vector of type `Vec<T>,` moves all elements
  from `vec2` into `vec`
- `vec.drain(range)`, where range is a range value, like `..` or `0..4`, removes the range
  `vec[range]` from `vec` and returns an iterator over the removed elements

<p align='right' style="float: right;"><i>Page 580</i></p>

- `vec.retain(test)` removes all elements that don't pass the given test
- `vec.dedup()` drops repeated elements

<p align='right' style="float: right;"><i>Page 582</i></p>

- `slices.concat()` returns a new vector made by concatenating all the slices
- `[[1, 2], [3, 4], [5, 6]].concat()`
- `slices.join(&separator)` is the same, except a copy of the value separator is inserted
  between slices

<p align='right' style="float: right;"><i>Page 583</i></p>

- `slice.split_at(index)` and `slice.split_at_mut(index)` break a slice in two, returning a pair

<p align='right' style="float: right;"><i>Page 584</i></p>

- `(&slice[..index], &slice[index..])`
- `slice.split_first()` and `slice.split_first_mut()` also return a pair: a reference to the first element (slice[0]) and a slice reference to all the rest (slice[1..])
- `slice.split_last()` and `slice.split_last_mut()` are analogous
- `slice.split(is_sep)` and `slice.split_mut(is_sep)` split slice into one or more subslices, using the function or closure is_sep
- `slice.splitn(n,` is_sep) and `slice.splitn_mut(n,` is_sep)
- `slice.rsplitn(n,` is_sep) and `slice.rsplitn_mut(n,` is_sep)
- `slice.chunks(n)` and `slice.chunks_mut(n)` return an iterator over nonoverlapping subslices
  of length n

<p align='right' style="float: right;"><i>Page 585</i></p>

- slice.windows(n) returns an iterator that behaves like a _sliding window_ over the data in slice
- &slice[0..n]; the second is &slice[1..n+1]

<p align='right' style="float: right;"><i>Page 587</i></p>

- `slice.swap(i,` j) swaps the two elements `slice[i]` and `slice[j]`
- `vec.swap_remove(i)` removes and returns `vec[i]`
- moves `vec`'s last element into the gap

<p align='right' style="float: right;"><i>Page 588</i></p>

- `slice.sort()` sorts the elements into increasing order
- `slice.sort_by(cmp)`
- `students.sort_by(|a, b| a.last_name.cmp(&b.last_name));`
- `slice.sort_by_key(key)` sorts the elements of slice into increasing order by a sort key
- `students.sort_by_key(|s| s.grade_point_average())`

<p align='right' style="float: right;"><i>Page 589</i></p>

- `slice.reverse()` reverses a slice in place
- `slice.binary_search(&value)`, `slice.binary_search_by(&value, cmp)`, and
  slice.binary_search_by_key(&value, key) all search for value in the given sorted slice
- binary search only works if the slice is in fact sorted in the specified order

<p align='right' style="float: right;"><i>Page 590</i></p>

- `slice.contains(&value)` returns `true` if any element of slice is equal to value
- location of a value in a slice
- `slice.iter().position(|x| *x == value)`

<p align='right' style="float: right;"><i>Page 591</i></p>

- `slice.starts_with(other)` returns `true` if slice starts with a sequence of values
- `slice.ends_with(other)`

<p align='right' style="float: right;"><i>Page 592</i></p>

- `rng.choose(slice)` returns a reference to a random element of a slice
- `rng.shuffle(slice)` randomly reorders the elements of a slice in place
- `use rand::{Rng, thread_rng}`

<p align='right' style="float: right;"><i>Page 595</i></p>

## VecDeque<T>

- supports efficiently adding and removing elements only at the end
- implementation of `VecDeque` is a ring buffer

<p align='right' style="float: right;"><i>Page 596</i></p>

- don't store their elements contiguously

<p align='right' style="float: right;"><i>Page 597</i></p>

- don't inherit all the methods of slices
- `Vec::from(deque)` turns a deque into a vector. This costs O(n)
- `VecDeque::from(vec)` turns a vector into a `deque.` this is also O(n), but it's usually fast

<p align='right' style="float: right;"><i>Page 598</i></p>

## LinkedList<T>

- Each value is stored in a separate heap allocation
- doubly linked list for Rust. It supports a subset of `VecDeque`'s methods
- advantage of `LinkedList` over `VecDeque` is that combining two lists is very fast

<p align='right' style="float: right;"><i>Page 599</i></p>

## BinaryHeap<T>

- elements are kept loosely organized so that the greatest value always bubbles up to the front
  of the queue
- `heap.pop()` removes and returns the greatest value from the heap
- `heap.peek()` returns a reference to the greatest value in the heap

<p align='right' style="float: right;"><i>Page 600</i></p>

- iterators produce the heap's elements in an arbitrary order, not from greatest to least

<p align='right' style="float: right;"><i>Page 601</i></p>

## HashMap<K, V> and BTreeMap<K, V>

- map is a collection of key-value pairs (called entries)
- kept organized so that if you have a key, you can efficiently look up the corresponding value
- HashMap stores the keys and values in a hash table
- `key type K` that implements `Hash` and `Eq`
- `BTreeMap` stores the entries in order by `key,` in a tree structure
- `key type K` that implements `Ord`

<p align='right' style="float: right;"><i>Page 602</i></p>

- Most nodes in a `BTreeMap` contain only key-value pairs
- Nonleaf nodes, like the root node shown in this figure, also have room for pointers to child nodes.
- uses B-trees rather than balanced binary trees because B-trees are faster on modern hardware
- searching a B-tree has better locality—that is, the memory accesses are grouped together rather than scattered across the whole heap
- makes CPU cache misses rarer

<p align='right' style="float: right;"><i>Page 603</i></p>

- `iter.collect()` can be used to create and populate a new `HashMap` or `BTreeMap` from key-value pairs
- iter must be an `Iterator<Item=(K, V)>`

<p align='right' style="float: right;"><i>Page 604</i></p>

- `btree_map.split_at(&key)` splits `btree_map` in two. Entries with keys less than key are
  left in `btree_map`

<p align='right' style="float: right;"><i>Page 605</i></p>

## Entries

- point of entries is to eliminate redundant map lookups
- do the lookup just once, producing an Entry value that is then used for all subsequent
  operations
- `let record = student_map.entry(name.to_string()).or_insert_with(Student::new)`
- Entry value returned by `student_map.entry(name.to_string())` acts like a mutable reference
  to a place within the map that's either occupied by a key-value pair, or vacant
- `map.entry(key)` returns an Entry for the given key. If there's no such key in the map, this
  returns a vacant Entry
- takes its self argument by mut reference and returns an Entry with a matching lifetime

<p align='right' style="float: right;"><i>Page 606</i></p>

- As long as the Entry exists, it has exclusive access to the map
- `map.entry(key).or_insert(value)` ensures that map contains an entry with the given key,
  inserting a new entry with the given default value if needed
- `let count = vote_counts.entry(name).or_insert(0)`
- `*count += 1`
- type of `count` is `&mut` usize
- `map.entry(key).or_insert_with(default_fn)` is the same, except that if it needs to create a
  new entry, it calls `default_fn()`

<p align='right' style="float: right;"><i>Page 607</i></p>

- `pub enum Entry<'a, K: 'a, V: 'a> { Occupied(OccupiedEntry<'a, K, V>), Vacant(VacantEntry<'a, K, V>) }`
- `OccupiedEntry` and `VacantEntry` types have methods for inserting, removing, and accessing
  entries without repeating the initial lookup

<p align='right' style="float: right;"><i>Page 608</i></p>

- (_for (k, v) in map_) produces (K, V) pairs. This consumes the map
- (_for (k, v) in &map_) produces (&K, &V) pairs
- (_for (k, v) in &mut map_) produces (&K, &mut V) pairs

<p align='right' style="float: right;"><i>Page 609</i></p>

## HashSet<T> and BTreeSet<T>

- collections of values arranged for fast membership testing
- behind the scenes, a set is like a map with only keys, rather than key-value pairs
- `HashSet<T>` and `BTreeSet<T>`, are implemented as thin wrappers around `HashMap<T, ()>` and
  `BTreeMap<T, ()>`

<p align='right' style="float: right;"><i>Page 611</i></p>

- (_for v in set_) produces the members of the set (and consumes the set)
- (_for v in &set_) produces shared references to the members of the set

<p align='right' style="float: right;"><i>Page 613</i></p>

- `set1.intersection(&set2)` returns an iterator over all values that are in both `set1` and `set2`
- `&set1 & &set2` returns a new set that's the intersection of `set1` and `set2`
- `set1.union(&set2)` returns an iterator over values that are in either `set1` or `set2,` or both
- `&set1 | &set2` returns a new set containing all those values

<p align='right' style="float: right;"><i>Page 614</i></p>

- `set1.difference(&set2)` returns an iterator over values that are in `set1` but not in `set2`
- `&set1 - &set2` returns a new set containing all those values
- `set1.symmetric_difference(&set2)` returns an iterator over values that are in either `set1` or
  `set2,` but not both
- `&set1 ^ &set2` returns a new set containing all those values
- `set1.is_disjoint(set2)` is true if set1 and set2 have no values in common
- `set1.is_subset(set2)` is true if set1 is a subset of set2
- `set1.is_superset(set2)` is the reverse: it's true if set1 is a superset of set2

<p align='right' style="float: right;"><i>Page 615</i></p>

## Hashing

- `std::hash::Hash` is the standard library trait for hashable types
- `HashMap` keys and `HashSet` elements must implement both `Hash` and `Eq`
- value should have the same hash code regardless of where you store it or how you point to it
- implement `PartialEq` by hand for a type, you should also implement `Hash` by hand

<p align='right' style="float: right;"><i>Page 616</i></p>

- like all hash tables, it requires that `hash(a) == hash(b) if a == b`

<p align='right' style="float: right;"><i>Page 618</i></p>

- possible to implement a faster hash function, at the expense of HashDoS security
- _fnv_ crate implements one such algorithm, the Fowler-Noll-Vo hash
- `use fnv::{FnvHashMap, FnvHashSet}`
- `use these two types as drop-in replacements for HashMap and HashSet`
- `pub type FnvHashMap<K, V> = HashMap<K, V, FnvBuildHasher>`
- `pub type FnvHashSet<T> = HashSet<T, FnvBuildHasher>`

<p align='right' style="float: right;"><i>Page 623</i></p>

## UTF-8

- encodes a character as a sequence of one to four bytes
- only the shortest encoding for any given code point is considered well-formed

<p align='right' style="float: right;"><i>Page 624</i></p>

- range of bytes holding ASCII text is valid UTF-8
- string of UTF-8 includes only characters from ASCII, the reverse is also true
- byte's upper bits, you can immediately tell whether it is the start of some character's UTF-8 encoding, or a byte from the midst of one
- encoding's first byte alone tells you the encoding's full length, via its leading bits

<p align='right' style="float: right;"><i>Page 625</i></p>

- searching a UTF-8 string for an ASCII delimiter character requires only a simple scan for the delimiter's byte
- can never appear as any part of a multibyte encoding, so there's no need to keep track of the UTF-8 structure

<p align='right' style="float: right;"><i>Page 627</i></p>

## Characters (char)

- Rust char is a 32-bit value holding a Unicode code point
- guaranteed to fall in the range from `0` to `0xd7ff,` or in the range `0xe000` to `0x10ffff`

<p align='right' style="float: right;"><i>Page 628</i></p>

## Classifying Characters

<p align='right' style="float: right;"><i>Page 629</i></p>

- `assert_eq!('F'.to_digit(16), Some(15))`
- `assert_eq!(std::char::from_digit(15, 16), Some('f'))`

<p align='right' style="float: right;"><i>Page 632</i></p>

- `assert_eq!('B' as u32, 66)`
- char implements `From<u8>` as well, but wider integer types can represent invalid code points

<p align='right' style="float: right;"><i>Page 633</i></p>

## String and str

- guaranteed to hold only well-formed UTF-8

<p align='right' style="float: right;"><i>Page 635</i></p>

- `slice.to_string()` allocates a fresh String whose contents are a copy of slice
- `iter.collect()` constructs a string by concatenating an iterator's items, which can be
  `char`, &`str`, or `String` values

<p align='right' style="float: right;"><i>Page 637</i></p>

- `slice.len()` is the length of slice, in bytes
- `slice[range]` returns a slice borrowing the given portion of slice
- cannot index a string slice with a single position, like `slice[i]`
- `parenthesized[6..].chars().next()`

<p align='right' style="float: right;"><i>Page 639</i></p>

- implements `std::fmt::Write`, meaning that the `write!` and `writeln!` macros can append
  formatted text to Strings
- `writeln!(letter, "Whose {} these are I think I know", "rutabagas")?`
- writing to a String is actually infallible, so in this case calling `.unwrap()` would be OK

<p align='right' style="float: right;"><i>Page 640</i></p>

- `String` implements `Add<&str>` and `AddAssign<&str>`

<p align='right' style="float: right;"><i>Page 643</i></p>

- search, match, split, or trim text, it accepts several different types to represent what to look for
- `assert_eq!(haystack.find(','), Some(12))`
- `assert_eq!(haystack.find("night"), Some(35))`
- `assert_eq!(haystack.find(char::is_whitespace), Some(3))`

<p align='right' style="float: right;"><i>Page 644</i></p>

- pattern is any type that implements the `std::str::Pattern` trait

<p align='right' style="float: right;"><i>Page 647</i></p>

- `slice.chars()` returns an iterator over slice's characters

<p align='right' style="float: right;"><i>Page 648</i></p>

- `slice.bytes()` returns an iterator over the individual bytes of slice

<p align='right' style="float: right;"><i>Page 653</i></p>

- type implements the `std::str::FromStr` trait, then it provides a standard way to parse a
  value from a string slice
- `IpAddr::from_str("fe80::0000:3ea9:f4ff:fe34:7a50")?`
- `"fe80::0000:3ea9:f4ff:fe34:7a50".parse::<IpAddr>()?`

<p align='right' style="float: right;"><i>Page 654</i></p>

- human-readable printed form can implement the `std::fmt::Display` trait

<p align='right' style="float: right;"><i>Page 655</i></p>

- `std::fmt::Debug,` which takes a value and formats it as a string in a way helpful to programmers

<p align='right' style="float: right;"><i>Page 658</i></p>

- `str::from_utf8(byte_slice)` takes a `&[u8]` slice of bytes and returns a `Result`
- `String::from_utf8(vec)` tries to construct a string from a `Vec<u8>` passed by value
- `String::from_utf8_lossy(byte_slice)` tries to construct a `String` or `&str` from a `&[u8]`
  shared slice of bytes
  - this conversion always succeeds, replacing any ill-formed UTF-8 with Unicode replacement
    characters

<p align='right' style="float: right;"><i>Page 660</i></p>

- Putting Off Allocation
- sometimes the return value of name should be an owned `String,` sometimes it should be a
  `&'static str`
- using `std::borrow::Cow,` the clone-on-write type that can hold either owned or borrowed data

<p align='right' style="float: right;"><i>Page 661</i></p>

- also useful when you may or may not need to modify some text you've borrowed

<p align='right' style="float: right;"><i>Page 662</i></p>

- special support for `Cow<'a, str>`
  - it provides `From` and `Into` conversions from both `String` and `&str`
- `std::env::var("USER") .map(|v| v.into()).unwrap_or("whoever you are".into())`

<p align='right' style="float: right;"><i>Page 666</i></p>

## Formatting Text Values

- text length limit. Rust truncates your argument if it is longer than this
- minimum field width. After any truncation, if your argument is shorter than this, Rust pads
  it on the right
- alignment. If your argument needs to be padded to meet the minimum field width, this says
  where your text should be placed within the field
- Field width, length limit `"{:12.20}"`
- Aligned left, width `"{:<12}"`

<p align='right' style="float: right;"><i>Page 667</i></p>

- Centered, width "{:^12}"

<p align='right' style="float: right;"><i>Page 668</i></p>

## Formatting Numbers

<p align='right' style="float: right;"><i>Page 669</i></p>

- Forced sign `"{:+}"` `"+1234"`
- Leading zeros, width `"{:012}"` `"000000001234"`
- Aligned left, width `"{:<12}"` `"1234` "
- Centered, width `"{:^12}"` `" 1234 "`
- Aligned right, width "{:>12}" `" 1234"`
- Padded with `'='`, centered, width `"{:=^12}"` `"====1234===="`
- Binary notation `"{:b}"` `"10011010010"`
- Sign, radix, zeros, width, hex `"{:+#012x}"` `"+0x0000004d2"`

<p align='right' style="float: right;"><i>Page 670</i></p>

- Precision `"{:.2}"` `"1234.57"`
- Scientific, precision `"{:.3e}"` `"1.235e3"`

<p align='right' style="float: right;"><i>Page 672</i></p>

## Formatting Values for Debugging

- `{:?}` parameter formats any public type in the Rust standard library in a way meant to be
  helpful to programmers
- `println!("{:#?}", map)`

<p align='right' style="float: right;"><i>Page 674</i></p>

- The `{:p}` notation formats references, boxes, and other pointer-like types as addresses

<p align='right' style="float: right;"><i>Page 676</i></p>

- choose the field width at runtime, you can write:
- `1$` for the minimum field width tells `format!` to use the value of the second argument as the
  width
- `format!("{:>width$}", content, width=get_width())`
- write `*`, which says to take the next positional argument as the precision
- `format!("{:.*}", get_limit(), content)`

<p align='right' style="float: right;"><i>Page 680</i></p>

## Formatting Language

- write your own functions and macros that accept format templates and arguments
- `format_args!` macro and the `std::fmt::Arguments` type
- compile time, the `format_args!` macro parses the template string and checks it against the
  arguments' types
- runtime, it evaluates the arguments and builds an Arguments value
- Constructing an Arguments value is cheap

<p align='right' style="float: right;"><i>Page 682</i></p>

## Regular Expressions

- external _regex_ crate is Rust's official regular expression library
- maintained by the Rust library team, the same group responsible for std

<p align='right' style="float: right;"><i>Page 685</i></p>

- `Regex::new` constructor can be expensive
- construct your Regex once, and then reuse the same one
- _lazy_static_ crate provides a nice way to construct static values lazily the first time they are used
- `lazy_static! { static ref SEMVER: Regex = Regex::new(r"(\d+)\.(\d+)\.(\d+)(-[-.[:alnum:]]*)?") .expect("error parsing regex"); }`
- first time `SEMVER` is dereferenced, the initializer is evaluated

<p align='right' style="float: right;"><i>Page 687</i></p>

## Normalization

<p align='right' style="float: right;"><i>Page 688</i></p>

- Unicode specifies normalized forms for strings
- character-for-character identical
- encoded with UTF-8, they are byte-for-byte identica

<p align='right' style="float: right;"><i>Page 691</i></p>

- unicode-normalization crate provides a trait that adds methods to `&str` to put the text in any
  of the four normalized forms

<p align='right' style="float: right;"><i>Page 692</i></p>

## Input and Output

- input and output are organized around three traits— `Read`, `BufRead`, and `Write`

<p align='right' style="float: right;"><i>Page 695</i></p>

- traits `Read`, `BufRead`, `Write`, and `Seek` are so commonly used that there's a prelude
- `use std::io::prelude::*;`

<p align='right' style="float: right;"><i>Page 696</i></p>

## Readers

- `reader.read(&mut buffer)`
- success, the `u64` value is the number of bytes read
- `io::Error` is printable, for the benefit of humans; for programs, it has a `.kind()` method
  that returns an error code of type `io::ErrorKind`
- `io::ErrorKind::Interrupted` corresponds to the Unix error code `EINTR`
- should just retry the read
- higher-level convenience methods
- `reader.read_to_end(&mut byte_vec)`

<p align='right' style="float: right;"><i>Page 697</i></p>

- `reader.read_to_string(&mut string)`
- `reader.read_exact(&mut buf)` reads exactly enough data to fill the given buffer
- `reader.chain(reader2)`
- `reader.take(n)`
- limited to `n` bytes of input

<p align='right' style="float: right;"><i>Page 698</i></p>

- Readers and writers typically implement `Drop` so that they are closed automatically

<p align='right' style="float: right;"><i>Page 699</i></p>

## Buffered Readers

- `reader.read_line(&mut line)` reads a line of text and appends it

<p align='right' style="float: right;"><i>Page 700</i></p>

- `reader.lines()` returns an iterator over the lines of the input
- `reader.read_until(stop_byte, &mut byte_vec)` and `reader.split(stop _byte)` are just like
  `.read_line()` and `.lines()`, but byte-oriented

<p align='right' style="float: right;"><i>Page 702</i></p>

- create a buffered reader for a `File,` or any other unbuffered reader
- `BufReader::new(reader)` does this. (To set the size of the buffer, use
    `BufReader::with_capacity(size, reader)`

<p align='right' style="float: right;"><i>Page 704</i></p>

- `.lines(),` return iterators that produce Result values
- `reader.lines().collect::<io::Result<Vec<String>>>()?;`
- standard library contains an implementation of `FromIterator` for `Result`

<p align='right' style="float: right;"><i>Page 706</i></p>

## Writers

- write macros each take an extra first argument, a writer
- return a `Result,` so errors must be handled
- `writer.write(&buf)` writes some of the bytes in the slice buf to the underlying stream

<p align='right' style="float: right;"><i>Page 707</i></p>

- `writer.write_all(&buf)` writes all the bytes in the slice buf
- `writer.flush()` flushes any buffered data to the underlying stream

<p align='right' style="float: right;"><i>Page 708</i></p>

## Files

- `File::open(filename)` opens an existing file for reading
- `File::create(filename)` creates a new file for writing
- `use OpenOptions` to specify the exact desired behavior
- `OpenOptions::new().append(true) // if file exists, add to the end`
- `OpenOptions::new().write(true).create_new(true) // fail if file exists`

<p align='right' style="float: right;"><i>Page 710</i></p>

- `Vec<u8>` implements `Write`
- Writing to a `Vec<u8>` extends the vector with the new data
- build a string using `Write,` first write to a `Vec<u8>`, then use `String::from_utf8(vec)`
- `Cursor::new(buf)` creates a `Cursor`, a buffered reader that reads from `buf`
- how you create a reader that reads from a String

<p align='right' style="float: right;"><i>Page 711</i></p>

- `Cursors` implement `Read`, `BufRead`, and `Seek`
- `std::net::TcpStream` represents a `TCP` network connection
- `TCP` enables two-way communication, it's both a reader and a writer
- `std::process::Command` supports spawning a child process and piping data to its standard input

<p align='right' style="float: right;"><i>Page 712</i></p>

- `io::sink()` is the no-op writer
- `io::empty()` is the no-op reader
- `io::repeat(byte)` returns a reader that repeats the given byte endlessly

<p align='right' style="float: right;"><i>Page 717</i></p>

## OsStr and Path

- `OsStr` is a string type that's a superset of UTF-8
- whether they're valid Unicode or not
- `Path` is exactly like `OsStr,` but it adds many handy filename-related methods
- Use `Path` for both absolute and relative paths
- For an individual component of a path, use `OsStr`

<p align='right' style="float: right;"><i>Page 718</i></p>

- Convert to owned type `.to_string()` `.to_os_string()` `.to_path_buf()`
- All three of these types implement a common trait, `AsRef<Path>`
- declare a generic function that accepts _any filename type_ as an argument
- `where P: AsRef<Path>`

<p align='right' style="float: right;"><i>Page 729</i></p>

## Networking

- `std::net` module, which provides cross-platform support for TCP and UDP networking
- blocking input and output over the network
- spawning a thread for each connection

<p align='right' style="float: right;"><i>Page 730</i></p>

- high-performance servers, you'll need to use asynchronous input and output
- _mio_ crate provides the needed support
- provides a simple event loop and asynchronous methods for reading, writing, connecting, and
  accepting connections
- asynchronous copy of the whole networking API
- tokio crate, which wraps the mio event loop in a futures-based API
- _reqwest_ crate offers a beautiful API for HTTP clients

<p align='right' style="float: right;"><i>Page 731</i></p>

- _iron_ framework for HTTP servers offers high-level touches such as the `BeforeMiddleware` and
  `AfterMiddleware` traits
- _websocket_ crate implements the WebSocket protocol

<p align='right' style="float: right;"><i>Page 732</i></p>

## Concurrency

<p align='right' style="float: right;"><i>Page 735</i></p>

## Fork-Join Parallelism

- _fork_is to start a new thread
- _join_ a thread is to wait for it to finish

<p align='right' style="float: right;"><i>Page 736</i></p>

- only time any thread has to wait for another is at the end

<p align='right' style="float: right;"><i>Page 737</i></p>

- requires isolated units of work

<p align='right' style="float: right;"><i>Page 738</i></p>

- `std::thread::spawn` starts a new thread
- takes one argument, a `FnOnce` closure or function
- new thread is a real operating system thread with its own stack

<p align='right' style="float: right;"><i>Page 739</i></p>

- `spawn(move || process_files(worklist))`
- `spawn` then moves the closure (including the worklist vector) over to the new child thread
- only data moved is the `Vec` itself: three machine words
- `spawn()` returns a value called a `JoinHandle`

<p align='right' style="float: right;"><i>Page 740</i></p>

- `handle.join().unwrap()?`
- Joining threads is often necessary for correctness
- Rust program exits as soon as main returns, even if other threads are still running

<p align='right' style="float: right;"><i>Page 741</i></p>

## Error Handling Across Threads

- `handle.join()` returns a `std::thread::Result`
- that's an error if the child thread panicked
- `panic` in one thread is reported as an error `Result` in other threads
- `handle.join()` passes the return value from the child thread back to the parent thread
- full type returned by `handle.join()` in this program is `std::thread::Result<std::io::Result<()>>`

<p align='right' style="float: right;"><i>Page 743</i></p>

## Sharing Immutable Data Across Threads

<p align='right' style="float: right;"><i>Page 745</i></p>

- to run the analysis in parallel, the caller must pass in an `Arc<GigabyteMap>`
- smart pointer to a `GigabyteMap` that's been moved into the heap, by doing `Arc::new(giga_map)`
- `glossary.clone()`, we are making a copy of the `Arc` smart pointer, not the whole `GigabyteMap`
- As long as _any_ thread owns an `Arc<GigabyteMap>`, it will keep the map alive

<p align='right' style="float: right;"><i>Page 746</i></p>

## Rayon

- `rayon::join(fn1, fn2)` simply calls both functions and returns both results
- `par_iter()` method creates a `ParallelIterator`, a value with `map`, `filter`, and other methods
- uses its own pool of worker threads
- one worker thread per CPU core

<p align='right' style="float: right;"><i>Page 747</i></p>

- `filenames.par_iter().map(|filename| process_file(filename, glossary)).reduce_with(|r1, r2| { if r1.is_err() { r1 } else { r2 } })`

<p align='right' style="float: right;"><i>Page 748</i></p>

- balances workloads across threads dynamically, using a technique called _work-stealing_
- supports sharing references across threads

<p align='right' style="float: right;"><i>Page 752</i></p>

## Channels

- one-way conduit for sending values from one thread to another
- a thread-safe queue
- one end is for sending data, and the other is for receiving
- `sender.send(item)` puts a single value into the channel
- `receiver.recv()` removes one
- Ownership is transferred from the sending thread to the receiving thread
- `receiver.recv()` blocks until a value is sent

<p align='right' style="float: right;"><i>Page 753</i></p>

- Rust channels are faster than Unix pipes
- Sending a value moves it rather than copying it, and moves are fast

<p align='right' style="float: right;"><i>Page 765</i></p>

- Rust channels also support multiple senders
- simply create a regular channel and `clone` the sender as many times as you like
- move each `Sender` value to a different thread
- `Receiver<T>` can't be cloned
- multiple threads receiving values from the same channel, you need a `Mutex`

<p align='right' style="float: right;"><i>Page 766</i></p>

- Unix uses an elegant trick to provide some backpressure
- Rust equivalent is called a synchronous channel
- `let (sender, receiver) = sync_channel(1000)`

<p align='right' style="float: right;"><i>Page 767</i></p>

- exactly like a regular channel except that when you create it, you specify how many values it
  can hold
- `sender.send(value)` is potentially a blocking operation

<p align='right' style="float: right;"><i>Page 768</i></p>

## Thread Safety: Send and Sync

- `Send` are safe to pass by value to another thread
- can be moved across threads
- `Sync` are safe to pass by non-mut reference to another thread
- can be shared across threads

<p align='right' style="float: right;"><i>Page 769</i></p>

- types that are not `Send` and `Sync` are mostly those that use mutability in a way that isn't
  thread-safe

<p align='right' style="float: right;"><i>Page 773</i></p>

- we're free to add a concurrency power tool to almost every iterator in the language
- first understanding and documenting the restrictions that make it safe to use
- must specify `T: Iterator + Send + 'static`
- must specify `T::Item: Send + 'static`

<p align='right' style="float: right;"><i>Page 775</i></p>

## Shared Mutable State

<p align='right' style="float: right;"><i>Page 776</i></p>

## Mutex

- `mutex` (or `lock)` is used to force multiple threads to take turns when accessing certain
  data

<p align='right' style="float: right;"><i>Page 779</i></p>

- protected data is stored inside the `Mutex`

<p align='right' style="float: right;"><i>Page 780</i></p>

- `Arc` is handy for sharing things across threads
- `Mutex` is handy for _mutable_ data that's shared across threads
- `let mut guard = self.waiting_list.lock().unwrap()`
- blocks until the `mutex` can be obtained
- When `guard` is dropped, the lock is released

<p align='right' style="float: right;"><i>Page 782</i></p>

- dynamically enforces exclusive access
- usually done statically, at compile time, by the Rust compiler

<p align='right' style="float: right;"><i>Page 783</i></p>

- `Mutexes` Are Not Always a Good Idea
- can't have data races, but they can still have other race conditions
- behavior depends on timing among threads
- mutexes encourage a _just-add-a-method_ way

<p align='right' style="float: right;"><i>Page 784</i></p>

- Use a more structured approach when you can; use a `Mutex` when you must

<p align='right' style="float: right;"><i>Page 785</i></p>

- deadlock itself by trying to acquire a `lock` that it's already holding

<p align='right' style="float: right;"><i>Page 786</i></p>

- thread panics while holding a `Mutex`, Rust marks the `Mutex` as poisoned
- subsequent attempt to `lock` the poisoned `Mutex` will get an error result

<p align='right' style="float: right;"><i>Page 789</i></p>

## Read/Write Locks

- read/write lock has two locking methods, `read` and `write`
- many threads can safely _read_ at once

<p align='right' style="float: right;"><i>Page 791</i></p>

## Condition Variables (Condvar)

- Condvar has methods `.wait()` and `.notify_all();`
- `wait()` blocks until some other thread calls `.notify_all()`
- condition becomes `true`, we call `Condvar::notify_all` (or `notify_one)` to _wake up_ any waiting
  threads
- `self.has_data_condvar.notify_all();`
- `while !guard.has_data() { guard = self.has_data_condvar.wait(guard).unwrap(); }`

<p align='right' style="float: right;"><i>Page 793</i></p>

## Atomics

- `AtomicIsize` and `AtomicUsize` are shared integer types corresponding to the single-threaded
  `isize` and `usize` types
- `AtomicBool` is a shared `bool` value
- `AtomicPtr<T>` is a shared value of the unsafe pointer type `*mut T`
- multiple threads can read and write an atomic value at once without causing data races
- argument `Ordering::SeqCst` is a memory ordering

<p align='right' style="float: right;"><i>Page 794</i></p>

- simple use of atomics is for cancellation
- `let cancel_flag = Arc::new(AtomicBool::new(false))`
- `if worker_cancel_flag.load(Ordering::SeqCst)`

<p align='right' style="float: right;"><i>Page 795</i></p>

- `cancel_flag.store(true, Ordering::SeqCst)`
- atomics have minimal overhead
- never use system calls
- load or store often compiles to a single CPU instruction
- useful as simple global variables

<p align='right' style="float: right;"><i>Page 796</i></p>

## Global Variables

- static can be declared `mut`, but then accessing it is unsafe

<p align='right' style="float: right;"><i>Page 797</i></p>

- Atomic globals are limited to simple integers and booleans
- can declare a global `Mutex` with `lazy_static`
- `lazy_static! { static ref HOSTNAME: Mutex<String> = Mutex::new(String::new());`

<p align='right' style="float: right;"><i>Page 798</i></p>

- uses `std::sync::Once`, a low-level synchronization primitive designed for one-time initialization

<p align='right' style="float: right;"><i>Page 800</i></p>

## Macros

<p align='right' style="float: right;"><i>Page 802</i></p>

- `macro_rules!` is the main way to define macros in Rust
- body of a macro is just a series of rules
- `( pattern1 ) => ( template1 );`

<p align='right' style="float: right;"><i>Page 803</i></p>

- use square brackets or curly braces instead of parentheses around the pattern or the
  template; it makes no difference

<p align='right' style="float: right;"><i>Page 804</i></p>

## Macro Expansion

- Rust expands macros very early during compilation
- can't call a macro before it is defined
- Macro patterns are a mini-language within Rust
- regular expressions for matching code
- patterns operate on tokens
- Comments and whitespace aren't tokens, so they don't affect matching

<p align='right' style="float: right;"><i>Page 805</i></p>

- parentheses, brackets, and braces always occur in matched pairs

<p align='right' style="float: right;"><i>Page 810</i></p>

- `$( ... )*` Match 0 or more times with no separator
- `$( ... ),*` Match 0 or more times, separated by commas
- `$( ... );*` Match 0 or more times, separated by semicolons
- `$( ... )+` Match 1 or more times with no separator

<p align='right' style="float: right;"><i>Page 811</i></p>

- `( $( $x:expr ),+ ,) => { // if trailing comma is present, vec![ $( $x ),* ]`

<p align='right' style="float: right;"><i>Page 812</i></p>

## Built-In Macros

- `file!()`
- `line!()` and `column!()`
- `stringify!(...tokens...)`
- `concat!(str0, str1, ...)` expands to a single string literal
- `cfg!(...)` expands to a Boolean constant, `true` if the current build configuration matches
  the condition
- `env!("VAR_NAME")` expands to a string

<p align='right' style="float: right;"><i>Page 813</i></p>

- specified environment variable at compile time
- `option_env!("VAR_NAME")` is the same as `env!` except that it returns an `Option<&'static str>`
- `include!("file.rs")` expands to the contents of the specified file
- must be valid Rust code—either an expression or a sequence of items
- `include_str!("file.txt")` expands to a `&'static str` containing the text of the specified file
- `include_bytes!("file.dat")`
- relative path, it's resolved relative to the directory that contains the current file

<p align='right' style="float: right;"><i>Page 814</i></p>

## Debugging Macros

- `log_syntax!()` macro that simply prints its arguments to the terminal at compile time
- `log` all macro calls to the terminal. Insert `trace_macros!(true)`

<p align='right' style="float: right;"><i>Page 815</i></p>

- `trace_macros!(false);` turns tracing off again

<p align='right' style="float: right;"><i>Page 816</i></p>

## `json!` Macro

<p align='right' style="float: right;"><i>Page 819</i></p>

## Fragment types supported by macro_rules

<p align='right' style="float: right;"><i>Page 822</i></p>

- `Json::Array(vec![ $( json!($element) ),* ])`
- compiler imposes a recursion limit on macros: 64 calls, by default
- `#![recursion_limit = "256"]`

<p align='right' style="float: right;"><i>Page 824</i></p>

## Using Traits with Macros

- convert values of various types to one specified type: the `From` trait

<p align='right' style="float: right;"><i>Page 825</i></p>

- `$other:tt) => { Json::from($other) `

<p align='right' style="float: right;"><i>Page 827</i></p>

## Scoping and Hygiene

<p align='right' style="float: right;"><i>Page 828</i></p>

- Rust renames the variable for you
- Rust is said to have hygienic macros
- macro really does need to refer to a variable in the caller's scope
- caller has to pass the name of the variable to the macro

<p align='right' style="float: right;"><i>Page 829</i></p>

- constants, types, methods, modules, and macro names, Rust is _colorblind_.
- `Box`, `HashMap`, or `Json` is not in scope, the macro won't work

<p align='right' style="float: right;"><i>Page 831</i></p>

## Importing and Exporting Macros

- macros are expanded early in compilation, before Rust knows the full module structure of your
  project
- Macros that are visible in one module are automatically visible in its child modules
- export macros from a module _upward_ to its parent module, use the `#[macro_use]` attribute
- import macros from another crate, use `#[macro_use]` on the extern crate declaration
- export macros from your crate, mark each public macro with `#[macro_export]`
- macro should use absolute paths to any names it uses
- `macro_rules!` provides the special fragment `$crate` to help with this
- acts like an absolute path to the root module of the crate

<p align='right' style="float: right;"><i>Page 832</i></p>

- write `$crate::Json`, which works even if `Json` was not imported

<p align='right' style="float: right;"><i>Page 834</i></p>

- avoid spurious syntax errors is by putting more specific rules first

<p align='right' style="float: right;"><i>Page 835</i></p>

## procedural macros

- supports extending the `#[derive]` attribute to handle custom traits
- makes a procedural macro _procedural_ is that it's implemented as a Rust function

<p align='right' style="float: right;"><i>Page 837</i></p>

## Unsafe Code

- call unsafe functions in the standard library, dereference unsafe pointers, and call
  functions written in other languages like C and C++
- safety checks still apply: type checks, lifetime checks, and bounds checks on indices

<p align='right' style="float: right;"><i>Page 838</i></p>

- Raw pointers and their methods allow unconstrained access to memory

<p align='right' style="float: right;"><i>Page 841</i></p>

## Unsafe Blocks

- unlocks four additional options
- call unsafe functions
- dereference raw pointers
- Safe code can pass raw pointers around, compare them, and create them by conversion from
  references
- only unsafe code can actually use them to access memory
- access mutable static variables
- access functions and variables declared through Rust's foreign function interface

<p align='right' style="float: right;"><i>Page 845</i></p>

- interface using unsafe operations
- arranged to meet their contracts depending only on the module's own code
- not on its users' behavior.

<p align='right' style="float: right;"><i>Page 847</i></p>

- Bugs that occur before the unsafe block can break contracts
- The consequences of breaking a contract may appear after you leave the unsafe block

<p align='right' style="float: right;"><i>Page 848</i></p>

- prefer to create safe interfaces, without contracts

<p align='right' style="float: right;"><i>Page 849</i></p>

## Unsafe Block or Unsafe Function?

- possible to misuse the function in a way that compiles fine but still causes undefined behavior
- mark it as `unsafe`
- no well-typed call to it can cause undefined behavior
- not be marked unsafe
- Don't mark a safe function unsafe just because you use unsafe features
- Instead, use an unsafe block, even if it's the function's entire body

<p align='right' style="float: right;"><i>Page 850</i></p>

## Undefined Behavior

- behavior that Rust firmly assumes your code could never exhibit

<p align='right' style="float: right;"><i>Page 851</i></p>

- Rust's rules for well-behaved programs
- must not read uninitialized memory
- must not create invalid primitive values
- References or boxes that are null

<p align='right' style="float: right;"><i>Page 852</i></p>

- `bool` values that are not either a 0 or 1
- `enum` values with invalid discriminant values
- `char` values that are not valid, nonsurrogate Unicode code points
- `str` values that are not well-formed UTF-8
- No reference may outlive its referent; shared access is read-only access; and mutable access
  is exclusive access
- must not dereference `null`, incorrectly aligned, or dangling pointers
- must not use a pointer to access memory outside the allocation with which the pointer is
  associated
- must be free of data races
- must not unwind across a call made from another language
- must comply with the contracts of standard library functions
- rules are all that Rust assumes in the process of optimizing your program
- Undefined behavior is, simply, any violation of these rules

<p align='right' style="float: right;"><i>Page 854</i></p>

## Unsafe Traits

- has a contract Rust cannot check or enforce that implementers must satisfy to avoid undefined
  behavior
- mark the implementation as `unsafe`
- up to you to understand the trait's contract
- make sure your type satisfies it
- unsafe traits are `std::marker::Send` and `std::marker::Sync`

<p align='right' style="float: right;"><i>Page 857</i></p>

## Raw Pointers

- raw pointer in Rust is an unconstrained pointer
- Rust cannot tell whether you are using them safely or not
- can dereference them only in an unsafe block
- essentially equivalent to C or C++ pointers
- useful for interacting with code written in those languages
- `*mut T` is a raw pointer to a `T` that permits modifying its referent
- `*const T` is a raw pointer to a `T` that only permits reading its referent
- create a raw pointer by conversion from a reference
- dereference it with the `*` operator
- `let ptr_x = &mut x as *mut i32`
- `let ptr_y = &*y as *const i32`
- `*ptr_x += *ptr_y`
- raw pointers can be `null`, like `NULL` in C
- `std::ptr::null()`

<p align='right' style="float: right;"><i>Page 858</i></p>

- `is_null()`
- creating raw pointers, passing them around, and comparing them are all safe
- raw pointer to an unsized type is a fat pointer
- `*const [u8]` pointer includes a length along with the address
- raw pointer dereferences must be explicit
- `(*raw).field or (*raw).method(...)`
- do not implement `Deref,` so deref coercions do not apply
- Operators like `==` and `<` compare raw pointers as addresses
- Rust's `+` does not handle raw pointers
- perform pointer arithmetic via their offset and wrapping_offset methods

<p align='right' style="float: right;"><i>Page 859</i></p>

- Rust implicitly coerces references to raw pointers
- `as` operator permits almost every plausible conversion from references to raw pointers or
  between two raw pointer types
- may need to break up a complex conversion into a series of simpler steps
- Many types have `as_ptr` and `as_mut_ptr` methods that return a raw pointer to their contents
- array slices and strings return pointers to their first elements
- some iterators return a pointer to the next element they will produce
- Owning pointer types like `Box`, `Rc`, and `Arc` have `into_raw` and `from_raw`

<p align='right' style="float: right;"><i>Page 860</i></p>

- raw pointers are neither `Send` nor `Sync`

<p align='right' style="float: right;"><i>Page 861</i></p>

## Dereferencing Raw Pointers Safely

- Dereferencing `null` pointers or dangling pointers is undefined behavior
- Dereferencing pointers that are not properly aligned for their referent type is undefined
  behavior
- borrow values out of a dereferenced raw pointer only if doing so obeys the rules for
  reference safety
- use a raw pointer's referent only if it is a well-formed value of its type

<p align='right' style="float: right;"><i>Page 862</i></p>

- essentially the same rules you must follow when using pointers in C or C++

<p align='right' style="float: right;"><i>Page 867</i></p>

## Nullable Pointers

- `null` raw pointer in Rust is a zero address, just as in C and C++
- `as_ref` method takes a `*const T` pointer and returns an `Option<&'a T>`
- `as_mut` method converts `*mut T` pointers into `Option<&'a mut T>`

<p align='right' style="float: right;"><i>Page 868</i></p>

## Type Sizes and Alignments

- value of any `Sized` type occupies a constant number of bytes
- must be placed at an address that is a multiple of some alignment value
- determined by the machine architecture
- `(i32, i32)` tuple occupies eight bytes
- most processors prefer it to be placed at an address that is a multiple of four
- `std::mem::size_of::<T>()` returns the size of a value of type `T`
- `std::mem::align_of::<T>()` returns its required alignment
- type's alignment is always a power of two
- type's size is always rounded up to a multiple of its alignment
- `size_of::<(f32, u8)>()` is `8`
- For unsized types, the size and alignment depend on the value at hand
- Given a reference to an unsized value
- `std::mem::size_of_val` and `std::mem::align_of_val` functions return the value's size and
  alignment
- operate on references to both Sized and unsized types

<p align='right' style="float: right;"><i>Page 870</i></p>

## Pointer Arithmetic

- raw pointers useful as bounds on array traversals

<p align='right' style="float: right;"><i>Page 872</i></p>

## Moving into and out of Memory

- type that manages its own memory
- need to track which parts of your memory hold live values and which are uninitialized

<p align='right' style="float: right;"><i>Page 875</i></p>

- `Vec`, `HashMap`, `Box`, and so on track their buffers dynamically
- implement a type that manages its own memory, you will need to do the same
- `std::ptr::read(src)` moves a value out of the location src points to, transferring ownership
  to the caller
- After calling `read,` you must treat `*src` as uninitialized memory
- `src` argument should be a `*const T` raw pointer, where `T` is a sized type

<p align='right' style="float: right;"><i>Page 876</i></p>

- `std::ptr::write(dest, value)`
- moves value into the location dest points to
- must be uninitialized memory before the cal
- referent now owns the value
- `dest` must be a `*mut T` raw pointer and value a `T` value, where `T` is a sized type
- cannot do these things with any of Rust's safe pointer types
- require their referents to be initialized at all times
- `std::ptr::copy(src, dst, count)`
- moves the array of count values in memory starting at src to the memory at dst
- destination memory must be uninitialized before the call
- afterward the source memory is left uninitialized
- `src` and `dest` arguments must be `*const T` and `*mut T` raw pointers
- `std::ptr::copy_nonoverlapping(src, dst, count)`
- source and destination blocks of memory must not overlap
- `read_unaligned` and `write_unaligned`

<p align='right' style="float: right;"><i>Page 877</i></p>

- `read` and `write,` except that the pointer need not be aligned as normally required for the
  referent type
- `read_volatile` and `write_volatile`
  - equivalent of volatile reads and writes in C or C++

<p align='right' style="float: right;"><i>Page 885</i></p>

- `drop_in_place` function is a utility that behaves like `drop(std::ptr::read(ptr))`
  - doesn't bother moving the value to its caller (and hence works on unsized types)

<p align='right' style="float: right;"><i>Page 886</i></p>

## Panic Safety in Unsafe Code

- work with unsafe code, panic safety becomes part of your job

<p align='right' style="float: right;"><i>Page 887</i></p>

- identify these sensitive regions, and ensure that they do nothing that might panic

<p align='right' style="float: right;"><i>Page 888</i></p>

## Foreign Functions: Calling C and C++ from Rust

<p align='right' style="float: right;"><i>Page 889</i></p>

## Finding Common Data Representations

- `std::os::raw` module defines a set of Rust types that are guaranteed to have the same
  representation as certain C types

<p align='right' style="float: right;"><i>Page 890</i></p>

- `#[repr(C)]` above a struct definition asks Rust to lay out the struct's fields in memory the
  same way a C compiler would

<p align='right' style="float: right;"><i>Page 891</i></p>

- each field must use the C-like type as well

<p align='right' style="float: right;"><i>Page 892</i></p>

- `#[repr(i16)]` would give you a 16-bit type with the same representation as the following C++
- enum git_error_code: `int16_t`
- `CString` and `CStr` types represent owned and borrowed null-terminated arrays of bytes

<p align='right' style="float: right;"><i>Page 893</i></p>

## Declaring Foreign Functions and Variables

- `extern` block declares functions or variables defined in some other library that the final
  Rust executable will be linked with
- `extern { fn strlen(s: *const c_char) -> usize`
- assumes that functions declared inside extern blocks use C conventions

<p align='right' style="float: right;"><i>Page 894</i></p>

- `CString::new` depends on what type you pass
- accepts anything that implements `Into<Vec<u8>>`
- passing a `String` by value simply consumes the string and takes over its buffer
- conversion requires no copying of text or allocation at all
- can also declare global variables in extern blocks
- `extern { static environ: *mut *mut c_char`

<p align='right' style="float: right;"><i>Page 896</i></p>

## Using Functions from Libraries

- `#[link]` attribute atop the `extern` block names the library Rust should link the executable
  with
- `#[link(name = "git2")]`
- `pub fn git_libgit2_init() -> c_int`
- Rust uses the system linker to build executables
- passes the argument `-lgit2` on the linker command line

<p align='right' style="float: right;"><i>Page 898</i></p>

- tell Rust where to search for libraries by writing a build script
- add a library search path to the executable's link command
- Cargo runs the _build_ script, it parses the build script's output
- `println!(r"cargo:rustc-link-search=native=homejimb/libgit2-0.25.1/build")`

<p align='right' style="float: right;"><i>Page 899</i></p>

- `build = "build.rs"`
- Linux, you must set the `LD_LIBRARY_PATH`
- macOS, you may need to set `DYLD_LIBRARY_PATH`

<p align='right' style="float: right;"><i>Page 900</i></p>

- alternative is to statically link the C library into your crate
- copies the library's object files into the crate's `.rlib` file

<p align='right' style="float: right;"><i>Page 903</i></p>

- bindgen crate
- parse C header files and generate the corresponding Rust declarations automatically

<p align='right' style="float: right;"><i>Page 907</i></p>

- `std::mem::uninitialized` function returns a value of any type you like
- value consists entirely of uninitialized bits,
- can overwrite it with `std::ptr::write`
- can pass it to `std::mem::forget`
- can pass it to a foreign function designed to initialize it

<p align='right' style="float: right;"><i>Page 913</i></p>

- `static ONCE: std::sync::Once = std::sync::ONCE_INIT`
- `ONCE.call_once(||`

<p align='right' style="float: right;"><i>Page 914</i></p>

- run initialization code in a thread-safe manner
- subsequent calls, by this thread or any other, block until the first has completed
- return immediately, without running the closure again
