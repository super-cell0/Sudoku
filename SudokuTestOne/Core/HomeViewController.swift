//
//  ViewController.swift
//  SudokuTestOne
//
//  Created by xiaoxiong beidi on 2022/7/12.
//

import UIKit

class HomeViewController: UIViewController {
    
    let answers = [
        "after", "later", "block", "there"
    ]
    var answer = ""
    var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    //键盘的view
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 162/255, green: 155/255, blue: 254/255, alpha: 1)
        addChild()
        answer = answers.randomElement() ?? "guess"
    }

}

extension HomeViewController {
    
    private func addChild() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.datasource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension HomeViewController: KeyboardViewControllerDelegate {
    
    func keyboardViewController(withVC vc: KeyboardViewController, didTapKey letter: Character) {
        
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            
            if stop {
                break
            }
        }
        
        boardVC.reloadDataNew()
    }

}

extension HomeViewController: BoardViewControllerDatasource {
    func boxColor(with indexPath: IndexPath) -> UIColor? {
        
        let sectionIndexPath = indexPath.section
        let count = guesses[sectionIndexPath].compactMap({ $0 }).count
        guard count == 5 else { return nil}
        let indexPathAnswer = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row], indexPathAnswer.contains(letter)  else {
            return nil
        }
        
        
        if indexPathAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        return .systemPink
    }
    
    var currentGuesses: [[Character?]] {
        return guesses
    }

}
