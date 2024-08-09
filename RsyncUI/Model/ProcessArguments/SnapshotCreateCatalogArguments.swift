//
//  SnapshotCreateCatalogArguments.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 17.01.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation
import OSLog

final class SnapshotCreateCatalogArguments {
    private var config: SynchronizeConfiguration?
    private var args: [String]?
    private var command: String?

    private func remotearguments() {
        var remotearg: String?
        if config?.sshport != nil {
            args?.append("-p")
            args?.append(String(config!.sshport!))
        }
        if (config?.offsiteServer.isEmpty ?? true) == false {
            remotearg = (config?.offsiteUsername ?? "") + "@" + (config?.offsiteServer ?? "")
            args?.append(remotearg!)
        }
        let remotecatalog = config?.offsiteCatalog
        let remotecommand = "mkdir -p " + (remotecatalog ?? "")
        args?.append(remotecommand)
    }

    func getArguments() -> [String]? {
        args
    }

    func getCommand() -> String? {
        command
    }

    init(config: SynchronizeConfiguration?) {
        Logger.process.warning("SnapshotCreateCatalogArguments: CONVERT")
        guard config != nil else { return }
        args = [String]()
        self.config = config
        remotearguments()
        command = "/usr/bin/ssh"
    }
}
