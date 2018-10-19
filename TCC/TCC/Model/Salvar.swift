//
//  Salvar.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 18/10/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import Foundation


class Salvar {
    
    static let salvar = Salvar()

    let defaults = UserDefaults.standard

    var exerciciosAntigos = [Exercicio]()
    
    func salvarNovoExercicio(_ exercicio:Exercicio){

//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: exercicio)
//        defaults.set(encodedData, forKey: "novoExercicio")
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(exercicio), forKey: "novoExercicio")

        if let data = UserDefaults.standard.value(forKey: "exerciciosAntigos") as? Data {
            exerciciosAntigos = try! PropertyListDecoder().decode([Exercicio].self, from: data)
        }
        exerciciosAntigos.append(exercicio)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(exerciciosAntigos), forKey: "exerciciosAntigos")

//        exerciciosAntigos = defaults.object(forKey: "exerciciosAntigos") as? [Exercicio] ?? [Exercicio]()
//        defaults.set(exerciciosAntigos, forKey: "exerciciosAntigos")

        
    }
    
    func recuperarExercicio() -> Exercicio{
        
//        if UserDefaults.standard.object(forKey: "novoExercicio") == nil{
//            return Exercicio(90, [true,false,true,false,true,false,true,false,true,false,true,false,true,false,true,false])
//        }
//
//        let decoded  = UserDefaults.standard.object(forKey: "novoExercicio") as! Data
//
//        let exercicio = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Exercicio
//
//        return exercicio
        var userData = Exercicio(90, [true,false,true,false,true,false,true,false,true,false,true,false,true,false,true,false])
        if let data = UserDefaults.standard.value(forKey: "novoExercicio") as? Data {
            userData = try! PropertyListDecoder().decode(Exercicio.self, from: data)
            return userData
        } else {
            return userData
        }
    }
    
    
}
