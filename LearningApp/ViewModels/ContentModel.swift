//
//  ContentModel.swift
//  LearningApp
//
//  Created by Maximilian Kerling on 03.06.21.
//

import Foundation

class ContentModel: ObservableObject {

    // List of modules
    @Published var modules = [Module]()

    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0

    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0

    // Current lesson explanation
    @Published var lessonDescription = NSAttributedString()

    var styleData: Data?

    // Current selected content and test
    @Published var currentContentSelected:Int?

    init() {

        getLocalData()

    }

    // MARK: - Data methods

    func getLocalData() {

        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")

        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            // Try to decode json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)

            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn´t parse local data")

        }

        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")

        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)

            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn´t parse style data")
        }


    }

    // MARK: - Module navigation methods

    func beginModule(_ moduleid: Int) {

        // find the index for this module id
        for index in 0..<modules.count {

            if modules[index].id == moduleid {

                // Found the matching module
                currentModuleIndex = index
                break
            }
        }

        // Set the current module
        currentModule = modules[currentModuleIndex]

    }

    func beginLesson(_ lessonIndex:Int) {

        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }

        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        lessonDescription = addStyling(currentLesson!.explanation)
    }

    func nextLesson() {

        // Advance to lesson index
        currentLessonIndex += 1

        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {

            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }

    func hasNextLesson() -> Bool {

        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)

    }

    // MARK: - Code Styling

    private func addStyling(_ htmlString: String) -> NSAttributedString {

        var resultString = NSAttributedString()
        var data = Data()

        // Add the styling data
        if styleData != nil {
        data.append(self.styleData!)
        }

        // Add the html data
        data.append(Data(htmlString.utf8))

        // Convert the attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

            resultString = attributedString
        }
        return resultString
    }
}
