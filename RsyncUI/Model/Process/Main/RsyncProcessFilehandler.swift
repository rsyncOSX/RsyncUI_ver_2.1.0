//
//  RsyncProcessFilehandler.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 15/03/2021.
//
// swiftlint:disable function_body_length cyclomatic_complexity line_length

import Combine
import Foundation
import OSLog

@MainActor
final class RsyncProcessFilehandler: PropogateError {
    // Combine subscribers
    var subscriptons = Set<AnyCancellable>()
    // Process termination and filehandler closures
    var processtermination: ([String]?, Int?) -> Void
    var filehandler: (Int) -> Void
    var config: SynchronizeConfiguration?
    // Arguments to command
    var arguments: [String]?
    // Output
    var outputprocess: OutputfromProcess?

    func executeProcess() {
        // Must check valid rsync exists
        guard SharedReference.shared.norsync == false else { return }
        // Process
        let task = Process()
        // Getting version of rsync
        task.launchPath = GetfullpathforRsync().rsyncpath
        task.arguments = arguments
        // If there are any Environmentvariables like
        // SSH_AUTH_SOCK": "/Users/user/.gnupg/S.gpg-agent.ssh"
        if let environment = MyEnvironment() {
            task.environment = environment.environment
        }
        // Pipe for reading output from Process
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        // Combine, subscribe to NSNotification.Name.NSFileHandleDataAvailable
        NotificationCenter.default.publisher(
            for: NSNotification.Name.NSFileHandleDataAvailable)
            .sink { [self] _ in
                let data = outHandle.availableData
                if data.count > 0 {
                    if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        outputprocess?.addlinefromoutput(str: str as String)
                        // Send message about files
                        filehandler(outputprocess?.getOutput()?.count ?? 0)
                    }
                    outHandle.waitForDataInBackgroundAndNotify()
                }
            }.store(in: &subscriptons)
        // Combine, subscribe to Process.didTerminateNotification
        NotificationCenter.default.publisher(
            for: Process.didTerminateNotification)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [self] _ in
                processtermination(outputprocess?.getOutput(), config?.hiddenID)
                // Logg to file
                if arguments?.contains("--dry-run") == false,
                   arguments?.contains("--version") == false,
                   let config
                {
                    if SharedReference.shared.logtofile {
                        Logfile(command: config.backupID, data: TrimOutputFromRsync(outputprocess?.getOutput() ?? []).trimmeddata)
                    }
                }
                SharedReference.shared.process = nil
                Logger.process.info("RsyncProcessFilehandler: process = nil and termination discovered")
                // Release Combine subscribers
                subscriptons.removeAll()
            }.store(in: &subscriptons)

        SharedReference.shared.process = task
        do {
            try task.run()
        } catch let e {
            let error = e
            propogateerror(error: error)
        }
        if let launchPath = task.launchPath, let arguments = task.arguments {
            Logger.process.info("RsyncProcessFilehandler: \(launchPath, privacy: .public)")
            Logger.process.info("RsyncProcessFilehandler: \(arguments.joined(separator: "\n"), privacy: .public)")
        }

        if SharedReference.shared.monitornetworkconnection {
            Task {
                var sshport = 22
                if let port = config?.sshport {
                    sshport = port
                } else if let port = SharedReference.shared.sshport {
                    sshport = port
                }
                do {
                    let server = config?.offsiteServer ?? ""
                    if server.isEmpty == false {
                        Logger.process.info("RsyncProcessFilehandler: checking networkconnection")
                        _ = try await TCPconnections().asyncverifyTCPconnection(config?.offsiteServer ?? "", port: sshport)
                    }
                } catch let e {
                    let error = e
                    propogateerror(error: error)
                }
            }
        }
    }

    init(arguments: [String]?,
         config: SynchronizeConfiguration?,
         processtermination: @escaping ([String]?, Int?) -> Void,
         filehandler: @escaping (Int) -> Void)
    {
        self.arguments = arguments
        self.processtermination = processtermination
        self.filehandler = filehandler
        self.config = config
        outputprocess = OutputfromProcess()
    }

    deinit {
        Logger.process.info("RsyncProcessFilehandler: DEINIT")
    }
}

// swiftlint:enable function_body_length cyclomatic_complexity line_length
