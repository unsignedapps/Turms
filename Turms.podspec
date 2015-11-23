Pod::Spec.new do |s|
  s.name         = "Turms"
  s.version      = "1.0"
  s.summary      = "Turms is a limited port of TSMessages to Swift"
  s.description  = <<-DESC
                   DESC
  s.homepage     = "https://github.com/unsignedapps/Turms"
  s.license      = "MIT"
  s.author       = "Rob Amos"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/unsignedapps/Turms.git", :tag => "v1.0" }
  s.source_files = "Turms"
  s.resource_bundles = { 'TurmsResources' => [ 'Images.xcassets/*.imageset/*.png', 'Images.xcassets' ]}
  s.frameworks   = "UIKit"
end
