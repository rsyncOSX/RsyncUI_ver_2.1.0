//
//  RsyncParameters1to6.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 02/08/2024.
//
// swiftlint:disable line_length cyclomatic_complexity

import Foundation

final class RsyncParameters1to6 {
    // -e "ssh -i ~/.ssh/id_myserver -p 22"
    // -e "ssh -i ~/sshkeypath/sshidentityfile -p portnumber"
    // default is
    // -e "ssh -i ~/.ssh/id_rsa -p 22"

    var computedarguments = [String]()

    var parameter1 = ""
    var parameter2 = ""
    var parameter3 = ""
    var parameter4 = ""

    var parameter5 = ""
    var parameter6 = ""
    var offsiteServer = ""

    var sshport: String?
    var sshkeypathandidentityfile: String?
    var sharedsshport: String?
    var sharedsshkeypathandidentityfile: String?

    func setParameters1To6(forDisplay: Bool, verify: Bool) {
        if verify {
            parameter1 = DefaultRsyncParameters.verify_parameter1.rawValue
        } else {
            parameter1 = DefaultRsyncParameters.archive_parameter1.rawValue
        }
        computedarguments.append(parameter1)
        if verify {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(DefaultRsyncParameters.recursive.rawValue)
        }
        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(parameter2)
        if forDisplay { computedarguments.append(" ") }
        if offsiteServer.isEmpty == false {
            if parameter3.isEmpty == false {
                computedarguments.append(parameter3)
                if forDisplay { computedarguments.append(" ") }
            }
        }
        if parameter4.isEmpty == false {
            computedarguments.append(parameter4)
            if forDisplay { computedarguments.append(" ") }
        }
        if offsiteServer.isEmpty == false {
            // We have to check for both global and local ssh parameters.
            // either set global or local, parameter5 = remote server
            // ssh params only apply if remote server
            if parameter5.isEmpty == false {
                if let sshport, sshport != "-1", let sshkeypathandidentityfile, sshkeypathandidentityfile.isEmpty == false {
                    sshparameterslocal(forDisplay: forDisplay)
                } else if sharedsshkeypathandidentityfile != nil || sharedsshport != nil {
                    sshparametersglobal(forDisplay: forDisplay)
                } else {
                    computedarguments.append(parameter5)
                    if forDisplay { computedarguments.append(" ") }
                    computedarguments.append(parameter6)
                    if forDisplay { computedarguments.append(" ") }
                }
            }
        }
    }

    // Local params rules global settings
    private func sshparameterslocal(forDisplay: Bool) {
        var sshportadded = false
        var sshkeypathandidentityfileadded = false

        computedarguments.append(parameter5)
        if forDisplay { computedarguments.append(" ") }
        if let sshkeypathandidentityfile {
            sshkeypathandidentityfileadded = true
            if forDisplay { computedarguments.append(" \"") }
            // Then check if ssh port is set also
            if let sshport {
                sshportadded = true
                // "ssh -i ~/sshkeypath/sshidentityfile -p portnumber"
                computedarguments.append("ssh -i " + sshkeypathandidentityfile + " " + "-p " + String(sshport))
            } else {
                computedarguments.append("ssh -i " + sshkeypathandidentityfile)
            }
            if forDisplay { computedarguments.append("\" ") }
        }
        if let sshport {
            // "ssh -p xxx"
            if sshportadded == false {
                sshportadded = true
                if forDisplay { computedarguments.append(" \"") }
                computedarguments.append("ssh -p " + String(sshport))
                if forDisplay { computedarguments.append("\" ") }
            }
        } else {
            // ssh
            if sshportadded == false, sshkeypathandidentityfileadded == false {
                computedarguments.append(parameter6)
            }
        }
        if forDisplay { computedarguments.append(" ") }
    }

    // Global ssh parameters
    private func sshparametersglobal(forDisplay: Bool) {
        var sshportadded = false
        var sshkeypathandidentityfileadded = false

        computedarguments.append(parameter5)
        if forDisplay { computedarguments.append(" ") }
        if let sshkeypathandidentityfile = sharedsshkeypathandidentityfile {
            sshkeypathandidentityfileadded = true
            if forDisplay { computedarguments.append(" \"") }
            // Then check if ssh port is set also
            if let sshport = sharedsshport {
                sshportadded = true
                // "ssh -i ~/sshkeypath/sshidentityfile -p portnumber"
                computedarguments.append("ssh -i " + sshkeypathandidentityfile + " " + "-p " + String(sshport))
            } else {
                computedarguments.append("ssh -i " + sshkeypathandidentityfile)
            }
            if forDisplay { computedarguments.append("\" ") }
        }
        if let sshport = sharedsshport {
            // "ssh -p xxx"
            if sshportadded == false {
                sshportadded = true
                if forDisplay { computedarguments.append(" \"") }
                computedarguments.append("ssh -p " + String(sshport))
                if forDisplay { computedarguments.append("\" ") }
            }
        } else {
            // ssh
            if sshportadded == false, sshkeypathandidentityfileadded == false {
                computedarguments.append(parameter6)
            }
        }
        if forDisplay { computedarguments.append(" ") }
    }

    init(parameter1: String, parameter2: String, parameter3: String, parameter4: String, parameter5: String, parameter6: String, offsiteServer: String, sshport: String?, sshkeypathandidentityfile: String?, shared_sshport: String?, shared_sshkeypathandidentityfile: String?) {
        self.parameter1 = parameter1
        self.parameter2 = parameter2
        self.parameter3 = parameter3
        self.parameter4 = parameter4
        self.parameter5 = parameter5
        self.parameter6 = parameter6
        self.offsiteServer = offsiteServer
        self.sshport = sshport
        self.sshkeypathandidentityfile = sshkeypathandidentityfile
        sharedsshport = shared_sshport
        sharedsshkeypathandidentityfile = shared_sshkeypathandidentityfile

        computedarguments.removeAll()
    }
}

// swiftlint:enable line_length cyclomatic_complexity
