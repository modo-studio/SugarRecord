ci:
	set -o pipefail && xcodebuild build -project SugarRecord.xcodeproj -scheme "SugarRecord-iOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SugarRecord.xcodeproj -scheme "SugarRecord-OSX" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SugarRecord.xcodeproj -scheme "SugarRecord-tvOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SugarRecord.xcodeproj -scheme "SugarRecord-watchOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
test:
	set -o pipefail && xcodebuild clean test -project SugarRecord.xcodeproj -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.1' -scheme "SugarRecord-iOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
