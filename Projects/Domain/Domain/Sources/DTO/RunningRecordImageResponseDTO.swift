//
//  RunningRecordImageResponseDTO.swift
//  Domain
//
//  Created by dong eun shin on 8/14/25.
//

import Foundation

public struct RunningRecordImageResponseDTO: Codable {
    public let imageUrl: String
    public let recordId: Int
    public let userId: Int
}
