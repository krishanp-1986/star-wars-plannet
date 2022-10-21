//
//  BaseViewController.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import UIKit

class BaseViewController<VM>: UIViewController, BindableType {
    var viewModel: VM?
    
    override func loadView() {
        super.loadView()
    }
    
    func bind() {
        assertionFailure("Subclass must override")
    }
}
