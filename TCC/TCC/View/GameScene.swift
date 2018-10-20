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
import AVFoundation

class GameScene: SKScene { //Local aonde acontece a tela do exercicio
    
    //criando as variaveis necessarias para o uso
    
    private var lastUpdateTime : TimeInterval = 0

    var guideLines = [SKShapeNode]()
    
    var exercicio = Exercicio(120, [true,false,true,false,true,false,true,false,true,false,true,false,true,false,true,false])
    
    let majorErrors = SKLabelNode(fontNamed: "Chalkduster")
    var maioresErros = [String]()
    
    var principalLine = SKShapeNode()
    
    var nextButton = SKSpriteNode()
    
    var played = SKNode()
    var playedLines = [CGFloat]()
    
    var actualBPM = 0
    var isTimerRunning = false
    var hasStarted = false
    
    var count = 0
    
    var countPlaysBPM = 0
    
    var inicio = -764.5
    var distancia = 103
    
    let mic = AKMicrophone()
    var tracker = AKFrequencyTracker()
    var silence = AKBooster()
    
    var tocado = false
    
    var timer : Timer?

    var bombSoundEffect: AVAudioPlayer?
    
    override func sceneDidLoad() { //Quando a cena carregar vai rodar esse trecho

        scaleMode = .aspectFill
        
        self.lastUpdateTime = 0
        
        // recupera o exercicio salvo do sistema
        exercicio = Salvar.salvar.recuperarExercicio()
        actualBPM = exercicio.tempo
        
        majorErrors.position = CGPoint(x: 0, y: -400)
        majorErrors.text = "iniciar"
        majorErrors.fontSize = 150
        majorErrors.fontColor = SKColor.darkGray
        majorErrors.zPosition = 200
        addChild(majorErrors)
        
        nextButton = SKSpriteNode(imageNamed: "next")
        nextButton.position = CGPoint(x: 600, y: -400)
        nextButton.setScale(0.8)
        nextButton.zPosition = 300
        self.addChild(nextButton)
        nextButton.alpha = 1
        
        // liga o microfone
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        AKSettings.audioInputEnabled = true
        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch  {
            print("AudioKit did not start")
        }

        // inicia o timer para receber o som externo
        _ = Timer.scheduledTimer( timeInterval: 0.01, target: self, selector: #selector(self.checkFrequencyAmplitude), userInfo: nil, repeats: true)

        addChild(played)

        //cria a tela
        createLines()
        createPrincipalLine()
    }
    
    @objc func checkFrequencyAmplitude(){ // função que checa a amplitude do som recebido
        let amplitude = tracker.amplitude
        if (amplitude > 0.09){//&& amplitude < 0.2
            if !tocado{
                print(amplitude)
                tocado = true
                showPlayed()
            }
            
        }else{
            tocado = false
        }
    }
   
    
    func createPrincipalLine(){ //cria a linha guia (vermelha)
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
    
    func createLines(){ // cria as notas no exercicio, as linhas cinzas
        
        for i in 0..<16{
            let path = CGMutablePath()
            if i%4 == 0{
                path.move(to: CGPoint(x: 0 ,y: -200))
                path.addLine(to: CGPoint(x: 0 , y: 300))
            }else{
                path.move(to: CGPoint(x: 0 ,y: -176))
                path.addLine(to: CGPoint(x: 0 , y: 276))
            }
            
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
    
    func runTimer() { //chama o metronomo a cada tempo de batida. Sua função é contar quantas vezes o exercicio tocou, 
        play()
        count+=1
        
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 60/Double(self.actualBPM), target: self,   selector: (#selector(self.play)), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func play(){ // essa função é chamada a cada batida do metronomo. Sua função é contar quantas vezes o exercicio tocou e enviar para analise cada vez que ele é executado. Assim que finalizado, o exercicio chama a geração de um novo.
        self.countPlaysBPM += 1
        
        playSound() // toca o som do metronomo
        
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
                    self.majorErrors.text = "Erro: " + self.exercicio.execução!
                    Gerador.gerador.geraNovosExercicios(self.exercicio)
                    
                    Salvar.salvar.salvarNovoExercicio(self.exercicio)
                    
                    print(Gerador.gerador.novoExercicio!.exercicio)
                    
                    //PROXIMO EXERCICIO CHAMADO
                    self.timer!.invalidate()
                    self.timer = nil
                    self.nextButton.alpha = 1
                    self.majorErrors.text = "proximo"
                    return
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
    
    func showPlayed(){ // quando o usuário toca a nota, chama essa função para criar a linha.
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
        if nextButton.alpha == 1 && nextButton.contains(pos){
            if hasStarted{
                self.goToGameScene()
            }else{
                nextButton.alpha = 0
                majorErrors.text = "aquecimento"
                hasStarted = true
                runTimer()
            }
        }
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
    
    func goToGameScene(){ //reinicia a cena, chamando outra cena com outro exercicio
        removeAction(forKey: "metronome")
        removeAllActions()
        removeAllChildren()
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        mic.stop()
        
        do {
            try AudioKit.stop()
        } catch  {
            print("Erro ao parar audiokit")
        }
        let scene = GKScene(fileNamed: "GameScene")!
        let sceneNode = scene.rootNode! as! GameScene
        let animation = SKTransition.crossFade(withDuration: 0.0)
        self.view?.presentScene(sceneNode, transition: animation)
    }
    
    func playSound(){ //Essa função é chamada pra executar o som do metronomo
        print("played")
        let path = Bundle.main.path(forResource: "click.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            print("AvFoundation error: could't load the file")
        }
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
