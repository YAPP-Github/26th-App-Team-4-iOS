//
//  WalkthroughCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import RxSwift

public protocol WalkthroughCoordinatorDelegate: AnyObject {
    func didCompleteWalkthrough(from coordinator: WalkthroughCoordinator)
}

public final class WalkthroughCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var delegate: WalkthroughCoordinatorDelegate?
    private let resolver: Resolver
    private let disposeBag = DisposeBag()

    public init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    public func start() {
        let viewController = resolver.resolve(WalkthroughViewController.self)!
        // Reactor의 "완료" 액션 구독
        viewController.reactor?.state.compactMap { $0.didComplete }
            .filter { $0 }
            .take(1)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 워크스루 완료 시 UserDefault에 저장 (AppCoordinator의 UseCase가 참조)
                UserDefaults.standard.set(true, forKey: "hasCompletedWalkthrough")
                self.delegate?.didCompleteWalkthrough(from: self)
            })
            .disposed(by: disposeBag)

        navigationController.setViewControllers([viewController], animated: true) // 이전 스택 제거
    }
}

// WalkthroughViewController, WalkthroughReactor는 간단하게 "완료" 버튼 액션만 가진다고 가정
// Targets/Presentation/WalkthroughPresentation/Sources/WalkthroughViewController.swift
// Targets/Presentation/WalkthroughPresentation/Sources/WalkthroughReactor.swift
