//
//  MediaViewerHeaderOverlay.swift
//  rawr.
//
//  Created by Nila on 12.11.2023.
//

import MisskeyKit
import Photos
import SwiftKit
import SwiftUI

struct MediaViewerHeaderOverlay: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var context: ViewContext
    
    @State var count: Int = 0
    @State var file: File?
    @Binding var index: Int
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    self.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                    Text("Back")
                        .padding(.leading, -5)
                }.foregroundStyle(.white)
                
                Spacer()
                
                Menu {
                    self.chooseMenuOptions(file: file)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
            }.padding(.trailing, 5)
            HStack {
                Spacer()
                
                Text("\(self.index + 1) of \(self.count)")
                    .fontWeight(.bold)
                
                Spacer()
            }
        }
        .padding(.all, 10)
        .background(.thinMaterial)
    }
    
    var imageOptionsMenuBody: some View {
        VStack {
            Button(action: {
                downloadPhotoLinkAndCreateAsset(self.file!.url!)
            }, label: {
                Label("Save Image", systemImage: "arrow.down.circle")
            })
        }
    }
    
    var videoOptionsMenuBody: some View {
        VStack {
            Button(action: {
                downloadVideoLinkAndCreateAsset(self.file!.url!)
            }, label: {
                Label("Save Video", systemImage: "arrow.down.circle")
            })
        }
    }
    
    var defaultOptionsMenuBody: some View {
        VStack {
            Link("Open in Browser", destination: URL(string: self.file!.url!)!)
        }
    }
    
    func chooseMenuOptions(file: File?) -> AnyView {
        guard let file = file else {
            return AnyView(VStack{})
        }
        if file.type!.starts(with: "image/") {
            return AnyView(imageOptionsMenuBody)
        }
        if file.type!.starts(with: "video/") {
            return AnyView(videoOptionsMenuBody)
        }
        return AnyView(defaultOptionsMenuBody)
    }
    
    func downloadPhotoLinkAndCreateAsset(_ photoLink: String) {

        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: photoLink) else { return }

        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {

            // set up your download task
            URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in

                // use guard to unwrap your optional url
                guard let location = location else { return }

                // create a deatination url with the server response suggested file name
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)

                do {

                    try FileManager.default.moveItem(at: location, to: destinationURL)

                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in

                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: destinationURL)}) { completed, error in
                                    try? FileManager.default.removeItem(at: destinationURL)
                                    if !completed {
                                        self.context.applicationError = ApplicationError(title: "Could not save Photo", message: String(describing: error))
                                    }
                            }
                        }
                    })

                } catch { print(error) }

            }.resume()

        } else {
            print("File already exists at destination url")
        }

    }
    
    func downloadVideoLinkAndCreateAsset(_ videoLink: String) {

        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: videoLink) else { return }

        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {

            // set up your download task
            URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in

                // use guard to unwrap your optional url
                guard let location = location else { return }

                // create a deatination url with the server response suggested file name
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)

                do {

                    try FileManager.default.moveItem(at: location, to: destinationURL)

                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in

                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                    try? FileManager.default.removeItem(at: destinationURL)
                                    if !completed {
                                        self.context.applicationError = ApplicationError(title: "Could not save Video", message: String(describing: error))
                                    }
                            }
                        }
                    })

                } catch { print(error) }

            }.resume()

        } else {
            print("File already exists at destination url")
        }

    }
}

#Preview {
    VStack {
        EmptyView()
    }
    .fluentBackground()
    .safeAreaInset(edge: .top) {
        MediaViewerHeaderOverlay(index: .constant(0))
    }
    .environmentObject(ViewContext())
}
