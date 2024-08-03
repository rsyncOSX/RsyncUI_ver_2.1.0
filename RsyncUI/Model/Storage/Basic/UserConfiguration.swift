//
//  UserConfiguration.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 12/02/2022.
//
// swiftlint:disable cyclomatic_complexity function_body_length

import Foundation

struct UserConfiguration: Codable {
    var rsyncversion3: Int = -1
    // Detailed logging
    var addsummarylogrecord: Int = 1
    // Logging to logfile
    var logtofile: Int = 1
    // Montor network connection
    var monitornetworkconnection: Int = -1
    // local path for rsync
    var localrsyncpath: String?
    // temporary path for restore
    var pathforrestore: String?
    // days for mark days since last synchronize
    var marknumberofdayssince: String = "5"
    // Global ssh keypath and port
    var sshkeypathandidentityfile: String?
    var sshport: Int?
    // Environment variable
    var environment: String?
    var environmentvalue: String?
    // Check for error in output from rsync
    var checkforerrorinrsyncoutput: Int = -1
    // Automatic execution
    var confirmexecute: Int?

    @MainActor private func setuserconfigdata() {
        if rsyncversion3 == 1 {
            SharedReference.shared.rsyncversion3 = true
        } else {
            SharedReference.shared.rsyncversion3 = false
        }
        if addsummarylogrecord == 1 {
            SharedReference.shared.addsummarylogrecord = true
        } else {
            SharedReference.shared.addsummarylogrecord = false
        }
        if logtofile == 1 {
            SharedReference.shared.logtofile = true
        } else {
            SharedReference.shared.logtofile = false
        }
        if monitornetworkconnection == 1 {
            SharedReference.shared.monitornetworkconnection = true
        } else {
            SharedReference.shared.monitornetworkconnection = false
        }
        if localrsyncpath != nil {
            SharedReference.shared.localrsyncpath = localrsyncpath
        } else {
            SharedReference.shared.localrsyncpath = nil
        }
        if pathforrestore != nil {
            SharedReference.shared.pathforrestore = pathforrestore
        } else {
            SharedReference.shared.pathforrestore = nil
        }
        if Int(marknumberofdayssince) ?? 0 > 0 {
            SharedReference.shared.marknumberofdayssince = Int(marknumberofdayssince) ?? 0
        }
        if sshkeypathandidentityfile != nil {
            SharedReference.shared.sshkeypathandidentityfile = sshkeypathandidentityfile
        }
        if sshport != nil {
            SharedReference.shared.sshport = sshport
        }
        if environment != nil {
            SharedReference.shared.environment = environment
        }
        if environmentvalue != nil {
            SharedReference.shared.environmentvalue = environmentvalue
        }
        if checkforerrorinrsyncoutput == 1 {
            SharedReference.shared.checkforerrorinrsyncoutput = true
        } else {
            SharedReference.shared.checkforerrorinrsyncoutput = false
        }
        if confirmexecute == 1 {
            SharedReference.shared.confirmexecute = true
        } else {
            SharedReference.shared.confirmexecute = false
        }
    }

    // Used when reading JSON data from store
    @discardableResult
    @MainActor init(_ data: DecodeUserConfiguration) {
        rsyncversion3 = data.rsyncversion3 ?? -1
        addsummarylogrecord = data.addsummarylogrecord ?? 1
        logtofile = data.logtofile ?? 0
        monitornetworkconnection = data.monitornetworkconnection ?? -1
        localrsyncpath = data.localrsyncpath
        pathforrestore = data.pathforrestore
        marknumberofdayssince = data.marknumberofdayssince ?? "5"
        sshkeypathandidentityfile = data.sshkeypathandidentityfile
        sshport = data.sshport
        environment = data.environment
        environmentvalue = data.environmentvalue
        checkforerrorinrsyncoutput = data.checkforerrorinrsyncoutput ?? -1
        confirmexecute = data.confirmexecute ?? -1
        // Set user configdata read from permanent store
        setuserconfigdata()
    }

    // Default values user configuration
    @discardableResult
    @MainActor init() {
        if SharedReference.shared.rsyncversion3 {
            rsyncversion3 = 1
        } else {
            rsyncversion3 = -1
        }
        if SharedReference.shared.addsummarylogrecord {
            addsummarylogrecord = 1
        } else {
            addsummarylogrecord = -1
        }
        if SharedReference.shared.logtofile {
            logtofile = 1
        } else {
            logtofile = -1
        }
        if SharedReference.shared.monitornetworkconnection {
            monitornetworkconnection = 1
        } else {
            monitornetworkconnection = -1
        }
        if SharedReference.shared.localrsyncpath != nil {
            localrsyncpath = SharedReference.shared.localrsyncpath
        } else {
            localrsyncpath = nil
        }
        if SharedReference.shared.pathforrestore != nil {
            pathforrestore = SharedReference.shared.pathforrestore
        } else {
            pathforrestore = nil
        }
        marknumberofdayssince = String(SharedReference.shared.marknumberofdayssince)
        if SharedReference.shared.sshkeypathandidentityfile != nil {
            sshkeypathandidentityfile = SharedReference.shared.sshkeypathandidentityfile
        }
        if SharedReference.shared.sshport != nil {
            sshport = SharedReference.shared.sshport
        }
        if SharedReference.shared.environment != nil {
            environment = SharedReference.shared.environment
        }
        if SharedReference.shared.environmentvalue != nil {
            environmentvalue = SharedReference.shared.environmentvalue
        }
        if SharedReference.shared.checkforerrorinrsyncoutput == true {
            checkforerrorinrsyncoutput = 1
        } else {
            checkforerrorinrsyncoutput = -1
        }
        if SharedReference.shared.confirmexecute == true {
            confirmexecute = 1
        } else {
            confirmexecute = -1
        }
    }
}

// swiftlint:enable cyclomatic_complexity function_body_length
