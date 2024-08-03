//
//  ArgumentsSynchronize.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 13/10/2019.
//  Copyright © 2019 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

@MainActor
final class ArgumentsSynchronize {
    var config: SynchronizeConfiguration?

    var rsyncparameterscompute: RsyncParametersCompute?

    func argumentssynchronize(dryRun: Bool, forDisplay: Bool) -> [String]? {
        if let config {
            let rsyncparameterscompute = RsyncParametersCompute(task: config.task,
                                                                parameter1: config.parameter1,
                                                                parameter2: config.parameter2,
                                                                parameter3: config.parameter3,
                                                                parameter4: config.parameter4,
                                                                parameter5: config.parameter5,
                                                                parameter6: config.parameter5,
                                                                parameter8: config.parameter8,
                                                                parameter9: config.parameter9,
                                                                parameter10: config.parameter10,
                                                                parameter11: config.parameter11,
                                                                parameter12: config.parameter12,
                                                                parameter13: config.parameter13,
                                                                parameter14: config.parameter14,
                                                                sshport: String(config.sshport ?? -1),
                                                                sshkeypathandidentityfile: config.sshkeypathandidentityfile ?? "",
                                                                sharedsshport: String(SharedReference.shared.sshport ?? -1),
                                                                sharedsshkeypathandidentityfile: SharedReference.shared.sshkeypathandidentityfile,
                                                                localCatalog: config.localCatalog,
                                                                offsiteCatalog: config.offsiteCatalog,
                                                                offsiteServer: config.offsiteServer,
                                                                offsiteUsername: config.offsiteUsername,
                                                                sharedpathforrestore: SharedReference.shared.pathforrestore ?? "",
                                                                snapshotnum: config.snapshotnum ?? -1,
                                                                rsyncdaemon: config.rsyncdaemon ?? -1)
            rsyncparameterscompute.argumentsforsynchronize(forDisplay: forDisplay, verify: false, dryrun: dryRun)
            return rsyncparameterscompute.computedarguments
        }
        /*
             localCatalog = config.localCatalog
             if self.config?.task == SharedReference.shared.syncremote {
                 remoteargssyncremote(config: config)
             } else {
                 remoteargs(config: config)
             }
             setParameters1To6(config: config, forDisplay: forDisplay, verify: false)
             setParameters8To14(config: config, dryRun: dryRun, forDisplay: forDisplay)
             switch config.task {
             case SharedReference.shared.synchronize:
                 argumentsforsynchronize(forDisplay: forDisplay)
             case SharedReference.shared.snapshot:
                 linkdestparameter(config: config, verify: false)
                 argumentsforsynchronizesnapshot(forDisplay: forDisplay)
             case SharedReference.shared.syncremote:
                 argumentsforsynchronizeremote(forDisplay: forDisplay)
             default:
                 break
             }
             return arguments
         }
              */
        return nil
    }

    init(config: SynchronizeConfiguration?) {
        // super.init()
        self.config = config
    }
}

// swiftlint:enable line_length
