//
//  SceneDelegate.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let vc1 = ShoppingSearchViewController()
        let vc2 = LikeListViewController()
        
        let searchVC = UINavigationController(rootViewController: vc1)
        let listVC = UINavigationController(rootViewController: vc2)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .black
        tabBarController.setViewControllers([searchVC, listVC], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].image = UIImage(systemName: ButtonImageName.shared.magnifyingglassNone)
            items[0].selectedImage = UIImage(systemName: ButtonImageName.shared.magnifyingglassSelected)
            items[0].title = "검색"
            
            items[1].image = UIImage(systemName: ButtonImageName.shared.heartNone)
            items[1].image = UIImage(systemName: ButtonImageName.shared.heartSelected)
            items[1].title = "좋아요"
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

