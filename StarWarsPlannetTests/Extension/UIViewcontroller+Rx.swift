//
//  UIViewcontroller+Rx.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-24.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxCocoa

@testable import StarWarsPlannet

class UIViewcontroller_Rx: QuickSpec {
    
    override func spec() {
        describe("UIViewcontroller reactive extenision") {
            context("viewDidLoad event") {
                it("should emit when view loaded") {
                    let viewController = UIViewController()
                    let disposeBag: DisposeBag = .init()
                    var viewDidLoaded = false
                    viewController.rx.viewDidLoaded.subscribe { _ in
                        viewDidLoaded = true
                    }.disposed(by: disposeBag)
                    
                    viewController.viewDidLoad()
                    expect(viewDidLoaded).to(beTrue())
                }
            }
        }
    }
}
