require 'xcjobs'

def destinations
  [ 'name=iPhone 5s,OS=8.1' ]
end

XCJobs::Build.new('build:ios') do |t|
  t.workspace = 'example/SugarRecordExample'
  t.scheme = 'SugarRecordExample'
  t.sdk = 'iphonesimulator'
  t.configuration = 'Debug'
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
end

XCJobs::Test.new('test:ios') do |t|
  t.workspace = 'project/project'
  t.scheme = 'project'
  t.configuration = 'Debug'
  t.build_dir = 'build'
  destinations.each do |destination|
    t.add_destination(destination)
  end
  t.formatter = 'xcpretty -c'
end