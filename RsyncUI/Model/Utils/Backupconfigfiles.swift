//
//  Backupconfigfiles.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 09/10/2020.
//  Copyright © 2020 Thomas Evensen. All rights reserved.
//
// swiftlint:disable opening_brace

import Foundation
import SwiftUI

@MainActor
final class Backupconfigfiles: PropogateError {
    var fullpathnomacserial: String?
    var backuppath: String?

    func backup() {
        let fm = FileManager.default
        if let backuppath,
           let fullpathnomacserial
        {
            let fullpathnomacserialURL = URL(fileURLWithPath: fullpathnomacserial)
            let targetpath = "RsyncUIcopy-" + Date().shortlocalized_string_from_date()
            let documentsURL = URL(fileURLWithPath: backuppath)
            let documentsbackuppathURL = documentsURL.appendingPathComponent(targetpath)
            do {
                try fm.copyItem(at: fullpathnomacserialURL, to: documentsbackuppathURL)
            } catch let e {
                let error = e
                propogateerror(error: error)
            }
        }
    }

    init() {
        let homepath = Homepath()
        fullpathnomacserial = homepath.fullpathnomacserial
        backuppath = homepath.documentscatalog
        backup()
    }
}

// swiftlint:enable opening_brace
