//
//  RsyncParametersCompute.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 03/08/2024.
//
// swiftlint:disable line_length

import Foundation

@MainActor
public final class RsyncParametersCompute {
    var computedarguments = [String]()

    var task = ""

    var parameter1 = ""
    var parameter2 = ""
    var parameter3 = ""
    var parameter4 = ""
    var parameter5 = ""
    var parameter6 = ""

    var parameter8: String?
    var parameter9: String?
    var parameter10: String?
    var parameter11: String?
    var parameter12: String?
    var parameter13: String?
    var parameter14: String?

    var sshport: String?
    var sshkeypathandidentityfile: String?
    var sharedsshport: String?
    var sharedsshkeypathandidentityfile: String?

    var localCatalog = ""
    var offsiteCatalog = ""
    var offsiteServer = ""
    var offsiteUsername = ""
    var computedremoteargs = ""
    var linkdestparam = ""
    var sharedpathforrestore = ""

    var snapshotnum = -1
    var rsyncdaemon = -1

    public func argumentsforsynchronize(forDisplay: Bool, verify: Bool, dryrun: Bool) {
        let rsyncparameters1to6 = RsyncParameters1to6(parameter1: parameter1, parameter2: parameter2, parameter3: parameter3, parameter4: parameter4, parameter5: parameter5, parameter6: parameter6, offsiteServer: offsiteServer, sshport: sshport, sshkeypathandidentityfile: sshkeypathandidentityfile, shared_sshport: sharedsshport, shared_sshkeypathandidentityfile: sharedsshkeypathandidentityfile)
        rsyncparameters1to6.setParameters1To6(forDisplay: forDisplay, verify: verify)
        for i in 0 ..< rsyncparameters1to6.computedarguments.count {
            computedarguments.append(rsyncparameters1to6.computedarguments[i])
        }

        let rsyncparameters8to14 = RsyncParameters8to14(parameter8: parameter8, parameter9: parameter9, parameter10: parameter10, parameter11: parameter11, parameter12: parameter12, parameter13: parameter13, parameter14: parameter14)
        rsyncparameters8to14.setParameters8To14(dryRun: dryrun, forDisplay: forDisplay)
        for i in 0 ..< rsyncparameters8to14.computedarguments.count {
            computedarguments.append(rsyncparameters8to14.computedarguments[i])
        }

        computedarguments.append(localCatalog)
        guard offsiteCatalog.isEmpty == false else { return }
        if offsiteServer.isEmpty == false {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(offsiteCatalog)
            if forDisplay { computedarguments.append(" ") }
        } else {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(computedremoteargs)
            if forDisplay { computedarguments.append(" ") }
        }
        if task == SharedReference.shared.syncremote {
            remoteargssyncremote()
        } else {
            remoteargs()
        }
    }

    public func argumentsforsynchronizeremote(forDisplay: Bool) {
        guard offsiteCatalog.isEmpty == false else { return }
        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(computedremoteargs)
        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(offsiteCatalog)
        if forDisplay { computedarguments.append(" ") }
    }

    public func argumentsforsynchronizesnapshot(forDisplay: Bool) {
        guard linkdestparam.isEmpty == false else {
            computedarguments.append(localCatalog)
            return
        }
        computedarguments.append(linkdestparam)
        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(localCatalog)
        if offsiteServer.isEmpty == false {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(offsiteCatalog)
            if forDisplay { computedarguments.append(" ") }
        } else {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(computedremoteargs)
            if forDisplay { computedarguments.append(" ") }
        }
    }

    public func argumentsforrestore(forDisplay: Bool, tmprestore: Bool) {
        if offsiteServer.isEmpty == false {
            computedarguments.append(offsiteCatalog)
            if forDisplay { computedarguments.append(" ") }
        } else {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(computedremoteargs)
            if forDisplay { computedarguments.append(" ") }
        }
        if tmprestore {
            computedarguments.append(sharedpathforrestore)
        } else {
            computedarguments.append(localCatalog)
        }
    }

    func remoteargs() {
        if offsiteServer.isEmpty == false {
            if rsyncdaemon == 1 {
                computedremoteargs = offsiteUsername + "@" + offsiteServer + "::" + offsiteCatalog
            } else {
                computedremoteargs = offsiteUsername + "@" + offsiteServer + ":" + offsiteCatalog
            }
            computedarguments.append(computedremoteargs)
        }
    }

    func remoteargssyncremote() {
        if offsiteServer.isEmpty == false {
            if rsyncdaemon == 1 {
                computedremoteargs = offsiteUsername + "@" + offsiteServer + "::" + localCatalog
            } else {
                computedremoteargs = offsiteUsername + "@" + offsiteServer + ":" + localCatalog
            }
            computedarguments.append(computedremoteargs)
        }
    }

    /*
      public init (task: String, parameter1: String, parameter2: String , parameter3: String ,parameter4: String, parameter5: String, parameter6: String, parameter8: String? , parameter9: String?, parameter10: String?, parameter11: String?, parameter12: String?, parameter13: String?, parameter14: String?, localCatalog: String, offsiteCatalog: String)
      {
          computedarguments.removeAll()
          self.task = task
          self.parameter1 = parameter1
          self.parameter2 = parameter2
          self.parameter3 = parameter3
          self.parameter4 = parameter4
          self.parameter5 = parameter5
          self.parameter6 = parameter6
          self.parameter8 = parameter8
          self.parameter9 = parameter9
          self.parameter10 = parameter10
          self.parameter11 = parameter11
          self.parameter12 = parameter12
          self.parameter13 = parameter13
          self.parameter14 = parameter14
          self.localCatalog = localCatalog
          self.offsiteCatalog = offsiteCatalog
      }
     */

    public init(task: String, parameter1: String, parameter2: String, parameter3: String, parameter4: String, parameter5: String, parameter6: String, parameter8: String?, parameter9: String?, parameter10: String?, parameter11: String?, parameter12: String?, parameter13: String?, parameter14: String?, sshport: String?, sshkeypathandidentityfile: String?, sharedsshport: String?, sharedsshkeypathandidentityfile: String?, localCatalog: String, offsiteCatalog: String, offsiteServer: String, offsiteUsername: String, sharedpathforrestore: String, snapshotnum: Int, rsyncdaemon: Int) {
        self.task = task
        self.parameter1 = parameter1
        self.parameter2 = parameter2
        self.parameter3 = parameter3
        self.parameter4 = parameter4
        self.parameter5 = parameter5
        self.parameter6 = parameter6
        self.parameter8 = parameter8
        self.parameter9 = parameter9
        self.parameter10 = parameter10
        self.parameter11 = parameter11
        self.parameter12 = parameter12
        self.parameter13 = parameter13
        self.parameter14 = parameter14
        self.sshport = sshport
        self.sshkeypathandidentityfile = sshkeypathandidentityfile
        self.sharedsshport = sharedsshport
        self.sharedsshkeypathandidentityfile = sharedsshkeypathandidentityfile
        self.localCatalog = localCatalog
        self.offsiteCatalog = offsiteCatalog
        self.offsiteServer = offsiteServer
        self.offsiteUsername = offsiteUsername
        self.sharedpathforrestore = sharedpathforrestore
        self.snapshotnum = snapshotnum
        self.rsyncdaemon = rsyncdaemon
        computedarguments.removeAll()
    }
}

// swiftlint:enable line_length
