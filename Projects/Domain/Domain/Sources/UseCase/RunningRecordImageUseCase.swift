//
//  RunningRecordImageUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import NMapsMap

public protocol RunningRecordImageUseCase {
    func captureMapImage(from view: UIView) -> Single<UIImage>
    func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?>
}

public final class RunningRecordImageUseCaseImpl: RunningRecordImageUseCase {
    private let runningRepository: RunningRepository

    public init(runningRepository: RunningRepository) {
        self.runningRepository = runningRepository
    }

    public func captureMapImage(from view: UIView) -> Single<UIImage> {
        return Single.create { single in
            print("[captureMapImage] 렌더링 완료 후 캡처 시도")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let image = view.asImage() {
                    print("[captureMapImage] 캡처 성공")
                    single(.success(image))
                } else {
                    print("[captureMapImage] 캡처 실패")
                    single(.failure(NSError(domain: "ImageCaptureError", code: 0)))
                }
            }
            return Disposables.create()
        }
    }

    public func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?> {
        runningRepository.saveRunningRecordImage(recordId: recordId, image: image)
    }
}

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
