//
//  DetailsView.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 07/06/2024.
//

import SwiftUI

struct DetailsView: View {
    let estimatedtask: RemoteDataNumbers
    let outputfromrsync: ObservableOutputfromrsync

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    LabeledContent("Synchronize ID: ") {
                        if estimatedtask.backupID.count == 0 {
                            Text("Synchronize ID")
                                .foregroundColor(.blue)
                        } else {
                            Text(estimatedtask.backupID)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(-3)

                    LabeledContent("Task: ") {
                        Text(estimatedtask.task)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Local catalog: ") {
                        Text(estimatedtask.localCatalog)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Remote catalog: ") {
                        Text(estimatedtask.offsiteCatalog)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Server: ") {
                        if estimatedtask.offsiteServer.count == 0 {
                            Text("localhost")
                                .foregroundColor(.blue)
                        } else {
                            Text(estimatedtask.offsiteServer)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(-3)
                }
                .padding()

                VStack(alignment: .leading) {
                    LabeledContent("Total number of files: ") {
                        Text(estimatedtask.totalNumber)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Total number of catalogs: ") {
                        Text(estimatedtask.totalDirs)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Total numbers: ") {
                        Text(estimatedtask.totalNumber_totalDirs)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)

                    LabeledContent("Total bytes: ") {
                        Text(estimatedtask.totalNumberSizebytes)
                            .foregroundColor(.blue)
                    }
                    .padding(-3)
                }
                .padding()

                Spacer()

                if estimatedtask.datatosynchronize {
                    VStack(alignment: .leading) {
                        Text("^[\(estimatedtask.newfiles_Int) file](inflect: true) new")
                        Text("^[\(estimatedtask.deletefiles_Int) file](inflect: true) for delete")
                        Text("^[\(estimatedtask.transferredNumber_Int) file](inflect: true) changed")
                        Text("^[\(estimatedtask.transferredNumberSizebytes_Int) byte](inflect: true) for transfer")
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.gradient)
                    }
                    .padding()

                } else {
                    Text("No data to synchronize")
                        .font(.title2)
                        .padding()
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.gradient)
                        }
                        .padding()
                }
            }

            Table(outputfromrsync.output) {
                TableColumn("Output from rsync") { data in
                    Text(data.line)
                }
            }
        }
    }
}
