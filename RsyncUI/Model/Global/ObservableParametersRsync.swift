//
//  ObservableParametersRsync.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 20/03/2021.
//

import Foundation
import Observation

@Observable @MainActor
final class ObservableParametersRsync {
    // Set the current value as placeholder text
    var sshport: String = ""
    // SSH keypath and identityfile, the settings View is picking up the current value
    // Set the current value as placeholder text
    var sshkeypathandidentityfile: String = ""
    // Rsync parameters
    var parameter8: String = ""
    var parameter9: String = ""
    var parameter10: String = ""
    var parameter11: String = ""
    var parameter12: String = ""
    var parameter13: String = ""
    var parameter14: String = ""
    // Selected configuration
    var configuration: SynchronizeConfiguration?
    // Alerts
    var alerterror: Bool = false
    var error: Error = Validatedpath.noerror

    func setvalues(_ config: SynchronizeConfiguration?) {
        if let config {
            configuration = config
            parameter8 = configuration?.parameter8 ?? ""
            parameter9 = configuration?.parameter9 ?? ""
            parameter10 = configuration?.parameter10 ?? ""
            parameter11 = configuration?.parameter11 ?? ""
            parameter12 = configuration?.parameter12 ?? ""
            parameter13 = configuration?.parameter13 ?? ""
            parameter14 = configuration?.parameter14 ?? ""
            sshport = String(configuration?.sshport ?? -1)
            if sshport == "-1" { sshport = "" }
            sshkeypathandidentityfile = configuration?.sshkeypathandidentityfile ?? ""
        } else {
            reset()
        }
    }

    func setbackup() {
        if let config = configuration {
            let localcatalog = config.localCatalog
            let localcatalogparts = (localcatalog as AnyObject).components(separatedBy: "/")
            if parameter12.isEmpty == false {
                parameter12 = ""
            } else {
                parameter12 = RsyncArguments().backupstrings[0]
            }
            guard localcatalogparts.count > 2 else { return }
            if config.offsiteCatalog.contains("~") {
                if parameter13.isEmpty == false {
                    parameter13 = ""
                } else {
                    parameter13 = RsyncArguments().backupstrings[1] + "_"
                        + localcatalogparts[localcatalogparts.count - 2]
                }
            } else {
                if parameter13.isEmpty == false {
                    parameter13 = ""
                } else {
                    parameter13 = RsyncArguments().backupstrings[2] + "_"
                        + localcatalogparts[localcatalogparts.count - 2]
                }
            }
            configuration?.parameter12 = parameter12
            configuration?.parameter13 = parameter13
        }
    }

    // Return the updated configuration
    func updatersyncparameters() -> SynchronizeConfiguration? {
        if var configuration {
            if parameter8.isEmpty { configuration.parameter8 = nil } else { configuration.parameter8 = parameter8 }
            if parameter9.isEmpty { configuration.parameter9 = nil } else { configuration.parameter9 = parameter9 }
            if parameter10.isEmpty { configuration.parameter10 = nil } else { configuration.parameter10 = parameter10 }
            if parameter11.isEmpty { configuration.parameter11 = nil } else { configuration.parameter11 = parameter11 }
            if parameter12.isEmpty { configuration.parameter12 = nil } else { configuration.parameter12 = parameter12 }
            if parameter13.isEmpty { configuration.parameter13 = nil } else { configuration.parameter13 = parameter13 }
            if parameter14.isEmpty { configuration.parameter14 = nil } else { configuration.parameter14 = parameter14 }
            if sshport.isEmpty {
                configuration.sshport = nil
            } else {
                configuration.sshport = Int(sshport)
            }
            if sshkeypathandidentityfile.isEmpty {
                configuration.sshkeypathandidentityfile = nil
            } else {
                configuration.sshkeypathandidentityfile = sshkeypathandidentityfile
            }
            return configuration
        }
        return nil
    }

    func reset() {
        configuration = nil
        parameter8 = ""
        parameter9 = ""
        parameter10 = ""
        parameter11 = ""
        parameter12 = ""
        parameter13 = ""
        parameter14 = ""
        sshport = ""
        sshkeypathandidentityfile = ""
    }

    // SSH identityfile
    private func checksshkeypathbeforesaving(_ keypath: String) throws -> Bool {
        if keypath.first != "~" { throw SshError.noslash }
        let tempsshkeypath = keypath
        let sshkeypathandidentityfilesplit = tempsshkeypath.split(separator: "/")
        guard sshkeypathandidentityfilesplit.count > 2 else { throw SshError.noslash }
        guard sshkeypathandidentityfilesplit[1].count > 1 else { throw SshError.notvalidpath }
        guard sshkeypathandidentityfilesplit[2].count > 1 else { throw SshError.notvalidpath }
        return true
    }

    func sshkeypath(_ keypath: String) {
        guard configuration != nil else { return }
        guard keypath.isEmpty == false else {
            configuration?.sshkeypathandidentityfile = nil
            return
        }
        do {
            let verified = try checksshkeypathbeforesaving(keypath)
            if verified {
                configuration?.sshkeypathandidentityfile = keypath
            }
        } catch let e {
            error = e
            alerterror = true
        }
    }

    // SSH port number
    private func checksshport(_ port: String) throws -> Bool {
        guard port.isEmpty == false else { return false }
        if Int(port) != nil {
            return true
        } else {
            throw InputError.notvalidInt
        }
    }

    func setsshport(_ port: String) {
        guard configuration != nil else { return }
        guard port.isEmpty == false else {
            configuration?.sshport = nil
            return
        }
        do {
            let verified = try checksshport(port)
            if verified {
                configuration?.sshport = Int(port)
            }
        } catch let e {
            error = e
            alerterror = true
        }
    }
}
