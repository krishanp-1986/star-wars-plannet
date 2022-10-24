//
//  main.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("AppDelegateTest") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
