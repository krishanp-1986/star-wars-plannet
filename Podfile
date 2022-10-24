def commonPods
  pod 'SnapKit'
  pod 'SwiftLint'
end

def reactivePods
  pod 'RxSwift'
  pod 'RxCocoa'
end

def testingPods
  pod 'Nimble'
  pod 'Quick'
  pod 'RxTest'
end

target 'StarWarsPlannet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  commonPods
  reactivePods
  # Pods for StarWarsPlannet

  target 'StarWarsPlannetTests' do
    inherit! :search_paths
    testingPods
  end

end
