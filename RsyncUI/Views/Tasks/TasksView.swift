//
//  TasksView.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 10/11/2023.
//

import Observation
import OSLog
import SwiftUI

struct CopyItem: Identifiable, Codable, Transferable {
    let id: UUID
    let task: String

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}

enum TypeofTask: String, CaseIterable, Identifiable, CustomStringConvertible {
    case synchronize
    case snapshot
    case syncremote

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase }
}

@Observable
final class Selectedconfig {
    var config: SynchronizeConfiguration?
}

struct TasksView: View {
    @Bindable var rsyncUIdata: RsyncUIconfigurations
    // The object holds the progressdata for the current estimated task
    // which is executed. Data for progressview.
    @Bindable var executeprogressdetails: ExecuteProgressDetails
    @Bindable var estimateprogressdetails: EstimateProgressDetails
    @Binding var selecteduuids: Set<SynchronizeConfiguration.ID>
    // Navigation path
    @Binding var path: [Tasks]

    @State private var estimatingstate = EstimatingState()
    // Focus buttons from the menu
    @State private var focusstartestimation: Bool = false
    @State private var focusstartexecution: Bool = false
    // Focus export and import
    @State private var focusexport: Bool = false
    @State private var focusimport: Bool = false
    @State private var importorexport: Bool = false
    // Filterstring
    @State private var filterstring: String = ""
    // Local data for present local and remote info about task
    @State var selectedconfig = Selectedconfig()
    @State private var doubleclick: Bool = false
    // Alert button
    @State private var showingAlert = false
    // Progress synchronizing
    @State private var progress: Double = 0
    // Not used, only for parameter
    @State private var maxcount: Double = 0
    // For estimates is true
    @State private var thereareestimates: Bool = false

    var body: some View {
        ZStack {
            ListofTasksMainView(
                rsyncUIdata: rsyncUIdata,
                selecteduuids: $selecteduuids,
                filterstring: $filterstring,
                doubleclick: $doubleclick,
                progress: $progress,
                executeprogressdetails: executeprogressdetails,
                max: maxcount
            )
            .frame(maxWidth: .infinity)
            .onChange(of: selecteduuids) {
                if let configurations = rsyncUIdata.configurations {
                    if let index = configurations.firstIndex(where: { $0.id == selecteduuids.first }) {
                        selectedconfig.config = configurations[index]
                    } else {
                        selectedconfig.config = nil
                    }
                }
                estimateprogressdetails.uuids = selecteduuids
            }
            .onChange(of: rsyncUIdata.profile) {
                reset()
            }
            .onChange(of: estimateprogressdetails.estimatedlist) {
                if estimateprogressdetails.estimatedlist == nil {
                    thereareestimates = false
                } else {
                    thereareestimates = true
                }
            }
            .onChange(of: focusexport) {
                importorexport = focusexport
            }
            .onChange(of: focusimport) {
                importorexport = focusimport
            }

            Group {
                if focusstartestimation { labelstartestimation }
                if focusstartexecution { labelstartexecution }
                if doubleclick { doubleclickaction }
            }
        }
        .focusedSceneValue(\.startestimation, $focusstartestimation)
        .focusedSceneValue(\.startexecution, $focusstartexecution)
        .focusedSceneValue(\.exporttasks, $focusexport)
        .focusedSceneValue(\.importtasks, $focusimport)
        .toolbar(content: {
            ToolbarItem {
                Button {
                    path.append(Tasks(task: .estimatedview))
                } label: {
                    Image(systemName: "wand.and.stars")
                        .foregroundColor(Color(.blue))
                }
                .help("Estimate (⌘E)")
            }

            ToolbarItem {
                Button {
                    execute()
                } label: {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .foregroundColor(Color(.blue))
                }
                .help("Synchronize (⌘R)")
            }

            ToolbarItem {
                Button {
                    selecteduuids.removeAll()
                    reset()
                } label: {
                    if thereareestimates == true {
                        Image(systemName: "clear")
                            .foregroundColor(Color(.red))
                    } else {
                        Image(systemName: "clear")
                    }
                }
                .help("Reset estimates")
            }

            ToolbarItem {
                Button {
                    path.append(Tasks(task: .alltasksview))
                } label: {
                    Image(systemName: "list.bullet")
                }
                .help("List tasks all profiles")
            }

            ToolbarItem {
                Button {
                    guard selecteduuids.count > 0 else { return }
                    guard selecteduuids.count == 1 else {
                        path.append(Tasks(task: .estimatedview))
                        return
                    }
                    if estimateprogressdetails.tasksareestimated(selecteduuids) {
                        path.append(Tasks(task: .dryrunonetaskalreadyestimated))
                    } else {
                        path.append(Tasks(task: .dryrunonetask))
                    }
                } label: {
                    Image(systemName: "text.magnifyingglass")
                }
                .help("Rsync output estimated task")
            }

            ToolbarItem {
                Button {
                    path.append(Tasks(task: .viewlogfile))
                } label: {
                    Image(systemName: "doc.plaintext")
                }
                .help("View logfile")
            }

            ToolbarItem {
                Button {
                    path.append(Tasks(task: .quick_synchronize))
                } label: {
                    Image(systemName: "hare")
                }
                .help("Quick synchronize")
            }
        })
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Synchronize all tasks with NO estimating first?"),
                primaryButton: .default(Text("Synchronize")) {
                    path.append(Tasks(task: .executenoestimatetasksview))
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $importorexport) {
            if focusexport {
                if let configurations = rsyncUIdata.configurations {
                    ExportView(focusexport: $focusexport, configurations: configurations, profile: rsyncUIdata.profile)
                }

            } else {
                ImportView(focusimport: $focusimport,
                           rsyncUIdata: rsyncUIdata,
                           maxhiddenID: MaxhiddenID().computemaxhiddenID(rsyncUIdata.configurations))
            }
        }
    }

    var doubleclickaction: some View {
        Label("", systemImage: "play.fill")
            .foregroundColor(.black)
            .onAppear(perform: {
                doubleclickactionfunction()
                doubleclick = false
            })
    }

    var labelstartestimation: some View {
        Label("", systemImage: "play.fill")
            .foregroundColor(.black)
            .onAppear(perform: {
                path.append(Tasks(task: .estimatedview))
                focusstartestimation = false
            })
    }

    var labelstartexecution: some View {
        Label("", systemImage: "play.fill")
            .foregroundColor(.black)
            .onAppear(perform: {
                execute()
                focusstartexecution = false
            })
    }
}

extension TasksView {
    func doubleclickactionfunction() {
        if estimateprogressdetails.getestimatedlist() == nil {
            dryrun()
        } else if estimateprogressdetails.onlyselectedtaskisestimated(selecteduuids) {
            // Only execute task if this task only is estimated
            Logger.process.info("Doubleclick: execute a real run for one task only")
            executeprogressdetails.estimatedlist = estimateprogressdetails.getestimatedlist()
            execute()
        } else {
            dryrun()
        }
    }

    func dryrun() {
        if selectedconfig.config != nil,
           estimateprogressdetails.getestimatedlist()?.count ?? 0 == 0
        {
            Logger.process.info("DryRun: execute a dryrun for one task only")
            doubleclick = false
            path.append(Tasks(task: .dryrunonetask))
        } else if selectedconfig.config != nil,
                  estimateprogressdetails.executeanotherdryrun(rsyncUIdata.profile ?? "Default profile") == true
        {
            Logger.process.info("DryRun: new task same profile selected, execute a dryrun")
            doubleclick = false
            path.append(Tasks(task: .dryrunonetask))

        } else if selectedconfig.config != nil,
                  estimateprogressdetails.alltasksestimated(rsyncUIdata.profile ?? "Default profile") == false
        {
            Logger.process.info("DryRun: profile is changed, new task selected, execute a dryrun")
            doubleclick = false
            path.append(Tasks(task: .dryrunonetask))
        }
    }

    func execute() {
        // All tasks are estimated and ready for execution.
        if selecteduuids.count == 0,
           estimateprogressdetails.alltasksestimated(rsyncUIdata.profile ?? "Default profile") == true

        {
            Logger.process.info("Execute() all estimated tasks")
            // Execute all estimated tasks
            selecteduuids = estimateprogressdetails.getuuids()
            estimatingstate.updatestate(state: .start)
            // Change view, see SidebarTasksView
            path.append(Tasks(task: .executestimatedview))

        } else if selecteduuids.count >= 1,
                  estimateprogressdetails.tasksareestimated(selecteduuids) == true

        {
            // One or some tasks are selected and estimated
            Logger.process.info("Execute() estimated tasks only")
            // Execute estimated tasks only
            // Execute all estimated tasks
            selecteduuids = estimateprogressdetails.getuuids()
            estimatingstate.updatestate(state: .start)
            // Change view, see SidebarTasksView
            path.append(Tasks(task: .executestimatedview))
        } else {
            // Execute all tasks, no estimate
            Logger.process.info("Execute() selected or all tasks NO estimate")
            // Execute tasks, no estimate
            showingAlert = true
        }
    }

    func reset() {
        executeprogressdetails.estimatedlist = nil
        estimateprogressdetails.resetcounts()
        estimatingstate.updatestate(state: .start)
        selectedconfig.config = nil
        thereareestimates = false
    }
}
