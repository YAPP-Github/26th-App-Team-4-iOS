//
//  UserEntity.swift
//  Domain
//
//  Created by dong eun shin on 7/4/25.
//

import Foundation

// 사용자 프로필 (온보딩 완료 여부 등 포함)
//public struct User: Codable, Equatable {
//    public let id: String
//    public let username: String
//    public let email: String?
//    public var isOnboardingCompleted: Bool // 변경 가능하도록 var로 선언
//    // ... 기타 사용자 정보
//
//    public init(id: String, username: String, email: String?, isOnboardingCompleted: Bool) {
//        self.id = id
//        self.username = username
//        self.email = email
//        self.isOnboardingCompleted = isOnboardingCompleted
//    }
//}

//public protocol UserRepositoryType {
//    func fetchUserProfile() -> Single<User>
//    func updateUserProfile(user: User) -> Single<User>
//    func completeOnboarding() -> Single<User>
//}
//
//public protocol UpdateUserProfileUseCaseType {
//    func execute(user: User) -> Single<User>
//}
//
//public final class UpdateUserProfileUseCase: UpdateUserProfileUseCaseType {
//    private let userRepository: UserRepositoryType
////    private let userSessionManager: UserSessionManagerType
//
//    public init(userRepository: UserRepositoryType) {
//        self.userRepository = userRepository
////        self.userSessionManager = userSessionManager
//    }
//
//    public func execute(user: User) -> Single<User> {
//        return userRepository.updateUserProfile(user: user)
//            .do(onSuccess: { [weak self] updatedUser in
////                self?.userSessionManager.saveUserProfile(updatedUser)
//            })
//    }
//}
