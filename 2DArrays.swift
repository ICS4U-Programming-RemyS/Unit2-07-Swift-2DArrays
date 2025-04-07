//
// ClassMarks.swift
//
// Created by Remy Skelton
// Created on 2025-04-04
// Version 1.0
// Copyright (c) 2025 Remy Skelton. All rights reserved.
//
// Description:
// The ClassMarks program reads student names from students.txt and
// assignment titles from assignments.txt. It stores this data in two
// separate arrays. The program then calls a function called generateMarks,
// which generates random marks (mean 75, standard deviation 10) for each
// student on each assignment. These marks are written to a CSV file called
// Marks.csv.
//

import Foundation

// Declare constants for the maximum and minimum mark values
let maxMark = 100
let minMark = 0

// File paths for student and assignment lists
let studentsFilePath = "./students.txt"
let assignmentsFilePath = "./assignments.txt"

// Read student and assignment names from their respective files
let studentLines = try String(contentsOfFile: studentsFilePath).split(separator: "\n")
let assignmentLines = try String(contentsOfFile: assignmentsFilePath).split(separator: "\n")

// Convert to arrays of strings
let studentNames = studentLines.map(String.init)
let assignmentTitles = assignmentLines.map(String.init)

// Generate a 2D array of marks
let marksMatrix = generateMarks(forAssignments: assignmentTitles, andStudents: studentNames)

// Specify the output CSV file path
let outputCSVPath = "./Marks.csv"

// Create the file
FileManager.default.createFile(atPath: outputCSVPath, contents: nil, attributes: nil)

// Open file for writing
let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: outputCSVPath))

// Write header row with assignment titles
var headerRow = "Student Name"
for assignment in assignmentTitles {
    headerRow += ", \(assignment)"
}
fileHandle.write(Data("\(headerRow)\n".utf8))

// Write each student's marks
for studentIndex in 0..<studentNames.count {
    var row = studentNames[studentIndex]
    for assignmentIndex in 0..<assignmentTitles.count {
        row += ", \(marksMatrix[studentIndex][assignmentIndex])"
    }
    fileHandle.write(Data("\(row)\n".utf8))
}

// Close the file
fileHandle.closeFile()

// Notify user of success
print("The file has been written successfully.")


// Function to generate a 2D array of random marks
func generateMarks(forAssignments assignments: [String], andStudents students: [String]) -> [[String]] {

    // Create 2D array to store marks
    var marks = Array(repeating: Array(repeating: "", count: assignments.count), count: students.count)

    // Iterate through students and assignments
    for studentIndex in 0..<students.count {
        for assignmentIndex in 0..<assignments.count {

            // Generate a random Gaussian number using Box-Muller transform
            let rand1 = Double.random(in: 0...1)
            let rand2 = Double.random(in: 0...1)
            let gaussian = sqrt(-2 * log(rand1)) * cos(2 * .pi * rand2)

            // Generate mark with mean 75 and std dev 10
            let rawMark = Int(75 + 10 * gaussian)

            // Clamp between minMark and maxMark, convert to string
            marks[studentIndex][assignmentIndex] = String(max(minMark, min(maxMark, rawMark)))
        }
    }

    // Return completed matrix
    return marks
}
