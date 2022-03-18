//
//  AppDelegate.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var router: Routing = Router(window)

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        router.start()

        return true
    }

    func applicationDidEnterBackground(_: UIApplication) {
        router.enterBackground()
    }

    func applicationWillEnterForeground(_: UIApplication) {
        router.enterForeground()
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if router.canHandle(url) {
            router.handle(url)
            return true
        } else {
            return false
        }
    }
}
