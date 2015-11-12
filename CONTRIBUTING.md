How to contribute with SugarRecord
========
If you're planning to contribute with SugarRecord there're some things you should keen in mind in order to align your contributions with the framework and its guidelines.

## PR Requirements
- Every PR proposing a feature or a bug fixing must include **unit tests**
- CI integration script must pass *(it's currently Travis)*
- Components must be marked as public/private/internal/final depending on its scope

## Rake tasks
In order to simplify some tasks there's a set of tasks defined in a `Makefile` that you can use:

- Generate documentation: `make doc`
- Build all schemes: `make build`
- Run tests: `make test`

## New version checklist
- [x] `make build` passes
- [x] `make tests` passes
- [x] Bump the version in project targets
- [x] Bump the version in `SugarRecord.podspec`
- [x] Tag the last commit with the proper version
- [x] Create a **Release** entry on Github


## Public / Private / Internal / Final

- **Public**: Mark as public all the components that will be used by the consumer of the library. In case you have doubts if it should or shouldn't be public think about yourself using SugarRecord and using that component. What if it wasn't public?
- **Internal**: Default visibility *(also by default in Swift)*. If the component is going to be used internally and *has to be tested* make it internal. Be careful because it's the default visibility and you might leave it as an internal and even test it but when any developer tries to use it he can't...
- **Private**: If the component doesn't have to be exposed out of your framework scope and you don't have to test it make it private. An example of private components are constants.
- **Final**: If the class shouldn't be extendible, don't forget specifying it with the *final* keyword.


## Others
- Swift Style guideline: [RayWenderlich](https://github.com/raywenderlich/swift-style-guide)
