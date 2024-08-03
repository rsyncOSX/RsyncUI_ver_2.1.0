//
//  RsyncDefaultParametersView.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 20/11/2023.
//

import SwiftUI

struct RsyncDefaultParametersView: View {
    @Bindable var rsyncUIdata: RsyncUIconfigurations
    @Binding var path: [ParametersTasks]

    @State private var parameters = ObservableParametersDefault()
    @State private var selectedrsynccommand = RsyncCommand.synchronize
    @State private var selecteduuids = Set<SynchronizeConfiguration.ID>()

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Section(header: headerremove) {
                        VStack(alignment: .leading) {
                            ToggleViewDefault("-e ssh", $parameters.removessh)
                                .onChange(of: parameters.removessh) {
                                    parameters.deletessh(parameters.removessh)
                                }
                            ToggleViewDefault("--compress", $parameters.removecompress)
                                .onChange(of: parameters.removecompress) {
                                    parameters.deletecompress(parameters.removecompress)
                                }
                            ToggleViewDefault("--delete", $parameters.removedelete)
                                .onChange(of: parameters.removedelete) {
                                    parameters.deletedelete(parameters.removedelete)
                                }
                        }
                    }

                    Section(header: headerdaemon) {
                        ToggleViewDefault("daemon", $parameters.daemon)
                    }

                    Spacer()
                }

                ListofTasksLightView(selecteduuids: $selecteduuids,
                                     profile: rsyncUIdata.profile,
                                     configurations: rsyncUIdata.configurations ?? [])
                    .frame(maxWidth: .infinity)
                    .onChange(of: selecteduuids) {
                        if let configurations = rsyncUIdata.configurations {
                            if let index = configurations.firstIndex(where: { $0.id == selecteduuids.first }) {
                                parameters.setvalues(configurations[index])
                            } else {
                                parameters.setvalues(nil)
                            }
                        }
                    }
                    .onChange(of: rsyncUIdata.profile) {
                        parameters.setvalues(nil)
                        selecteduuids.removeAll()
                    }
            }

            Spacer()

            RsyncCommandView(config: $parameters.configuration, selectedrsynccommand: $selectedrsynccommand)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    saversyncparameters()
                    path.removeAll()
                } label: {
                    Image(systemName: "return")
                        .foregroundColor(Color(.blue))
                }
                .help("Update task")
            }
        }
        .padding()
    }

    // Header remove
    var headerremove: some View {
        Text("Remove default rsync parameters")
    }

    // Daemon header
    var headerdaemon: some View {
        Text("Enable rsync daemon")
    }
}

extension RsyncDefaultParametersView {
    func saversyncparameters() {
        if let updatedconfiguration = parameters.updatersyncparameters(),
           let configurations = rsyncUIdata.configurations
        {
            let updateconfigurations =
                UpdateConfigurations(profile: rsyncUIdata.profile,
                                     configurations: configurations)
            updateconfigurations.updateconfiguration(updatedconfiguration, true)
            rsyncUIdata.configurations = updateconfigurations.configurations
            parameters.reset()
        }
    }
}
