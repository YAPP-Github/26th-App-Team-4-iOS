//
//  HomeUseCase.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import RxSwift

protocol HomeUseCase {
  func fetchHomeData() async throws -> Single<HomeInfo>
}

class HomeUseCaseImpl: HomeUseCase {
  
  private let homeRepository: HomeRepository
  
  init(homeRepository: HomeRepository) {
    self.homeRepository = homeRepository
  }
  
  func fetchHomeData() async throws -> Single<HomeInfo> {
    return homeRepository.fetchHomeData()
  }
}
