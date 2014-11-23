If you want to contribute with the library solving any issue, proposing a new feature or even adding your custom modifications it's important to keep the following subtopics in mind that will help you to setup the project locally and follow different guidelines related with the style, testing, and documentation.

## Setup the project locally

To setup the project locally you've just to follow the simple steps below:

1. Clone the repo with `git clone https://github.com/SugarRecord/SugarRecord.git`
2. Update the git submodules with `git submodule update --init`
3. Execute `pod install` in the `project/` folder

Once done, open the project using the `.xcworkspace` file in the `/project` folder.

## Project structure

The project is organized in the following schemes:

- **SugarRecordTests:** *Testing target*. Includes all project files and dependency frameworks like Restkit, Realm, ... In case you add new files to the project you must ensure those files are included in the target **SugarRecordTest**. This target is only for testing so you can't either run or build there.
- **SRCoreData:**  *Framework target*. Includes all the library files related with CoreData (stacks, extensions, ...). New files related with CoreData should be added to this target (apart from the **SugarRecordTests** target)
- **SRRealm:** *Framework target*. Includes all the library files related with Realm (stacks, extensions, ...). New files related with Realm should be added to this target (apart from the **SugarRecordTests** target). *Note: This target is liked with the Realm library which is downloaded through **git submodules** and added as .framework*

## Testing

Any new feature/modification should be tested. Tests ensure that the code behaves regarding the expectations and that nothing is broken after changing other components. SugarRecord uses directly XCTest for testing without any library for expectations nor mocking. This way the framework doesn't depend on any existing framework but the native one and we can easily stick to the future Apple updates.

*Note: We recommend you to apply TDD when you develop a new feature. Think about what you are planning to add, and then about the logic that should manage the feature you thought about*

## Documentation

- The best way to follow the docummentation patterns is using the plugin for XCode VVDocumenter.
- Ensure that any new class/method/.. is properly comented explaining its purpose as well as the input and return parameters.
- We are planning to support CocoaDocs but there's no suppor yet [WIP]
```bash
# Clone the repo
git clone https://github.com/CocoaPods/cocoadocs.org
# Run in the repo directory
bundle install
# Preview the library with
bundle exec ./cocoadocs.rb preview SugarRecord
```

## PR Requirements

- It *has to* do what it's expected to do.
- It *has to* have tests for the modified/added behaviours
- It *has to* have a detailed PR explaining the why and what of the PR. In case of being related with an issue, that issue should be attached too.
- It *has to* be attached to the last available  milestone (*that in most of cases will be related with the next version to be released*)
- It *hast to* have a code that follows that Swift Style guideline: https://github.com/SugarRecord/swift-style-guide


## Issues/PR Management

In the SugarRecord project we use the issues feature to reflect not only bugs bug new features, proposals and ideas coming from the users. Once created we **assign them labels** related with the *priority, type of issue, status and difficulty*, why? It's pretty simple, this way if anyone wants to contribute with the library he/she  can filter using those labels, for example getting the easy to fix bugs, or new feautures coming.

Once you decide start working in an issue **you should assign it yourself**. Assigment is a good way to track *who is working on what*.

**Use the issues** to reflect any change of itself status, something blocking?, doubts?, ... Think on it as a task which you are working on.
