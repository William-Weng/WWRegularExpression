// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

open class WWRegularExpression: NSObject {
    
    /// [比對用的NSPredicate](https://zh-tw.coderbridge.com/series/01d31194cb3c428d9ca2575c91e8b997/posts/11802227e6ad4e52b027d66f8f527f03)
    /// - Predicate.between(from: 100, to: 50).build().evaluate(with: 90)
    public enum Predicate {
        
        case matches(regex: String)                 // [正則表達式 (正規式)](https://swift.gg/2019/11/19/nspredicate-objective-c/)
        case between(from: Any, to: Any)            // 區間比對 (from ~ to)
        case contain(in: Set<AnyHashable>)          // 範圍比對 (33 in [22, 33, 44] => true)
        case contains(with: String)                 // 中間包含文字 ("333GoGo3333" 包含 "GoGo")
        case begin(with: String)                    // 開頭包含文字 ("This is a Student." 開頭是 "This")
        case end(with: String)                      // 結尾包含文字 ("This is a Student." 結尾是 "Student")
        case outOfRange(from: Any, to: Any)         // 範圍之外
        
        /// [產生NSPredicate](https://www.jianshu.com/p/bfdacbdf37a7)
        /// - Returns: NSPredicate
        public func build() -> NSPredicate {
            switch self {
            case .matches(let regex): return NSPredicate(format: "SELF MATCHES %@", regex)
            case .between(let from, let to): return NSPredicate(format: "SELF BETWEEN { \(from), \(to) }")
            case .contain(let set): return NSPredicate(format: "SELF IN %@", set)
            case .contains(let word): return NSPredicate(format: "SELF CONTAINS[cd] %@", word)
            case .begin(let word): return NSPredicate(format: "SELF BEGINSWITH[cd] %@", word)
            case .end(let word): return NSPredicate(format: "SELF ENDSWITH[cd] %@", word)
            case .outOfRange(let from, let to): return NSPredicate(format: "(SELF > \(from)) OR (SELF < \(to))")
            }
        }
    }
    
    /// [字串取代 / 提取字串](https://zh-tw.coderbridge.com/series/01d31194cb3c428d9ca2575c91e8b997/posts/11802227e6ad4e52b027d66f8f527f03)
    public enum Method {
        
        case replace(text: String, pattern: String, template: String)   // [字串取代](https://www.jianshu.com/p/bfdacbdf37a7)
        case extracts(text: String, pattern: String)                    // [提取字串](https://codertw.com/程式語言/681117/)
        
        /// [計算結果](https://nshipster.com/swift-regular-expressions/)
        /// - Returns: Result<String, Error>
        public func calculate() -> Result<[String]?, Error> {
            
            switch self {
            case .replace(text: let text, pattern: let pattern, template: let template): return replaceAction(text: text, pattern: pattern, template: template)
            case .extracts(text: let text, pattern: let pattern): return extractsAction(text: text, pattern: pattern)
            }
        }
    }
}

// MARK: - 小工具
private extension WWRegularExpression.Method {
    
    /// [字串取代](https://www.advancedswift.com/regex-capture-groups/)
    /// - Parameters:
    ///   - text: 要取代的文字字串 => "<xml encoding=\"Shift-JIS\"></xml><xml encoding=\"def\"></xml><xml encoding=\"ISO-8859-1\"></xml>"
    ///   - pattern: 取代的規則 => "(encoding=\")[^\"]+(\")"
    ///   - template: 要填入的文字 => "UTF-8"
    /// - Returns: Result<[String]?, Error>
    func replaceAction(text: String, pattern: String, template: String) -> Result<[String]?, Error> {
        
        do {
            let regex = try NSRegularExpression(pattern: pattern , options: .caseInsensitive)
            let range = NSMakeRange(0, text.count)
            let templateString = "$1\(template)$2"
            let result = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: templateString)
            
            return .success([String(result)])
            
        } catch {
            return .failure(error)
        }
    }
    
    /// [提取字串 - lookahead / lookbehind](http://darkk6.blogspot.com/2017/03/regexp-lookahead-lookbehind.html)
    /// - Parameters:
    ///   - text: 要取代的文字字串 => "<meta/><link/><title>1Q84BOOK1</title><title>28825252</title></head><body>"
    ///   - pattern: 取代的規則 => "(?<=title>)([\\w\\d]{1,})(?=</title>)"
    /// - Returns: Result<[String]?, Error>
    func extractsAction(text: String, pattern: String) -> Result<[String]?, Error> {
        
        do {
            guard let regex = try Optional.some(NSRegularExpression(pattern: pattern , options: .caseInsensitive)),
                  let range = Optional.some(NSRange(text.startIndex..., in: text)),
                  let matches = Optional.some(regex.matches(in: text, options: [], range: range))
            else {
                return .success(nil)
            }
            
            let results = matches.compactMap { matche -> String? in
                guard let range = Range(matche.range, in: text) else { return nil }
                return String(text[range])
            }
            
            return .success(results)

        } catch {
            return .failure(error)
        }
    }
}
