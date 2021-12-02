//
//  ViewController.swift
//  NumberGuesser_2
//
//  Created by Marlon Lehner on 07.10.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var edtGuess: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnGuess: UIButton!
    @IBOutlet weak var checkTrys: UIButton!
    var model = NumberGuessModel()
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
       // model.guesses.count += 1
        if model.isValid(string: edtGuess.text) {
            let guessedNumber = Int(edtGuess.text!)!
            model.add(guess: guessedNumber)
            let compareResult = model.compare(to: guessedNumber)
            print(model.target)
            if (compareResult < 0) {
                label.text = "Zu hoch!"
            } else if (compareResult > 0) {
                label.text = "Zu niedrig"
            } else {
                label.text = "Richtig!"
                if (model.guesses.count < 6) {
                    image.image = UIImage(named: "happy")
            //    } else if (model.guessCount < 10) {
                    image.image = UIImage(named: "neutral")
                } else {
                    image.image = UIImage(named: "sad")
                }
                image.isHidden = false
            }
        }
    }
    
    @IBAction func onEdtTextChanged(_ sender: UITextField) {
        print("text changed: \(sender.text)")
        btnGuess.isEnabled = model.isValid(string: sender.text)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //TODO: try!!!
        let guessedNumber = Int(edtGuess.text!)!
        let compareResult = model.compare(to: guessedNumber)
        return compareResult == 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let tableViewController = segue.destination as? TableViewController
        if let tvc = tableViewController {
            tvc.model = model
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.target = Int.random(in: 0...100)
        print(model.target)
        label.text = ""
        label.textAlignment = NSTextAlignment.center
        btnGuess.setTitle("Guess", for: .normal)
    }
    
    
}

