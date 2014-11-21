# Contribution

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
- **SRCoreData:**
- **SRRealm:**

## Testing


## Documentation


## Issues/PR Management