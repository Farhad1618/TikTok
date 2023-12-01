//
//  AuthServiceProtocol.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

protocol AuthServiceProtocol {
    func login(withEmail email: String, password: String) async throws
    func createUser(withEmail email: String, password: String, username: String) async throws
    func signout() 
}
