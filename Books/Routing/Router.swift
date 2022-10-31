//
//  Router.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import UIKit

class Router: Routing {
    private weak var window: UIWindow?

    private lazy var splash = SplashViewController()

    private var dependencies: DependenciesInterface?

    private var listViewController: ListViewController? {
        guard let navController = window?.rootViewController as? UINavigationController else {
            return nil
        }
        return navController.viewControllers.first as? ListViewController
    }

    // MARK: - Initialization

    required init(_ window: UIWindow?) {
        self.window = window
    }

    func start() {
        guard let window = window else {
            return
        }

        window.backgroundColor = .white
        window.rootViewController = splash
        window.makeKeyAndVisible()

        let group = DispatchGroup()

        group.enter()
        let persistency = Persistency(completion: {
            group.leave()
        })

        group.enter()
        let apiClient = APIClient(completion: {
            group.leave()
        })

        group.notify(queue: .main) {
            self.dependencies = Dependencies(persistency: persistency, apiClient: apiClient, router: self)
            self.moveOnFromSplash()
        }
    }

    func enterForeground() {
        //
    }

    func enterBackground() {
        //
    }

    private func moveOnFromSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.moveToMainViewController()
        }
    }

    private func moveToMainViewController() {
        let viewController = ListViewController(dependencies: dependencies!)

        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController

//        resolvePendingURL()
    }

    private func hasMovedToMainViewController() -> Bool {
        return listViewController != nil
    }

    // MARK: - Route & URL handling

    func canHandle(_: URL) -> Bool {
        return false
    }

    func handle(_: URL) {
        //
    }

    func handle(_: Route) {
//        guard let viewController = window?.rootViewController as? ViewController else {
//            return
//        }
//
        //
    }
}
