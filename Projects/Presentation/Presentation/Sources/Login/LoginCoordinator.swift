//
//  LoginCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import RxSwift

public protocol LoginCoordinatorDelegate: AnyObject {
    func didLoginSuccessfully(from coordinator: LoginCoordinator)
}

public final class LoginCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var delegate: LoginCoordinatorDelegate?
    private let resolver: Resolver
    private let disposeBag = DisposeBag()

    public init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    public func start() {
        let viewController = resolver.resolve(LoginViewController.self)!
        viewController.reactor?.state.map { $0.isLoginSuccess }
            .filter { $0 }
            .take(1)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didLoginSuccessfully(from: self)
            })
            .disposed(by: disposeBag)

        navigationController.setViewControllers([viewController], animated: true)
    }
}
