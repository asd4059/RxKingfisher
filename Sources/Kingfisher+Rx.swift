//
//  RxKingfisher.swift
//  RxKingfisher
//
//  Created by Shai Mishali on 5/5/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: KFCrossPlatformImageView {
    public func kfSetImage(with source: Source?,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil) -> Single<Image> {
        Single.create { [base] single in
            let task = base.kf.setImage(with: source,
                                     placeholder: placeholder,
                                     options: options) { result in
                switch result {
                case .success(let value):
                    single(.success(value.image))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create { task?.cancel() }
        }
    }
    
    public func kfSetImage(with resource: Resource?,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil) -> Single<Image> {
        let source: Source?
        if let resource = resource {
            source = Source.network(resource)
        } else {
            source = nil
        }
        return kfSetImage(with: source, placeholder: placeholder, options: options)
    }

    public func kfImage(placeholder: Placeholder? = nil,
                      options: KingfisherOptionsInfo? = nil) -> Binder<Resource?> {
        // `base.base` is the `Kingfisher` class' associated `ImageView`.
        Binder(base) { imageView, image in
            imageView.kf.setImage(with: image,
                                  placeholder: placeholder,
                                  options: options)
        }
    }
}
