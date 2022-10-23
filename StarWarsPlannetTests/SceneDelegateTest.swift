//
//  SceneDelegateTest.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import UIKit

class SceneDelegateTest: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
