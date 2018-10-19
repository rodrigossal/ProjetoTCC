//
//  Exercise.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 27/08/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import Foundation

class Exercicio:Codable{
  
    var exercicio = [Bool]()
    var tempo : Int
    var execução : String?
    
    init(_ tempo : Int, _ exercicio : [Bool]) {
        self.exercicio = exercicio
        self.tempo = tempo
    }

}
