def commonPods
  pod 'SnapKit'
  pod 'SwiftLint'
end

def testingPods
  pod 'Nimble'
  pod 'Quick'
end

target 'StarWarsPlannet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  commonPods
  # Pods for StarWarsPlannet

  target 'StarWarsPlannetTests' do
    inherit! :search_paths
    testingPods
  end

  target 'StarWarsPlannetUITests' do
    # Pods for testing
  end

end
