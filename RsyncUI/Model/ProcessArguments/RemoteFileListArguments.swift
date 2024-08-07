//
//  RemoteFileListArguments.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 07/08/2024.
//
// swiftlint:disable line_length

import Foundation
import RsyncArguments

@MainActor
final class RemoteFileListArguments {
    var config: SynchronizeConfiguration?
    var recursive: Bool = false

    func remotefilelistarguments() -> [String]? {
        if let config {
            let rsyncparametersrestore = RsyncParametersRestore(task: config.task,
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
            switch config.task {
            case SharedReference.shared.synchronize:
                rsyncparametersrestore.remoteargumentsfilelist(forDisplay: false, verify: false, dryrun: false, recursive: true)
            case SharedReference.shared.snapshot:
                rsyncparametersrestore.remoteargumentssnapshotfilelist(forDisplay: false, verify: false, dryrun: false, recursive: recursive)
            case SharedReference.shared.syncremote:
                return nil
            default:
                break
            }
            return rsyncparametersrestore.computedarguments
        }
        return nil
    }

    init(config: SynchronizeConfiguration?, recursive: Bool) {
        self.config = config
        self.recursive = recursive
    }
}

// swiftlint:enable line_length
