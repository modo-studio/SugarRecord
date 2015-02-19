#
# Be sure to run `pod lib lint SugarRecord.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SugarRecord"
  s.version          = "1.0.7"
  s.summary          = "CoreData management library implemented with the sugar Swift language."
  s.homepage         = "https://github.com/SugarRecord/SugarRecord"
  s.description = "Thanks to SugarRecord you'll be able to use a clean syntax to fetch, filter, create, update CoreData objects in an easy way. Inspired by MagicalRecord and opened to new contributions."
  s.license          = 'MIT'
  s.authors           = { "Pedro" => "pepibumur@gmail.com", "David" => "david@psychosity.net"}
  s.source           = { :git => "https://github.com/SugarRecord/SugarRecord.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sugarrecord'
  s.documentation_url = "https://github.com/SugarRecord/SugarRecord/wiki"
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.resource_bundles = {
    'SugarRecord' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec "Core" do  |sp|
    sp.source_files = ['Pod/Classes/Core/**/*.{swift}']
  end

  s.subspec "CoreData" do  |sp|
    sp.frameworks = 'CoreData'
    sp.dependency 'SugarRecord/Core'
    sp.source_files = ['Pod/Classes/CoreData/Base/**/*.{swift}']
    sp.subspec "RestKit" do  |spp|
      spp.dependency 'RestKit'
      spp.source_files = ['Pod/Classes/CoreData/RestKit/**/*.{swift}']
    end
  end

  s.subspec "Realm" do |sp|
    sp.dependency 'Realm'
    sp.dependency 'SugarRecord/Core'
    sp.source_files = ['Pod/Classes/Realm/**/*.{swift}']
  end
end
