//
//  LoadingView.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 21/01/2024.
//

import UIKit

class LoadingView: UIView {
    let loadingIndicator = UIActivityIndicatorView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        loadingIndicator.style = .large
        loadingIndicator.startAnimating()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func constraints(){
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
