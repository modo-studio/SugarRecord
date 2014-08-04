Pod::Spec.new do |s|
  s.name = 'SugarRecord'
  s.version = '0.0.1'
  s.platform = :ios, '8.0'
  s.license = 'MIT'
  s.summary = 'CoreData management library implemented with the sugar swift language'
  s.homepage = 'https://github.com/pepibumur/SugarRecord'
  s.author = { 'Pedro Piñera' => 'pepibumur@gmail.com' }
  s.source = { :git => 'https://github.com/pepibumur/SugarRecord.git', :tag => '1.4.' }
  s.description = <<-DESC
  Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions.
                    DESC
  s.requires_arc = true
  s.source_files = 'SugarRecord/*.{swift}'
  s.resources = "Control/*.ttf"
  s.exclude_files = 'SugarRecordDemo'
  s.framework = 'CoreData'
end