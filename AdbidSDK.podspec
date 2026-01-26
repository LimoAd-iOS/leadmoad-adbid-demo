Pod::Spec.new do |spec|
  spec.name         = "AdbidSDK"
  spec.version      = "0.1.5"
  spec.summary      = "Adbid广告SDK"
  spec.description  = <<-DESC
                    Adbid广告SDK提供了广告展示和管理功能
                   DESC
  spec.homepage     = "https://github.com/LimoAd-iOS/leadmoad-adbid-demo"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "your.email@example.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/LimoAd-iOS/leadmoad-adbid-pods.git", :tag => "#{spec.version}" }
  spec.source_files = "AdbidSDK/**/*.{h,m,swift}"
  spec.public_header_files = "AdbidSDK/API/**/*.h"
  spec.swift_version = "5.0"
  spec.frameworks   = "UIKit", "Foundation"
  # 指定不使用ARC的文件
  spec.requires_arc = true
  spec.subspec 'NoARC' do |noarc|
    noarc.source_files = 'AdbidSDK/Core/Utility/LeadmoadBase64.{h,m}',"AdbidSDK/Core/Utility/LeadmoadBase64Defines.{h}"
    noarc.requires_arc = false
  end
end
