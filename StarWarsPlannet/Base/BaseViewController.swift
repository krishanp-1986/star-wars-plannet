//
//  BaseViewController.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import UIKit
import RxSwift

class BaseViewController<VM>: UIViewController, BindableType {
    var viewModel: VM?
    lazy var disposeBag: DisposeBag = .init()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = DesignSystem.shared.colors.backgroundPrimary
    }
    
    func bind() {
        assertionFailure("Subclass must override")
    }
    
    func shouldShowLoading(_ isLoading: Bool) {
        if isLoading {
            if self.loadingIndicatorView.superview != nil { return }
            self.view.addSubview(loadingIndicatorView)
            loadingIndicatorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            self.loadingIndicatorView.removeFromSuperview()
        }
    }
    
    func displayBasicAlert(for title: String = "Error", message: String) {
        let alertViewController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private lazy var loadingIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.8)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .white
        activityIndicator.startAnimating()
        
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return view
    }()
}
