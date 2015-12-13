# Contributing Guidelines

> Inspired from [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/CONTRIBUTING.md) and [Alamofire](https://github.com/Alamofire/Alamofire/blob/master/CONTRIBUTING.md) guidelines.

This document contains information and guidelines about contributing to this project.
Please read it before you start participating.

**Topics**

* [Asking Questions](#asking-questions)
* [Reporting Security Issues](#reporting-security-issues)
* [Reporting Issues](#reporting-other-issues)
* [Contributing with code](#contributing-with-code)
* [Developers Certificate of Origin](#developers-certificate-of-origin)
* [Code of Conduct](#code-of-conduct)

## Asking Questions

We don't use GitHub as a support forum.
For any usage questions that are not specific to the project itself,
please ask on [Stack Overflow](https://stackoverflow.com) instead.
By doing so, you'll be more likely to quickly solve your problem,
and you'll allow anyone else with the same question to find the answer.
This also allows maintainers to focus on improving the project for others.


## Reporting Other Issues

A great way to contribute to the project
is to send a detailed issue when you encounter an problem.
We always appreciate a well-written, thorough bug report.

Check that the project issues database
doesn't already include that problem or suggestion before submitting an issue.
If you find a match, add a quick "+1" or "I have this problem too."
Doing this helps prioritize the most common problems and requests.

When reporting issues, please include the following:

* The version of Xcode you're using
* The version of iOS or OS X you're targeting
* The full output of any stack trace or compiler error
* A code snippet that reproduces the described behavior, if applicable
* Any other details that would be useful in understanding the problem

This information will help us review and fix your issue faster.

## Prefer Pull Requests

If you know exactly how to implement the feature being suggested or fix the bug
being reported, please open a pull request instead of an issue. Pull requests are easier than
patches or inline code blocks for discussing and merging the changes.

If you can't make the change yourself, please open an issue after making sure
that one isn't already logged.

## Contributing Code

Fork this repository, make it awesomer (preferably in a branch named for the
topic), send a pull request!

All code contributions should match our [coding
conventions](https://swift.org/documentation/api-design-guidelines.html).

Thanks for contributing! :boom::camel:

## Contributing with code

### PR requirements
- Every PR proposing a feature or a bug fixing must include **unit tests**
- CI integration script must pass *(it's currently Travis)*
- Components must be marked as public/private/internal/final depending on its scope

### Rake tasks
In order to simplify some tasks there's a set of tasks defined in a `Makefile` that you can use:
- Build all schemes: `make ci`
- Run tests: `make test`

### New version checklist
- [x] `make ci` passes.
- [x] `make tests` passes.
- [x] Bump the version in project targets.
- [x] Bump the version in `SugarRecord.podspec`.
- [x] Close the issues that have been fixed.
- [x] Tag the last commit with the proper version.
- [x] Create a **Release** entry on Github and update the CHANGELOG.md document.
- [x] Archive Carthage framework and upload it with the Release on Github.

### Public / Private / Internal / Final

- **Public**: Mark as public all the components that will be used by the consumer of the library. In case you have doubts if it should or shouldn't be public think about yourself using SugarRecord and using that component. What if it wasn't public?
- **Internal**: Default visibility *(also by default in Swift)*. If the component is going to be used internally and *has to be tested* make it internal. Be careful because it's the default visibility and you might leave it as an internal and even test it but when any developer tries to use it he can't...
- **Private**: If the component doesn't have to be exposed out of your framework scope and you don't have to test it make it private. An example of private components are constants.
- **Final**: If the class shouldn't be extendible, don't forget specifying it with the *final* keyword.

## Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

- (a) The contribution was created in whole or in part by me and I
      have the right to submit it under the open source license
      indicated in the file; or

- (b) The contribution is based upon previous work that, to the best
      of my knowledge, is covered under an appropriate open source
      license and I have the right under that license to submit that
      work with modifications, whether created in whole or in part
      by me, under the same open source license (unless I am
      permitted to submit under a different license), as indicated
      in the file; or

- (c) The contribution was provided directly to me by some other
      person who certified (a), (b) or (c) and I have not modified
      it.

- (d) I understand and agree that this project and the contribution
      are public and that a record of the contribution (including all
      personal information I submit with it, including my sign-off) is
      maintained indefinitely and may be redistributed consistent with
      this project or the open source license(s) involved.

## Code of Conduct

The Code of Conduct governs how we behave in public or in private
whenever the project will be judged by our actions.
We expect it to be honored by everyone who contributes to this project.

See [CONDUCT.md](https://github.com/SwiftReactive/ReactiveCommander/blob/master/CONDUCT.md) for details.

---

*Some of the ideas and wording for the statements above were based on work by the [Docker](https://github.com/docker/docker/blob/master/CONTRIBUTING.md) and [Linux](http://elinux.org/Developer_Certificate_Of_Origin) communities. We commend them for their efforts to facilitate collaboration in their projects.*
