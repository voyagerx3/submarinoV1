//
//  Volar.swift
//  UBoat LEX
//
//  Created by Geovanny Inca on 16/02/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import Foundation
import SpriteKit
class Volar: SKScene, SKPhysicsContactDelegate {
    
    var puntosLabel = SKLabelNode()
    var puntosTotales: Int = 0
    var vidaLabel = SKLabelNode()
    var anchoScreen: CGFloat = UIScreen.mainScreen().bounds.width
    var altoScreen: CGFloat = UIScreen.mainScreen().bounds.height

    var submarino: SKSpriteNode!
    var submarinoAtlas = SKTextureAtlas(named: "sub")
    var submarinoFrames = [SKTexture]()

    var torpedo : SKSpriteNode!
    var torpedoAtlas = SKTextureAtlas(named: "misilc")
    var torpedoFrames = [SKTexture]()

    
    let verticalPipeGap = 150.0
    var pipeTextureUp:SKTexture! //sin usar
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    
    
    var botonDisparo = SKSpriteNode()
    
    let velocidadFondo: CGFloat = 2
    
    override func didMoveToView(view: SKView) {
        heroe01()
        crearEscenario()
        hub()
        crearMontains()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let tocarLabel: AnyObject = touches.anyObject()!
        let posicionTocar = tocarLabel.locationInNode(self)
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "Volver" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Menu(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        let tocarFire: AnyObject = touches.anyObject()!
        if loQueTocamos.name == "fire" {
            disparar()
        }
        
        
        
    }
  
    func crearMontains() {
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .Nearest
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
    }
  
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( UInt(self.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalPipeGap))
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        ////pipeDown.physicsBody?.categoryBitMask = pipeCategory
        ////pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        ////pipeUp.physicsBody?.categoryBitMask = pipeCategory
        ////pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        ////contactNode.position = CGPointMake( pipeDown.size.width + bird.size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        ////contactNode.physicsBody?.categoryBitMask = scoreCategory
        ////contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func crearEscenario() {
//        for var indice = 0; indice < 2; ++indice {
//            let fondo = SKSpriteNode(imageNamed: "sea01v02")
//            fondo.position = CGPoint(x: indice * Int(fondo.size.width), y: 0)
//            fondo.name = "fondo"
//            fondo.zPosition = 0
//            addChild(fondo)
//        }
        let fondo = SKSpriteNode(imageNamed: "sea01v02")
        fondo.position = CGPoint(x: size.width/2, y: size.height/2)
        fondo.name = "fondo"
        fondo.zPosition = 0
        addChild(fondo)

    }
    func hub() {
        // Tira superior donde estan la vida y los puntos
        let fondoHub = SKSpriteNode(imageNamed: "hub")
        fondoHub.setScale(0.5)
        fondoHub.zPosition = 2
        fondoHub.position = CGPoint(x: size.width/2, y: size.height)
        fondoHub.name = "hub"
        
        // Label de vida
        let vidaTexto = SKLabelNode(fontNamed: "Avenir")
        vidaTexto.text = "Vida: "
        vidaTexto.fontColor = UIColor.whiteColor()
        vidaTexto.fontSize = 22
        vidaTexto.zPosition = 3
        vidaTexto.position = CGPoint(x: 40, y: size.height - 20)
        vidaTexto.name = "VidaTexto"
        
        // Contador de vida
        vidaLabel = SKLabelNode(fontNamed: "Avenir")
        //"100%" + self.anchoScreen.description
        vidaLabel.text = "100%"
        vidaLabel.fontColor = UIColor.whiteColor()
        vidaLabel.fontSize = 22
        vidaLabel.zPosition = 3
        vidaLabel.position = CGPoint(x: vidaTexto.position.x + 55, y: size.height - 20)
        vidaLabel.name = "Puntos"
        
        // Label de puntos
        let puntosTexto = SKLabelNode(fontNamed: "Avenir")
        //
        puntosTexto.text = "Puntos: "
        puntosTexto.fontColor = UIColor.whiteColor()
        puntosTexto.fontSize = 22
        puntosTexto.zPosition = 3
        puntosTexto.position = CGPoint(x: size.width - 80, y: size.height - 20)
        puntosTexto.name = "PuntosTexto"
        
        // Contador de puntos
        puntosLabel = SKLabelNode(fontNamed: "Avenir")
        //self.altoScreen.description
        puntosLabel.text =  "0"
        puntosLabel.fontColor = UIColor.whiteColor()
        puntosLabel.fontSize = 22
        puntosLabel.zPosition = 3
        puntosLabel.position = CGPoint(x: puntosTexto.position.x + 50, y: size.height - 20)
        puntosLabel.name = "Puntos"
        
        //Boton de disparo
        botonDisparo = SKSpriteNode(imageNamed: "firebutton")
        botonDisparo.setScale(0.5)
        botonDisparo.zPosition = 3
        botonDisparo.position = CGPoint(x: size.width - 80, y: 50)
        botonDisparo.name = "fire"
        
        addChild(vidaTexto)
        addChild(vidaLabel)
        addChild(puntosTexto)
        addChild(puntosLabel)
        addChild(botonDisparo)
        addChild(fondoHub)
    }
 
    func heroe01() {
        
                var nombreTextura = [NSArray].self
                var totalImgs = submarinoAtlas.textureNames.count
                for var x = 1; x < totalImgs; x++
                {
                    var textureName = "sub\(x)"
                    var texture = submarinoAtlas.textureNamed(textureName)
                    submarinoFrames.append(texture)
                }
        submarino=SKSpriteNode(texture: submarinoFrames[0])
         addChild(submarino)
        submarino.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(submarinoFrames, timePerFrame: 0.4, resize: false, restore: false)))
        
        
        //submarino = SKSpriteNode(imageNamed: "yellowsub")
        submarino.setScale(0.7)
        submarino.zPosition = 1
        submarino.position = CGPointMake(0 - submarino.size.width, 50)
        submarino.name = "heroe01"
        submarino.physicsBody=SKPhysicsBody(circleOfRadius: submarino.size.height/2)
        submarino.physicsBody?.dynamic=true
        submarino.physicsBody?.affectedByGravity=false
        submarino.physicsBody?.allowsRotation=false
        //submarino.physicsBody?.categoryBitMask=categoriasubmarino
        //submarino.physicsBody?.collisionBitMask=categoriahome
        //submarino.physicsBody?.contactTestBitMask=categoriahome
        //addChild(submarino)
    }
    
    func disparar() {
        
        var nombreTextura = [NSArray].self
        var totalImgs = torpedoAtlas.textureNames.count
        for var x = 1; x < totalImgs; x++
        {
            var textureName = "misilc\(x)"
            var texture = torpedoAtlas.textureNamed(textureName)
            torpedoFrames.append(texture)
        }
        torpedo=SKSpriteNode(texture: torpedoFrames[0])
      //  addChild(torpedo)
        torpedo.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(torpedoFrames, timePerFrame: 0.4, resize: false, restore: false)))
        println("torpedo va...")
        
       //torpedo = SKSpriteNode(imageNamed: "torpedo")
        
//        let torpedoTexture1 = SKTexture(imageNamed: "misilc1")
//        torpedoTexture1.filteringMode = .Nearest
//        let torpedoTexture2 = SKTexture(imageNamed: "misilc2")
//        torpedoTexture2.filteringMode = .Nearest
//        
//        let anim = SKAction.animateWithTextures([torpedoTexture1, torpedoTexture2], timePerFrame: 0.2)
//        let flap = SKAction.repeatActionForever(anim)
//        
//        torpedo = SKSpriteNode(texture: torpedoTexture1)
        //0.2=>0.1
        //torpedo.setScale(0.1)
        torpedo.zPosition = 1
        torpedo.position = CGPointMake(submarino.position.x + (submarino.size.width/4) , submarino.position.y - (submarino.size.height/4) )
        torpedo.name = "torpedo"
        torpedo.physicsBody = SKPhysicsBody(rectangleOfSize: torpedo.size)
        torpedo.physicsBody?.dynamic = true
        torpedo.physicsBody?.affectedByGravity=false
            //torpedo.physicsBody?.categoryBitMask = PhysicsCategory.Torpedo
            //torpedo.physicsBody?.contactTestBitMask = PhysicsCategory.Barco
            //torpedo.physicsBody?.collisionBitMask = PhysicsCategory.None
            //torpedo.physicsBody?.usesPreciseCollisionDetection = true
        //////////////
        
       addChild(torpedo)
        
        let mover = SKAction.moveToX(size.width + torpedo.size.width, duration: 2.0)
        let eliminar = SKAction.removeFromParent()
        torpedo.runAction(SKAction.sequence([mover, eliminar]))
        println("torpedo va...")
        
    }
    
    
////
    func vuelosubmarino() {
        self.enumerateChildNodesWithName("heroe01", usingBlock: { (nodo, stop) -> Void in
            if let avion = nodo as? SKSpriteNode {
                avion.position = CGPoint(
                    x: avion.position.x + self.velocidadFondo,
                    y: avion.position.y)
                
                if (avion.position.x  >  (self.anchoScreen+avion.size.width/3)) {
                    avion.position = CGPointMake(-5,avion.position.y)
                }
            }
        })
    

    
    

        
        
}

    override func update(currentTime: NSTimeInterval) {
        //scrollHorizontal()
        //  vuelohorizontal()
        vuelosubmarino()
        // vuelobomba()
        
    }
    
    
}