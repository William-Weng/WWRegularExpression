//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/11/15.
//

import UIKit
import WWPrint
import WWRegularExpression

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        predicateDemo1()
        predicateDemo2()
        methodDemo1()
        methodDemo2()
    }
}

private extension ViewController {
    
    func predicateDemo1() {
        
        let predicate = WWRegularExpression.Predicate.between(from: 10, to: 20).build()

        [1, 15, 30].forEach { number in
            let isInBetween = predicate.evaluate(with: number)
            wwPrint("10 ~ <\(number)> ~ 20 => \(isInBetween)")
        }
    }
    
    func predicateDemo2() {
        
        let predicate = WWRegularExpression.Predicate.contains(with: "M4").build()
        
        ["MacBook Pro M4", "MacBook Air M3", "Mac Mini M4 Pro", "iPhone 16"].forEach { string in
            let isContains = predicate.evaluate(with: string)
            wwPrint("\(string) contains M4 => \(isContains)")
        }
    }
    
    func methodDemo1() {
        
        let text = "<meta/><link/><title>1Q84BOOK1</title><title>28825252</title></head><body>"
        let pattern = "(?<=title>)([\\w\\d]{1,})(?=</title>)"
        let result = WWRegularExpression.Method.extracts(text: text, pattern: pattern).calculate()
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let numbers): wwPrint(numbers ?? [])
        }
    }
    
    func methodDemo2() {
        
        let text = "<xml encoding=\"Shift-JIS\"></xml><xml encoding=\"def\"></xml><xml encoding=\"ISO-8859-1\"></xml>"
        let pattern = "(encoding=\")[^\"]+(\")"
        let result = WWRegularExpression.Method.replace(text: text, pattern: pattern, template: "UTF-8").calculate()
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let numbers): wwPrint(numbers ?? [])
        }
    }
}
