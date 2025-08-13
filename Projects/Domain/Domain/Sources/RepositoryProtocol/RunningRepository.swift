//
//  RunningRepository.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningRepository {
  // 도메인 계층이 의존하는 추상화이므로, DTO가 아닌 도메인 객체를 반환하도록 수정합니다.
  func startRun(startLocation: CLLocation, timeStamp: Date) -> Single<Int?>
  // DTO 대신 도메인 모델을 받도록 수정
  func completeRun(recordId: Int, completionData: RunningCompletionData) -> Single<Bool>
}
