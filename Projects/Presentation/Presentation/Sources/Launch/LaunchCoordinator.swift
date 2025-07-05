//
//  LaunchCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import RxSwift
import Domain

public protocol LaunchCoordinatorDelegate: AnyObject {
    func didFinishLaunch(with status: UserStatus, from coordinator: LaunchCoordinator)
}

public final class LaunchCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var delegate: LaunchCoordinatorDelegate?
    private let resolver: Resolver
    private let disposeBag = DisposeBag()

    public init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    public func start() {
        // LaunchViewController 생성 및 Reactor 주입
        let viewController = resolver.resolve(LaunchViewController.self)!
        // Reactor는 이미 Assembly에서 주입되도록 구성되어 있음
        viewController.reactor?.state.compactMap { $0.initialFlow }
            .take(1) // 한 번만 처리
            .bind(onNext: { [weak self] status in
                guard let self = self else { return }
                self.delegate?.didFinishLaunch(with: status, from: self)
            })
            .disposed(by: disposeBag)

        navigationController.pushViewController(viewController, animated: false)
    }
}
