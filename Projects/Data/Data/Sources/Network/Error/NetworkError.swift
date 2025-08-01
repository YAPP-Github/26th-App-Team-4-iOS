//
//  NetworkError.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
  case unknown
  case noInternetConnection
  case custom(code: Int, message: String)
  case decodingError(Error)
  case unauthorized // 401
  case forbidden // 403
  case notFound // 404
  case serverError(statusCode: Int) // 5xx
  case badRequest // 400
  case redirection(statusCode: Int) // 3xx
  
  public var errorDescription: String? {
    switch self {
    case .unknown: return "알 수 없는 오류가 발생했습니다."
    case .noInternetConnection: return "인터넷 연결을 확인해주세요."
    case .custom(_, let message): return message
    case .decodingError(let error): return "데이터 디코딩에 실패했습니다: \(error.localizedDescription)"
    case .unauthorized: return "인증 정보가 만료되었거나 유효하지 않습니다. 다시 로그인해주세요."
    case .forbidden: return "접근 권한이 없습니다."
    case .notFound: return "요청한 리소스를 찾을 수 없습니다."
    case .serverError(let statusCode): return "서버 오류가 발생했습니다. (상태 코드: \(statusCode))"
    case .badRequest: return "잘못된 요청입니다."
    case .redirection(let statusCode): return "리다이렉션 오류가 발생했습니다. (상태 코드: \(statusCode))"
    }
  }
  
  public var errorCode: Int? {
    switch self {
    case .custom(let code, _): return code
    case .serverError(let statusCode): return statusCode
    case .redirection(let statusCode): return statusCode
    default: return nil
    }
  }
}

public enum SocialLoginError: Error, LocalizedError {
  case authenticationFailed(Error) // 인증 실패 (SDK 내부 에러 포함)
  case cancelled // 사용자 취소
  case idTokenNotFound // ID 토큰을 찾을 수 없음
  case decodingFailed // 디코딩 실패
  case unknown(String) // 알 수 없는 오류

  public var errorDescription: String? {
    switch self {
    case .authenticationFailed(let error):
      return "인증에 실패했습니다: \(error.localizedDescription)"
    case .cancelled:
      return "로그인이 취소되었습니다."
    case .idTokenNotFound:
      return "성공적으로 인증되었으나 ID 토큰을 찾을 수 없습니다."
    case .decodingFailed:
      return "ID 토큰 디코딩에 실패했습니다."
    case .unknown(let message):
      return "알 수 없는 오류가 발생했습니다: \(message)"
    }
  }
}
