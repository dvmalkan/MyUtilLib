//
//  FolderPicker.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 7/29/26.
//

#if os(iOS)

import SwiftUI
import UniformTypeIdentifiers

/// A reusable SwiftUI wrapper around the iOS document picker for selecting a
/// folder.
///
/// `FolderPicker` presents a system Files browser and returns the selected
/// folder as a `URL`. It is primarily intended for operations such as exporting
/// files where the application needs direct access to the destination directory.
///
/// The implementation includes a workaround for an iOS document picker issue
/// where requesting only `UTType.folder` may incorrectly allow selection of
/// individual  files. An additional dummy file type is supplied internally so that
/// the picker behaves as a folder selector. Any non-folder selections are
/// validated and rejected before being returned to the caller.
///
/// The selected folder is returned through a binding. The caller is responsible
/// for:
/// - Starting and stopping access to security-scoped resources.
/// - Persisting a security-scoped bookmark if long-term access is required.
/// - Performing any file operations within the selected folder.
///
/// This view is intended to be presented as a SwiftUI sheet.
@available(iOS 15.0, *)
public struct FolderPicker: UIViewControllerRepresentable {

    @Environment(\.dismiss) private var dismiss

    @Binding var selectedFolder: URL?

    public init (selectedFolder: Binding<URL?>) {
            self._selectedFolder = selectedFolder
        }

    public func makeCoordinator () -> Coordinator {
        Coordinator (self)
    }

    public func makeUIViewController (context: Context) -> UIDocumentPickerViewController {
        
        var types: [UTType] = [.folder]

        // Workaround for an iOS document picker issue where requesting only `.folder`
        // incorrectly enables regular files picking also.
        // Adding an unlikely file type keeps the picker in the desired folder-selection behavior.
        if let dummyExtension = UTType (filenameExtension: "k!7u") {
            types.append (dummyExtension)
        }

        let picker = UIDocumentPickerViewController (forOpeningContentTypes: types, asCopy: false)

        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = false

        return picker
    }

    public func updateUIViewController (_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    public class Coordinator: NSObject, UIDocumentPickerDelegate {

        let parent: FolderPicker

        public init (_ parent: FolderPicker) {
            self.parent = parent
        }

        public func documentPicker (_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

            guard let url = urls.first else {
                AppLog.error ("No URL returned by document picker.")
                return
            }

            do {
                let values = try url.resourceValues (forKeys: [.isDirectoryKey, .contentTypeKey])
                guard
                    values.isDirectory == true,
                    values.contentType?.conforms (to: .folder) == true
                else {
                    // This will be entered in the unlikely event an actual file (with dummyExtension) is selected
                    AppLog.error ("Selection rejected: not a folder.")
                    return
                }

                parent.selectedFolder = url

                // Dismiss only after a valid folder has been selected.
                // parent.dismiss ()

            } catch {
                AppLog.error ("Unable to determine URL type: \(error)")
            }
        }

        public func documentPickerWasCancelled (_ controller: UIDocumentPickerViewController) {
            parent.dismiss ()
        }
    }
} // FolderPicker

#endif
