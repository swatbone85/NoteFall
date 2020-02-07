import Foundation
import UIKit

let octaves:[Double] = [1, 2, 4, 8]

//let screenAspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width

struct Note {
    let name: String
    let frequency: Double
    
    static let naturalNotes:[Note] = [Note(name: "A", frequency: 110.00),
                                      Note(name: "B", frequency: 123.47),
                                      Note(name: "C", frequency: 130.81),
                                      Note(name: "D", frequency: 146.83),
                                      Note(name: "E", frequency: 164.81),
                                      Note(name: "F", frequency: 174.61),
                                      Note(name: "G", frequency: 196.00)]
    
    static let flatNotes:[Note] = [Note(name: "Bb", frequency: 116.54),
                                   Note(name: "Db", frequency: 138.59),
                                   Note(name: "Eb", frequency: 155.56),
                                   Note(name: "Gb", frequency: 185.00),
                                   Note(name: "Ab", frequency: 207.65)]
    
    static let sharpNotes:[Note] = [Note(name: "A#", frequency: 116.54),
                                    Note(name: "C#", frequency: 138.59),
                                    Note(name: "D#", frequency: 155.56),
                                    Note(name: "F#", frequency: 185.00),
                                    Note(name: "G#", frequency: 207.65)]
    
}

struct Defaults {
    static let highscore = "highscore"
    static let transposition = "transposition"
    static let useAccidentals = "useAccidentals"
}

enum Transposition: String {
    case C, Bb, Eb, F
}

struct Device {
    static var hasNotch: Bool {
        let screenAspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        return screenAspectRatio < 2.17 && screenAspectRatio > 2.16
    }
}
