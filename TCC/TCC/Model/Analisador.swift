//
//  Analisador.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 27/08/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import Foundation
import SwifterSwift
import SpriteKit

class Analisador {
    
    static let analisador = Analisador()
    
    var analisado = [Bool]()
    var exercicioAnalisado = [Exercicio]()
    
    var maioresErros = [String]()
    var playedLines = [CGFloat]()
    var guideLines = [CGFloat]()

    
    let errorMargin :CGFloat = 20
    
    private init(){
        
    }
    
    func comparar(_ played: [CGFloat], _ lines: [SKShapeNode], _ exercicio: Exercicio) -> String {
        maioresErros.removeAll()
        
        if played.isEmpty {
            print("nothing played")
            return "nao tocado"
        }else{
            
            playedLines = played
            
            for i in 0..<lines.count{
                if exercicio.exercicio[i]{
                    guideLines.append(lines[i].position.x)
                }
            }
            
         analiseGeral()
        }
        if maioresErros.count > 2{
            return modaArray(array: maioresErros)
        }
        if maioresErros.count <= 0{
            return "perfeito"
        }
        
        return "poucos erros"
    }
    
    func analiseGeral(){
        var erros = [CGFloat]()
        var strike = false
        let guideBackup = guideLines
        
        for i in playedLines{
            for f in 0..<guideLines.count{
                if guideLines[f] - errorMargin <= i && guideLines[f] + errorMargin >= i{
                    guideLines.remove(at: f)
//                    print("foi, ", i)
                    strike = true
                    break
                }
            }
            if !strike{
                erros.append(i)
                strike = false
            }
        }
        
        print("erros: ", erros)
        print("guideLines: ", guideLines)
        
        analisaErro(erros, guideBackup, guideLines)
        
        erros.removeAll()
        guideLines.removeAll()
        
    }
    
    func analisaErro(_ erros: [CGFloat], _ guide: [CGFloat], _ guideRemanescents: [CGFloat]){
        
        var guideRemanescent = guideRemanescents
        
        var errorFound = false
        
        for i in erros{
            for f in 0..<guide.count{
                if guide[f] - errorMargin <= i && guide[f] + errorMargin >= i{
                    errorFound = true
                    maioresErros.append("nota duplicada")
                    break
                }
                if guide[f] - errorMargin*3 <= i && guide[f] >= i{
                    errorFound = true
                    maioresErros.append("adiantando")
                    
                    for g in 0..<guideRemanescent.count{
                        if guideRemanescent[g] == guide[f]{
                            guideRemanescent.remove(at: g)
                            break
                        }
                    }
                    break
                }
                if guide[f] + errorMargin*3 >= i && guide[f] <= i{
                    errorFound = true
                    maioresErros.append("atraso")
                    for g in 0..<guideRemanescent.count{
                        if guideRemanescent[g] == guide[f]{
                            guideRemanescent.remove(at: g)
                            break
                        }
                    }
                    break
                }
            }
            if !errorFound{
                maioresErros.append("nota errada")
                errorFound = false
            }
        }
        for _ in guideRemanescent{
            maioresErros.append("nota errada")
        }
        
    }
    
    
    func modaArray(array: [String]) -> String{
        
        var dicionarioDeNomes = [String: Int]()
        
        for nome in array{
            if let count = dicionarioDeNomes[nome]{
                dicionarioDeNomes[nome] = count + 1
            } else{
                dicionarioDeNomes[nome] = 1
            }
        }
        var nomeMaisComum = ""
        
        for chave in dicionarioDeNomes.keys{
            if nomeMaisComum == ""{
                nomeMaisComum = chave
            } else {
                let count = dicionarioDeNomes[chave]
                if count! > dicionarioDeNomes[nomeMaisComum]!{
                    nomeMaisComum = chave
                }
            }
            //print("\(chave): \(dicionarioDeNomes[chave]!)")
        }
        return nomeMaisComum
    }

//
//
//    func analisaExercicios(exercicioTocado:[Exercicio], exercicios: [Exercicio]){cara
//        for i in 0..<exercicios.count {
//           analisado.append(comparaExercicios(exercicioTocado[i], exercicios[i]))
//        }
//        exercicioAnalisado = exercicioTocado
//        for i in exercicioAnalisado{
//            i.execução.removeAll("nenhum")
//            print("Maior erro: " + modaArray(array: i.execução))
//        }
//    }
//
//
    
//
//    func comparaExercicios(_ exercicioTocados: Exercicio, _ exerciciosProposto: Exercicio) -> Bool{
//         var erros = 0
//
//        for i in 0..<exercicioTocados.exercicio.count {
//            if !comparaNotas(exercicioTocados.exercicio[i] , exerciciosProposto.exercicio[i]){
//                erros+=1
//                exercicioTocados.execução.append("nota")
//            }else{
//                exercicioTocados.execução.append("nenhum")
//            }
//        }
//
//        if erros > 3 || erros == 0{
//            return false
//        } else {
//            return true
//        }
//    }
//
//    func comparaNotas(_ notaTocada: Bool, _ notaProposta: Bool) -> Bool{
//        if notaTocada == notaProposta{
//            return true
//        } else{
//            return false
//        }
//    }
//
}

