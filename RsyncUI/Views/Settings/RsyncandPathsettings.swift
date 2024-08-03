//
//  RsyncandPathsettings.swift
//  RsyncSwiftUI
//
//  Created by Thomas Evensen on 10/02/2021.
//

import OSLog
import SwiftUI

struct RsyncandPathsettings: View {
    @State private var usersettings = ObservableUsersetting()
    @State private var rsyncversion = Rsyncversion()
    @State private var configurationsarebackedup: Bool = false
    // Rsync paths
    @State private var defaultpathrsync = SetandValidatepathforrsync().getpathforrsync()

    var body: some View {
        Form {
            Section {
                HStack {
                    ToggleViewDefault(NSLocalizedString("Rsync v3.x", comment: ""),
                                      $usersettings.rsyncversion3)
                        .onChange(of: usersettings.rsyncversion3) {
                            SharedReference.shared.rsyncversion3 = usersettings.rsyncversion3
                            rsyncversion.getrsyncversion()
                            defaultpathrsync = SetandValidatepathforrsync().getpathforrsync()
                        }

                    ToggleViewDefault(NSLocalizedString("Apple Silicon", comment: ""),
                                      $usersettings.macosarm)
                        .onChange(of: usersettings.macosarm) {
                            SharedReference.shared.macosarm = usersettings.macosarm
                        }
                        .disabled(true)
                }
            } header: {
                Text("Version rsync")
            }

            Section {
                if usersettings.localrsyncpath.isEmpty == true {
                    setrsyncpathdefault
                } else {
                    setrsyncpathlocalpath
                }
            } header: {
                Text("Path rsync")
            }

            Section {
                setpathforrestore
            } header: {
                Text("Path for restore")
            }

            Section {
                setmarkdays
            } header: {
                Text("Mark days after")
            }

            Section {
                HStack {
                    Button {
                        _ = Backupconfigfiles()
                        configurationsarebackedup = true
                        Task {
                            try await Task.sleep(seconds: 2)
                            configurationsarebackedup = false
                        }

                    } label: {
                        Image(systemName: "wrench.adjustable.fill")
                    }
                    .buttonStyle(ColorfulButtonStyle())

                    if SharedReference.shared.settingsischanged, usersettings.ready { thumbsupgreen }
                    if configurationsarebackedup { thumbsupgreen }
                }

            } header: {
                Text("Backup configurations")
            }
        }
        .formStyle(.grouped)
        .alert(isPresented: $usersettings.alerterror,
               content: { Alert(localizedError: usersettings.error)
               })
        .onAppear(perform: {
            Task {
                try await Task.sleep(seconds: 1)
                Logger.process.info("RsyncAndPath settings is DEFAULT")
                SharedReference.shared.settingsischanged = false
                usersettings.ready = true
            }
        })
        .onChange(of: SharedReference.shared.settingsischanged) {
            guard SharedReference.shared.settingsischanged == true,
                  usersettings.ready == true else { return }
            Task {
                try await Task.sleep(seconds: 1)
                _ = WriteUserConfigurationJSON(UserConfiguration())
                SharedReference.shared.settingsischanged = false
                Logger.process.info("RsyncAndPath is SAVED")
            }
        }
    }

    var thumbsupgreen: some View {
        Label("", systemImage: "hand.thumbsup")
            .foregroundColor(Color(.green))
            .imageScale(.large)
    }

    var setrsyncpathlocalpath: some View {
        EditValue(400, nil, $usersettings.localrsyncpath)
            .onAppear(perform: {
                usersettings.localrsyncpath = SetandValidatepathforrsync().getpathforrsync()
            })
    }

    var setrsyncpathdefault: some View {
        EditValue(400, defaultpathrsync, $usersettings.localrsyncpath)
            .onChange(of: usersettings.localrsyncpath) {
                usersettings.setandvalidatepathforrsync(usersettings.localrsyncpath)
            }
    }

    var setpathforrestore: some View {
        EditValue(400, NSLocalizedString("Path for restore", comment: ""),
                  $usersettings.temporarypathforrestore)
            .onAppear(perform: {
                if let pathforrestore = SharedReference.shared.pathforrestore {
                    usersettings.temporarypathforrestore = pathforrestore
                }
            })
            .onChange(of: usersettings.temporarypathforrestore) {
                usersettings.setandvalidapathforrestore(usersettings.temporarypathforrestore)
            }
    }

    var setmarkdays: some View {
        EditValue(400, NSLocalizedString("", comment: ""),
                  $usersettings.marknumberofdayssince)
            .onChange(of: usersettings.marknumberofdayssince) {
                usersettings.markdays(days: usersettings.marknumberofdayssince)
            }
    }
}
