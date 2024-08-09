//
//  ExecuteTasksNOEstimation.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 22/10/2022.
//

import Foundation
import OSLog

@MainActor
final class ExecuteTasksNOEstimation {
    var structprofile: String?
    var localconfigurations: [SynchronizeConfiguration]
    var stackoftasktobeestimated: [Int]?
    weak var localexecuteasyncnoestimation: ExecuteAsyncNoEstimation?
    // Collect loggdata for later save to permanent storage
    // (hiddenID, log)
    private var configrecords = [Typelogdata]()
    private var schedulerecords = [Typelogdata]()
    // Update configigurations
    var localupdateconfigurations: ([SynchronizeConfiguration]) -> Void

    func getconfig(_ hiddenID: Int) -> SynchronizeConfiguration? {
        if let index = localconfigurations.firstIndex(where: { $0.hiddenID == hiddenID }) {
            return localconfigurations[index]
        }
        return nil
    }

    func startexecution() {
        guard stackoftasktobeestimated?.count ?? 0 > 0 else {
            let update = MultipletasksPrimaryLogging(profile: structprofile,
                                                     configurations: localconfigurations)
            let updateconfigurations = update.setCurrentDateonConfiguration(configrecords: configrecords)
            // Send date stamped configurations back to caller
            localupdateconfigurations(updateconfigurations)
            // Update logrecords
            update.addlogpermanentstore(schedulerecords: schedulerecords)
            localexecuteasyncnoestimation?.asyncexecutealltasksnoestiamtioncomplete()
            Logger.process.info("class ExecuteTasks: execution is completed")
            return
        }
        if let localhiddenID = stackoftasktobeestimated?.removeLast() {
            if let config = getconfig(localhiddenID) {
                if let arguments = ArgumentsSynchronize(config: config).argumentssynchronize(dryRun: false,
                                                                                             forDisplay: false)
                {
                    guard arguments.count > 0 else { return }
                    let process = RsyncProcessNOFilehandler(arguments: arguments,
                                                            config: config,
                                                            processtermination: processtermination)
                    process.executeProcess()
                }
            }
        }
    }

    init(profile: String?,
         rsyncuiconfigurations: [SynchronizeConfiguration],
         executeasyncnoestimation: ExecuteAsyncNoEstimation?,
         uuids: Set<UUID>,
         filter: String,
         updateconfigurations: @escaping ([SynchronizeConfiguration]) -> Void)
    {
        structprofile = profile
        localconfigurations = rsyncuiconfigurations
        localexecuteasyncnoestimation = executeasyncnoestimation
        localupdateconfigurations = updateconfigurations
        let filteredconfigurations = localconfigurations.filter { filter.isEmpty ? true : $0.backupID.contains(filter) }
        stackoftasktobeestimated = [Int]()
        // Estimate selected configurations
        if uuids.count > 0 {
            let configurations = filteredconfigurations.filter { uuids.contains($0.id) }
            for i in 0 ..< configurations.count {
                stackoftasktobeestimated?.append(configurations[i].hiddenID)
            }
        } else {
            // Or estimate all tasks
            for i in 0 ..< filteredconfigurations.count {
                stackoftasktobeestimated?.append(filteredconfigurations[i].hiddenID)
            }
        }
    }
}

extension ExecuteTasksNOEstimation {
    func processtermination(outputfromrsync: [String]?, hiddenID: Int?) {
        // Log records
        // If snahost task the snapshotnum is increased when updating the configuration.
        // When creating the logrecord, decrease the snapshotum by 1
        configrecords.append((hiddenID ?? -1, Date().en_us_string_from_date()))
        schedulerecords.append((hiddenID ?? -1, Numbers(outputfromrsync ?? []).stats()))
        if let config = getconfig(hiddenID ?? -1) {
            let record = RemoteDataNumbers(outputfromrsync: outputfromrsync,
                                           config: config)
            localexecuteasyncnoestimation?.appendrecordexecutedlist(record)
            localexecuteasyncnoestimation?.appenduuid(config.id)
            startexecution()
        }
    }
}
