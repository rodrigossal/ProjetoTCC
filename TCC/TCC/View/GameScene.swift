//
//  GameScene.swift
//  TCC
//
//  Created by Rodrigo Salles Stefani on 16/08/18.
//  Copyright © 2018 RodrigoSalles. All rights reserved.
//

import AudioKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
//    let mic = AKMicrophone()
    
    private var lastUpdateTime : TimeInterval = 0

    var guideLines = [SKShapeNode]()
    
    var exercicio = Exercicio(120, [true,false,true,false,true,false,true,false,true,false,true,false,true,false,true,false])
    
    let majorErrors = SKLabelNode(fontNamed: "Chalkduster")
    var maioresErros = [String]()
    
    var principalLine = SKShapeNode()
    
    var played = SKNode()
    var playedLines = [CGFloat]()
    
    var actualBPM = 0
    var timer = Timer()
    var isTimerRunning = false
    var hasStarted = false
    
    var count = 0
    
    var countPlaysBPM = 0
    //CP1145RMUGP
    var systemSounds = 1000
    
    var inicio = -764.5
    var distancia = 103
    
//    var tracker = AKFrequencyTracker()
//    var silence = AKBooster()
    
    override func sceneDidLoad() {

        scaleMode = .aspectFill
        
        self.lastUpdateTime = 0
        
        exercicio = Salvar.salvar.recuperarExercicio()
        actualBPM = exercicio.tempo
        
        majorErrors.position = CGPoint(x: 0, y: -400)
        majorErrors.text = "aquecimento"
        majorErrors.fontSize = 150
        majorErrors.fontColor = SKColor.darkGray
        majorErrors.zPosition = 200
        addChild(majorErrors)
        
        
        
//        mic.start()
//
//        let a = AKMicrophoneTracker.init(hopSize: 4_096, peakCount: 20)
//        let silence = AKBooster(tracker, gain: 0)
//        AudioKit.output = silence
//
//        do {
//            try AudioKit.start()
//        } catch  {
//            print("erro")
//        }
        
//        ------------------------Teste------------------------
//        print("-")
//        print("-")
//        print("-")
//        print("-")
//        self.exercicio.execução = "nota errada"
//        print("VELHO")
//        print("Velocidade exercicio: ", self.exercicio.tempo)
//        print("Exercicio: ", self.exercicio.exercicio)
//        print("EXECUÇÃO MODA: ", self.exercicio.execução!)
//        print("-")
//        Gerador.gerador.geraNovosExercicios(self.exercicio)
//        self.exercicio = Gerador.gerador.novoExercicio!
//        print("-")
//        print("NOVO")
//        print("Velocidade exercicio: ", self.exercicio.tempo)
//        print("Exercicio: ", self.exercicio.exercicio)
//        print("EXECUÇÃO MODA: ", self.exercicio.execução!)
//        print("-")
//        print("-")
//        print("-")
//        print("-")
//        ------------------------Teste------------------------


        addChild(played)

        createLines()
        createPrincipalLine()
        runTimer()
    }
    
   
    
    func createPrincipalLine(){
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x: 0, y: 300))
        let line = SKShapeNode(path: path)
        line.lineWidth = 10
        line.strokeColor = .red
        line.zPosition = 5
        line.position.x = -816
        principalLine = line
        
        addChild(principalLine)
    }
    
    func createLines(){
        
        for i in 0..<16{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0 ,y: -176))
            path.addLine(to: CGPoint(x: 0 , y: 276))
            let line = SKShapeNode(path: path)
            line.position.x = CGFloat(inicio + (distancia * i))
            line.lineWidth = 20
            
            if exercicio.exercicio[i]{
               line.strokeColor = .darkGray
            }else{
                line.strokeColor = .lightGray
                line.alpha = 0.2
            }
            line.zPosition = 3
            guideLines.append(line)
        }
        
        for i in guideLines{
            addChild(i)
        }
    }
    
    func runTimer() {
        play()
        count+=1
        timer = Timer.scheduledTimer(timeInterval: 60/Double(self.actualBPM), target: self,   selector: (#selector(self.play)), userInfo: nil, repeats: true)
    }
    
    @objc func play(){
        self.countPlaysBPM += 1
        
        AudioServicesPlaySystemSound (SystemSoundID(1057))
        //57//71//1100//1127//1130//11
        
        if countPlaysBPM >= 5 {
            self.countPlaysBPM = 1
            principalLine.position.x = CGFloat(inicio-distancia/2)
            principalLine.run(SKAction.move(by: CGVector(dx: distancia*4, dy: 0), duration: 60/Double(self.actualBPM)))
        }else if countPlaysBPM == 4{
            principalLine.run(SKAction.move(by: CGVector(dx: distancia*4 - distancia/4, dy: 0), duration: 15*(60/Double(self.actualBPM))/16)){
                self.playedLines.removeAll()
                for i in self.played.children{
                    self.playedLines.append(i.position.x)
                }
                self.played.removeAllChildren()
                
                print("count")
                if self.count > 11{
                    self.exercicio.execução = Analisador.analisador.modaArray(array: self.maioresErros)
                    self.majorErrors.text = "Finalizou - Maior erro: " + self.exercicio.execução!
                    print("EXECUÇÃO MODA: ", self.exercicio.execução ?? "erro")
                    Gerador.gerador.geraNovosExercicios(self.exercicio)
                    
                    Salvar.salvar.salvarNovoExercicio(self.exercicio)
                    
                    print(Gerador.gerador.novoExercicio!.exercicio)
                    
                    //PROXIMO
                    self.goToGameScene()
                }else if self.count > 3{
                    self.maioresErros.append(Analisador.analisador.comparar(self.playedLines, self.guideLines, self.exercicio))
                    self.majorErrors.text = self.maioresErros.last
                }else if self.count == 3{
                    self.majorErrors.text = "Começou"
                }
                self.count+=1

                self.principalLine.run(SKAction.move(by: CGVector(dx: self.distancia/2, dy: 0), duration: (60/Double(self.actualBPM))/16))
            }
        } else {
            principalLine.run(SKAction.move(by: CGVector(dx: distancia*4, dy: 0), duration: 60/Double(self.actualBPM)))
        }
    }
    
    func showPlayed(){
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: -300))
        path.addLine(to: CGPoint(x: 0, y: 400))
        let line = SKShapeNode(path: path)
        line.lineWidth = 5
        line.strokeColor = .orange
        line.zPosition = 4
        line.position.x = principalLine.position.x
        played.addChild(line)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

        if !hasStarted{
            hasStarted=true
        }
        
        showPlayed()
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func goToGameScene(){
        let scene = GKScene(fileNamed: "GameScene")!
        let sceneNode = scene.rootNode! as! GameScene
        let animation = SKTransition.crossFade(withDuration: 0.0)
        self.view?.presentScene(sceneNode, transition: animation)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
    }
}
