//
//  ContentViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Combine
import Firebase

@MainActor
class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private let userService: UserService
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        
        authService.updateUserSession()
        
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        authService.$userSession.sink { [weak self] session in
            self?.userSession = session
            self?.fetchCurrentUser()
        }.store(in: &cancellables)
    }
    
    func fetchCurrentUser() {
        guard userSession != nil else { return }
        Task { self.currentUser = try await userService.fetchCurrentUser() }
    }
}
