//
//  RsyncParametersCompute.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 03/08/2024.
//

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

    private func initialise_rsyncparameters(forDisplay: Bool, verify: Bool, dryrun: Bool) {
        let rsyncparameters1to6 = RsyncParameters1to6(parameter1: parameter1,
                                                      parameter2: parameter2,
                                                      parameter3: parameter3,
                                                      parameter4: parameter4,
                                                      parameter5: parameter5,
                                                      parameter6: parameter6,
                                                      offsiteServer: offsiteServer,
                                                      sshport: sshport,
                                                      sshkeypathandidentityfile: sshkeypathandidentityfile,
                                                      sharedsshport: sharedsshport,
                                                      sharedsshkeypathandidentityfile: sharedsshkeypathandidentityfile)

        computedarguments += rsyncparameters1to6.setParameters1To6(forDisplay: forDisplay, verify: verify)

        let rsyncparameters8to14 = RsyncParameters8to14(parameter8: parameter8,
                                                        parameter9: parameter9,
                                                        parameter10: parameter10,
                                                        parameter11: parameter11,
                                                        parameter12: parameter12,
                                                        parameter13: parameter13,
                                                        parameter14: parameter14)

        computedarguments += rsyncparameters8to14.setParameters8To14(dryRun: dryrun, forDisplay: forDisplay)
    }

    public func argumentsforsynchronize(forDisplay: Bool, verify: Bool, dryrun: Bool) {
        guard task == DefaultRsyncParameters.synchronize.rawValue else { return }

        initialise_rsyncparameters(forDisplay: forDisplay, verify: verify, dryrun: dryrun)

        computedarguments.append(localCatalog)

        if offsiteServer.isEmpty == true {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(offsiteCatalog)
            if forDisplay { computedarguments.append(" ") }
        } else {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(remoteargs())
            if forDisplay { computedarguments.append(" ") }
        }
    }

    public func argumentsforsynchronizeremote(forDisplay: Bool, verify: Bool, dryrun: Bool) {
        guard task == DefaultRsyncParameters.syncremote.rawValue else { return }

        guard offsiteServer.isEmpty == false else { return }

        initialise_rsyncparameters(forDisplay: forDisplay, verify: verify, dryrun: dryrun)

        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(remoteargssyncremote())
        if forDisplay { computedarguments.append(" ") }

        if forDisplay { computedarguments.append(" ") }
        computedarguments.append(offsiteCatalog)
        if forDisplay { computedarguments.append(" ") }
    }

    public func argumentsforsynchronizesnapshot(forDisplay: Bool, verify: Bool, dryrun: Bool) {
        guard task == DefaultRsyncParameters.snapshot.rawValue else { return }

        initialise_rsyncparameters(forDisplay: forDisplay, verify: verify, dryrun: dryrun)

        // Prepare linkdestparam and
        linkdestparameter(verify: verify)
        computedarguments.append(linkdestparam)

        if offsiteServer.isEmpty == true {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(offsiteCatalog)
            if forDisplay { computedarguments.append(" ") }
        } else {
            if forDisplay { computedarguments.append(" ") }
            computedarguments.append(remoteargs())
            if forDisplay { computedarguments.append(" ") }
        }
    }

    private func remoteargs() -> String {
        if rsyncdaemon == 1 {
            computedremoteargs = offsiteUsername + "@" + offsiteServer + "::" + offsiteCatalog
        } else {
            computedremoteargs = offsiteUsername + "@" + offsiteServer + ":" + offsiteCatalog
        }
        return computedremoteargs
    }

    private func remoteargssyncremote() -> String {
        if rsyncdaemon == 1 {
            computedremoteargs = offsiteUsername + "@" + offsiteServer + "::" + localCatalog
        } else {
            computedremoteargs = offsiteUsername + "@" + offsiteServer + ":" + localCatalog
        }
        return computedremoteargs
    }

    // Additional parameters if snapshot
    private func linkdestparameter(verify: Bool) {
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

    public init(task: String,
                parameter1: String,
                parameter2: String,
                parameter3: String,
                parameter4: String,
                parameter5: String,
                parameter6: String,
                parameter8: String?,
                parameter9: String?,
                parameter10: String?,
                parameter11: String?,
                parameter12: String?,
                parameter13: String?,
                parameter14: String?,
                sshport: String?,
                sshkeypathandidentityfile: String?,
                sharedsshport: String?,
                sharedsshkeypathandidentityfile: String?,
                localCatalog: String,
                offsiteCatalog: String,
                offsiteServer: String,
                offsiteUsername: String,
                sharedpathforrestore: String,
                snapshotnum: Int,
                rsyncdaemon: Int)
    {
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
