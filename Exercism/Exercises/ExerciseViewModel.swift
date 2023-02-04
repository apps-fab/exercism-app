//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation
import ExercismSwift

class ExerciseViewModel: ObservableObject {
    @Published var exerciseDoc: ExerciseDocument? = nil
    @Published var exercise: ExerciseItem? = nil
    @Published var selectedFile: ExerciseFile? = nil
    @Published var selectedCode: String = ""
    private var codes = [String: String]()

    var instruction: String? {
        guard let instructions = exerciseDoc?.instructions else {
            return nil
        }

        do {
            return try String(contentsOf: instructions, encoding: .utf8)
        } catch {
            return nil
        }
    }

    func getDocument(track: String, exercise: String) {
        downloadSolutions(track, exercise)
    }

    private func getLocalExercise(track: String, exercise: String) {
        let solutionFiles = exerciseDoc!.solutions.map { url in
            ExerciseFile.fromURL(url)
        }
        self.exercise = ExerciseItem(name: exercise, language: track, files: solutionFiles)
        selectFile(solutionFiles.first)
    }

    private func getOrCreateSolutionDir(track: String, exercise: String) -> URL? {
        let fileManager = FileManager.default
        do {
            let docsFolder = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)

            let solutionDir = docsFolder.appendingPathComponent("\(track)/\(exercise)/", isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.relativePath) {
                do {
                    try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
                } catch {
                    print("Error creating solution directory: \(error.localizedDescription)")
                    return nil
                }
            }

            return solutionDir
        } catch {
            print("URL error: \(error.localizedDescription)")
            return nil
        }
    }

    func downloadSolutions(_ track: String, _ exercise: String) {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else
        { return }
        let client = ExercismClient(apiToken: token)
        client.downloadSolution(for: track, exercise: exercise) { result in
            switch result {
            case .success(let exerciseDoc):
                self.exerciseDoc = exerciseDoc
                self.getLocalExercise(track: track, exercise: exercise)
            case .failure(let error):
                print("This is the error: \(error)")
            }
        }
    }

    func selectFile(_ file: ExerciseFile?) {
        if let file = file {
            selectedFile = file
        }
        selectedCode = getSelectedCode() ?? ""
    }

    func getSelectedCode() -> String? {
        do {
            guard let selected = selectedFile else {
                return nil
            }
            guard let code = codes[selected.id] else {
                let code = try String(contentsOf: selected.url, encoding: .utf8)
                codes[selected.id] = code
                return code
            }
            print("found code: \(selected.id)")

            return code
        } catch {
            print("Error getting file content: \(error)")
            return nil
        }
    }

    func getTitle() -> String {
        guard let exercise = exercise else {
            return ""
        }
        return "\(exercise.language) / \(exercise.name)"
    }

    func updateCode(_ code: String) {
        if let selected = selectedFile {
            codes[selected.id] = code
        }
    }

    func updateFile() -> Bool {
        if !selectedCode.isEmpty && selectedFile != nil {
            do {
                try selectedCode.write(to: selectedFile!.url, atomically: false, encoding: .utf8)
                return true
            } catch {
                print("Error update \(selectedFile!.id) with \(selectedCode)")
                return false
            }
        }

        return false
    }
}
