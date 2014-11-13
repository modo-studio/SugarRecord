Pod::Spec.new do |s|
  s.name = 'SugarRecord'
  s.version = '1.0.0'
  s.platform = :ios, '7.0'
  s.license = 'MIT'
  s.summary = 'CoreData management library implemented with the sugar swift language'
  s.homepage = 'https://github.com/SugarRecord/SugarRecord'
  s.author = { 'Pedro Piñera' => 'pepibumur@gmail.com' }
  s.social_media_url = "https://twitter.com/pepibumur"
  s.source = { :git => 'https://github.com/SugarRecord/SugarRecord.git', :tag => '1.0.0' }
  s.description = <<-DESC
  Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions.
                    DESC
  s.requires_arc = true
  s.source_files = 'SugarRecord/*.{swift}'
  s.resources = "Control/*.ttf"
  s.exclude_files = 'SugarRecordDemo'
  s.framework = 'CoreData'
  s.requires_arc =  true

  realm       = { :spec_name => "CoreData"} ## Pending to review
  coredata     = { :spec_name => "Realm"} ## Pending to review
end