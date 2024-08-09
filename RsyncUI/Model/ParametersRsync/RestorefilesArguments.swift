//
//  RestorefilesArguments.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 27/06/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation
import OSLog

enum Enumrestorefiles {
    case rsync
    case rsyncfilelistings
    case snapshotcatalogsonly
}

@MainActor
final class RestorefilesArguments {
    private var arguments: [String]?

    func getArguments() -> [String]? {
        arguments
    }

    init(task: Enumrestorefiles, config: SynchronizeConfiguration?,
         remoteFile: String?, localCatalog: String?, drynrun: Bool?)
    {
        if let config {
            arguments = [String]()
            switch task {
            case .rsync:
                Logger.process.warning("RestorefilesArguments: CONVERT - using RsyncParametersSingleFilesArguments()")
                let arguments = RsyncParametersSingleFilesArguments(config: config,
                                                                    remoteFile: remoteFile,
                                                                    localCatalog: localCatalog,
                                                                    drynrun: drynrun)
                self.arguments = arguments.getArguments()
            case .rsyncfilelistings, .snapshotcatalogsonly:
                let arguments = RemoteFileListArguments(config: config, filelisttask: task)
                self.arguments = arguments.remotefilelistarguments()
            }
        }
    }
}
