//
//  MainViewController.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 27/08/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

class MainViewController: UIViewController {
    

    @IBOutlet weak var aSerTocado: UITextField!
    
    @IBOutlet weak var tocado: UITextField!
    
    
    @IBOutlet weak var resultado: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    @IBAction func compara(_ sender: Any) {
        var exerciciosASerTocados = [Exercicio]()
        var exerciciosTocados = [Exercicio]()
        
        
        
        exerciciosASerTocados.append(transformTextToExercise(aSerTocado.text!))
        exerciciosTocados.append(transformTextToExercise(tocado.text!))
        
//        analisador.analisaExercicios(exercicioTocado: exerciciosASerTocados, exercicios: exerciciosTocados)
        
        resultado.text = String(Analisador.analisador.analisado.first!)
    }
    
    func transformTextToExercise(_ texto: String) -> Exercicio{
        
//        var notas = [Bool]()
        let notas = texto.characters.map { $0 == "1" }
        
//        for _ in 0..<texto1.count{
//            print(texto.first)
//            let first = texto1.removeFirst()
//            if Int(String(first))! == 0{
//                notas.append(false)
//            }else{
//                notas.append(true)
//            }
//        }
       return Exercicio(150, notas)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

