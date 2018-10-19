//
//  Gerador.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 10/09/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import Foundation
import SwifterSwift

class  Gerador {
    
    static let gerador = Gerador()
    
    var novoExercicio : Exercicio?
    var exercicioExecutado : Exercicio?
    
    var modo = 0//0 os dois ,1 cruzamento ,2 mutaçao
    
    var pedacos = [[true,false,false,false],[true,false,true,false],[true,true,true,true],[true,true,true,false],[true,true,false,false],[true,false,false,true],[true,true,false,true],[false,false,true,false],[true,false,true,true],[false,true,false,false],[false,false,false,true],[false,true,false,true],[false,false,true,true],[false,true,true,false],[false,true,true,true]]
    
    
    func geraNovosExercicios(_ exercicio:Exercicio){
        
        exercicioExecutado = exercicio
        novoExercicio = exercicio
        
        switch exercicioExecutado?.execução {
        case "adiantado":
            facilitarVelocidade()
        case "atrasado":
            facilitarVelocidade()
        case "nota errada":
            facilitar()
        case "nota duplicada":
            facilitar()
        case "perfeito":
            dificultar()
        case "poucos erros":
            dificultarVelocidade()//modificar
        case "nao tocado":
            return
        default:
            facilitar()
            
        }
    }
    
    func facilitarVelocidade() {
        if (exercicioExecutado!.tempo) <= 60 {
            exercicioExecutado!.tempo += 20
            self.facilitar()
        } else {
            novoExercicio?.tempo -= 15
        }
    }
    
    func dificultarVelocidade() {
        if (exercicioExecutado!.tempo) >= 120 {
            exercicioExecutado!.tempo -= 40
            self.dificultar()
        } else {
            novoExercicio?.tempo += 15
        }
    }
    
    func facilitar() {
        switch modo {
        case 0:
            cruzamentoFacilitador()
            mutacaoFacilitador()
        case 1:
            cruzamentoFacilitador()
        case 2:
            mutacaoFacilitador()
        default:
            cruzamentoFacilitador()
            mutacaoFacilitador()
        }
    }
    
    func dificultar(){
        switch modo {
        case 0:
            cruzamentoDificultador()
            mutacaoDificultador()
        case 1:
            cruzamentoDificultador()
        case 2:
            mutacaoDificultador()
        default:
            cruzamentoDificultador()
            mutacaoDificultador()
        }
    }
    
    func cruzamentoDificultador(){
        let piece1 = pedacos[Int.random(in: 0 ..< 15)]
        let piece2 = pedacos[Int.random(in: 0 ..< 15)]
        
        let cruzar1 = Int.random(in: 0 ..< 4)
        var cruzar2 = Int.random(in: 0 ..< 4)
        
        while cruzar1 == cruzar2 {
            cruzar2 = Int.random(in: 0 ..< 4)
        }
        
        for i in cruzar1*4...cruzar1*4+3{
            novoExercicio!.exercicio[i] = piece1[i%4]
        }
        
        for i in cruzar2*4...cruzar2*4+3{
            novoExercicio!.exercicio[i] = piece2[i%4]
        }
    }
    
    func mutacaoDificultador(){
        
        var notasFalsas = [Int]()
        var sobrandoImpares = [Int]()
        var sobrandoPares = [Int]()
        
        for i in 0 ..< novoExercicio!.exercicio.count{
            if i%2 != 0{
                sobrandoImpares.append(i)
            }else{
                sobrandoPares.append(i)
            }
        }
        
        for i in 0 ..< novoExercicio!.exercicio.count{
            if !novoExercicio!.exercicio[i]{
                notasFalsas.append(i)
            }
        }
        notasFalsas.shuffle()
        sobrandoPares.shuffle()
        for i in 0...1{

            if notasFalsas.count > 3{
                novoExercicio!.exercicio[notasFalsas[i]] = true
            }else{
                novoExercicio!.exercicio[notasFalsas[i]] = true
            }
        }
        
    }
    
    func cruzamentoFacilitador(){
        
        let piece1 = pedacos[Int.random(in: 0 ..< 5)]
        let piece2 = pedacos[Int.random(in: 0 ..< 5)]
        
        let cruzar1 = Int.random(in: 0 ..< 4)
        var cruzar2 = Int.random(in: 0 ..< 4)
        
        while cruzar1 == cruzar2 {
            cruzar2 = Int.random(in: 0 ..< 4)
        }
     
        for i in cruzar1*4...cruzar1*4+3{
            novoExercicio!.exercicio[i] = piece1[i%4]
        }
        
        for i in cruzar2*4...cruzar2*4+3{
            novoExercicio!.exercicio[i] = piece2[i%4]
        }
        
    }
    
    func mutacaoFacilitador(){
        
        
        var sobrandoImpares = [Int]()
        var sobrandoPares = [Int]()
        
        
        for i in 0 ..< novoExercicio!.exercicio.count{
            if novoExercicio!.exercicio[i]{
                if i%2 != 0{
                    sobrandoImpares.append(i)
                }else{
                    sobrandoPares.append(i)
                }
            }
        }
        print("Impares ", sobrandoImpares)
        print("Pares ", sobrandoPares)
        
        if sobrandoImpares.count > 2{
            sobrandoImpares.shuffle()
            print("Impares ", sobrandoImpares)

            var count = 0
            for i in sobrandoImpares{
                if count < 2{
                    print("gogogogo")
                    novoExercicio!.exercicio[i] = false
                }else {break}
                count += 1
            }
        } else if sobrandoImpares.count > 0{
            for i in sobrandoImpares{
                novoExercicio!.exercicio[i] = false
            }
        } else if sobrandoPares.count > 2 {
            sobrandoPares.shuffle()
            var count = 0
            for i in sobrandoPares{
                if count < 2{
                    novoExercicio!.exercicio[i] = false
                }else {break}
                count += 1
            }
        }
    }
    
    
}
