//
//  main.swift
//  Window Manager Control
//
//  Created by Erin Fitton on 14/02/2023.
//

import Foundation
import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()

app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
