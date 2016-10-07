require_relative 'danger/deployment_target_checker'

# Utils
has_library_changes = !git.modified_files.grep(/CarambaKit/).empty?

# Changelog
if !git.modified_files.include?("CHANGELOG.md") && has_library_changes
  fail("Please include a CHANGELOG entry. \n")
end

# The coding love
the_coding_love.random

# Junit
junit.parse "fastlane/test_output/report.junit"
junit.report

# Plugins

def evaluate(&block)
  result = block.call
  if result.result_type == :ok
    git.info(result.message)
  elsif result.result_type == :warning
    git.warn(result.message)
  else
    git.fail(result.message)
  end
end 
 

evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'iOSRealm', :ios, 'SugarRecord.podspec', "SugarRecord/Realm") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'iOSCoreData', :ios, 'SugarRecord.podspec', "SugarRecord/CoreData") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'watchOSRealm', :ios, 'SugarRecord.podspec', "SugarRecord/Realm") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'watchOSCoreData', :ios, 'SugarRecord.podspec', "SugarRecord/CoreData") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'tvOSRealm', :ios, 'SugarRecord.podspec', "SugarRecord/Realm") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'tvOSCoreData', :ios, 'SugarRecord.podspec', "SugarRecord/CoreData") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'macOSRealm', :ios, 'SugarRecord.podspec', "SugarRecord/Realm") } 
evaluate { Danger::Plugins::DeploymentTargetChecker.new('Carthage.xcodeproj', 'macOSCoreData', :ios, 'SugarRecord.podspec', "SugarRecord/CoreData") } 
