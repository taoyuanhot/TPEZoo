//
//  AppDelegate.swift
//  TPEZoo
//
//  Created by 藍景鴻 on 2024/1/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("開始didFinishLaunchingWithOptions")
        
        let jsonModuleZoo = MyJsonModuleZoo()
//        jsonModuleZoo.fetchDataFromAPI {
//            jsonModuleZoo.saveDataLocally(jsonModuleZoo.myZooData!)
//        }
        
        jsonModuleZoo.fetchDataFromAPI {
            DispatchQueue.main.async {
                jsonModuleZoo.saveDataLocally(jsonModuleZoo.myZooData!)
            }
        }
        
        
        let jsonModuleAnimal = MyJsonModuleAnimal()
//        jsonModuleAnimal.fetchDataFromAPI {
//            jsonModuleAnimal.saveDataLocally(jsonModuleAnimal.myAnimalData!)
//        }
        
        jsonModuleAnimal.fetchDataFromAPI {
            DispatchQueue.main.async {
                jsonModuleAnimal.saveDataLocally(jsonModuleAnimal.myAnimalData!)
            }
            
        }
        
        print("結束didFinishLaunchingWithOptions")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

