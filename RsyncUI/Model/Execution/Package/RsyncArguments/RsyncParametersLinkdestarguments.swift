//
//  RsyncParametersLinkdestarguments.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 03/08/2024.
//
// swiftlint:disable line_length

import Foundation

final class RsyncParametersLinkdestarguments {
    var computedremoteargs = ""
    var linkdestparam = ""
    var offsiteCatalog = ""
    var snapshotnum = -1

    // Additional parameters if snapshot
    func linkdestparameter(verify: Bool) {
        linkdestparam = DefaultRsyncParameters.linkdest.rawValue + offsiteCatalog + String(snapshotnum - 1)
        if computedremoteargs.isEmpty == false {
            if verify {
                computedremoteargs += String(snapshotnum - 1)
            } else {
                computedremoteargs += String(snapshotnum)
            }
        }
        if verify {
            offsiteCatalog += String(snapshotnum - 1)
        } else {
            offsiteCatalog += String(snapshotnum)
        }
    }

    init(computedremoteargs: String = "", linkdestparam: String = "", offsiteCatalog: String = "", snapshotnum: Int = 1) {
        self.computedremoteargs = computedremoteargs
        self.linkdestparam = linkdestparam
        self.offsiteCatalog = offsiteCatalog
        self.snapshotnum = snapshotnum
    }
}

// swiftlint:enable line_length
