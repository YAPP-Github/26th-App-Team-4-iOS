//
//  HomeUseCase.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import RxSwift

public protocol HomeUseCase {
  func fetchHomeData() -> Single<HomeInfo>
}

public class HomeUseCaseImpl: HomeUseCase {
  
  private let homeRepository: HomeRepository
  
  public init(homeRepository: HomeRepository) {
    self.homeRepository = homeRepository
  }
  
  public func fetchHomeData() -> Single<HomeInfo> {
    return homeRepository.fetchHomeData()
  }
}
