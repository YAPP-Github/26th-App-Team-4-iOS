//
//  LaunchScreenViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

// Features/Launch/LaunchReactor.swift
import ReactorKit
import RxSwift

//final class LaunchReactor: Reactor {
//    enum Action {
//        case checkAppStatus // 앱 상태 확인 시작
//    }
//
//    enum Mutation {
//        case setLoading(Bool)
//        case setNextFlow(UserStatus) // 다음 흐름 결정
//    }
//
//    struct State {
//        var isLoading: Bool = true
//        var nextFlow: UserStatus?
//    }
//
//    let initialState = State()
//
//    private let checkUserStatusUseCase: CheckUserStatusUseCaseType
//
//    init(checkUserStatusUseCase: CheckUserStatusUseCaseType) {
//        self.checkUserStatusUseCase = checkUserStatusUseCase
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .checkAppStatus:
//            return Observable.concat([
//                .just(.setLoading(true)),
//                checkUserStatusUseCase.execute()
//                    .asObservable()
//                    .map { .setNextFlow($0) }
//                    .catch { error in
//                        // 에러 발생 시, 기본적으로 로그인/회원가입 화면으로 이동
//                        print("LaunchReactor Error: \(error.localizedDescription)")
//                        return .just(.setNextFlow(.needsRegistrationOrLogin))
//                    },
//                .just(.setLoading(false))
//            ])
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//        switch mutation {
//        case let .setLoading(isLoading):
//            newState.isLoading = isLoading
//        case let .setNextFlow(flow):
//            newState.nextFlow = flow
//        }
//        return newState
//    }
//}
