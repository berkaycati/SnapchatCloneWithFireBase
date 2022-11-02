//
//  userSingleton.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 24.10.2022.
//

import Foundation

class UserSingleton {
    
    static let sharedInfo = UserSingleton()
    
    var email = ""
    var nickname = ""
    
    
    private init() {
        
    }
}
