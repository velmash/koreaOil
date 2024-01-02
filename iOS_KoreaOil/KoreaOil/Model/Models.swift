//
//  Models.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import Foundation

struct TestResponse: Codable {
    let code: Int
    let result: Result
    
    struct Result: Codable {
        let persons: Persons
        let test: Test
        
        struct Persons: Codable {
            let personCount: Int
            let people: [Person]
            
            enum CodingKeys: String, CodingKey {
                case personCount
                case people = "personArr"
            }
            
            struct Person: Codable {
                let name: String
                let age: Int
            }
        }
        
        struct Test: Codable {
            let str1: String
            let str2: String
            
            enum CodingKeys: String, CodingKey {
                case str1 = "testStr1"
                case str2 = "testStr2"
            }
        }
    }
}
