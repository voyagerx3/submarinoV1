//
//  Juego.swift
//  UBoat LEX

import SpriteKit

// Para las colisiones
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Barco: UInt32 = 0b1
    static let Torpedo: UInt32 = 0b10
    static let Submarino: UInt32 = 0b11
}


class Juego: SKScene, SKPhysicsContactDelegate {
    
    var submarino = SKSpriteNode()
    var prisma = SKSpriteNode()
    var enemigo = SKSpriteNode()
    var botonDisparo = SKSpriteNode()
    var torpedo = SKSpriteNode()
    let fondo = SKSpriteNode()
    
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var moverTorpedo = SKAction()
    
    var puntosLabel = SKLabelNode()
    var puntosTotales: Int = 0
    var vidaTotal: Int = 100
    var vidaLabel = SKLabelNode()
    
    let maxAspectRatio: CGFloat = 16.0/9.0
    var areaJugable = CGRect()
    
    let velocidadFondo: CGFloat = 2
    
    var isFingerOnPaddle = false
    
    let tipos = ["enemigo-1","enemigoGerman","enemigoFrance","enemigoArg","enemigoCol"]
    
    override func didMoveToView(view: SKView) {
        heroe()
        prismaticos()
        crearEscenario()
        hub()
        
        // Generacion de enemigos con un intervalo de tiempo fijado
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(enemigos),
                SKAction.waitForDuration(7.0)])))
        
        // Para usar colisiones
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    // Submarino
    func heroe() {
        submarino = SKSpriteNode(imageNamed: "UBoat")
        //0.3 => 0.1
        submarino.setScale(0.15)
        submarino.zPosition = 1
        submarino.position = CGPointMake(90, 200)
        submarino.name = "submarino"
        let estela = SKEmitterNode(fileNamed: "estelaMar.sks")
        estela.zPosition = 0
        estela.setScale(0.4)
        estela.position = CGPointMake(60, -30)
        submarino.addChild(estela)
        
        //////////  rectangleOfSize: submarino.size
        submarino.physicsBody = SKPhysicsBody( circleOfRadius: submarino.size.width/2 )
        submarino.physicsBody?.dynamic = true
        submarino.physicsBody?.categoryBitMask = PhysicsCategory.Submarino
        submarino.physicsBody?.contactTestBitMask = PhysicsCategory.Barco
        submarino.physicsBody?.collisionBitMask = PhysicsCategory.None
        //////////
        addChild(submarino)

        moverArriba = SKAction.moveByX(0, y: 20, duration: 0.2)
        moverAbajo = SKAction.moveByX(0, y: -20, duration: 0.2)
    }
    
    func enemigos(){
        let randomNumber = Int(arc4random_uniform(UInt32(tipos.count)))
        enemigo = SKSpriteNode(imageNamed: tipos[randomNumber])
        //0.8=>0.4
        enemigo.setScale(0.4)
        enemigo.zPosition = 1
            
        let alturaJugable = size.width / maxAspectRatio
        let margenJugable = (size.height - alturaJugable)
        areaJugable = CGRect(x: 0, y: margenJugable, width: size.width, height: alturaJugable)
        
        enemigo.position = CGPoint(
            x: size.width + enemigo.size.width/2,
            y: CGFloat.random(
                min: CGRectGetMinY(areaJugable) + enemigo.size.height * 3,
                max: CGRectGetMaxY(areaJugable) - enemigo.size.height * 3))
        enemigo.name="barco"
        addChild(enemigo)
            
        let mover =    SKAction.moveToX(-enemigo.size.width/2, duration: 22.0)
        let eliminar = SKAction.removeFromParent()
        enemigo.runAction(SKAction.sequence([mover, eliminar]))
        
        enemigo.physicsBody = SKPhysicsBody(rectangleOfSize: enemigo.size)
        enemigo.physicsBody?.dynamic = true
        enemigo.physicsBody?.categoryBitMask = PhysicsCategory.Barco
        enemigo.physicsBody?.contactTestBitMask = PhysicsCategory.Torpedo|PhysicsCategory.Submarino
        enemigo.physicsBody?.collisionBitMask = PhysicsCategory.None
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
        vidaLabel.text = String(vidaTotal)
        vidaLabel.fontColor = UIColor.whiteColor()
        vidaLabel.fontSize = 22
        vidaLabel.zPosition = 3
        vidaLabel.position = CGPoint(x: vidaTexto.position.x + 55, y: size.height - 20)
        vidaLabel.name = "Puntos"
        
        // Label de puntos
        let puntosTexto = SKLabelNode(fontNamed: "Avenir")
        puntosTexto.text = "Puntos: "
        puntosTexto.fontColor = UIColor.whiteColor()
        puntosTexto.fontSize = 22
        puntosTexto.zPosition = 3
        puntosTexto.position = CGPoint(x: size.width - 80, y: size.height - 20)
        puntosTexto.name = "PuntosTexto"
        
        // Contador de puntos
        puntosLabel = SKLabelNode(fontNamed: "Avenir")
        puntosLabel.text = "0"
        puntosLabel.fontColor = UIColor.whiteColor()
        puntosLabel.fontSize = 22
        puntosLabel.zPosition = 3
        puntosLabel.position = CGPoint(x: puntosTexto.position.x + 50, y: size.height - 20)
        puntosLabel.name = "Puntos"
        
        // Boton de disparo
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

    // Controles tactiles
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for toke: AnyObject in touches {
            let dondeTocamos = toke.locationInNode(self)
            if dondeTocamos.y > submarino.position.y && dondeTocamos.x < size.width - 200 {
                if submarino.position.y < 750 {
                    submarino.runAction(moverArriba)
                }
            } else if dondeTocamos.y < submarino.position.y && dondeTocamos.x < size.width - 200 {
                if submarino.position.y > 50 {
                    submarino.runAction(moverAbajo)
                }
            }
        }
        
        let tocarFire: AnyObject = touches.anyObject()!
        let posicionTocar = tocarFire.locationInNode(self)
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        if loQueTocamos.name == "fire" {
            disparar()
        }
    }
    
    // Colision de torpedo con barco
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let node1:SKNode = contact.bodyA.node!;
        let node2:SKNode = contact.bodyB.node!;
        if ( node1.name=="barco" && node2.name=="torpedo")
        {println(node1.name! + " y  " + node2.name! + " Winner" )
                torpedoColisionaConBarco(firstBody.node as SKSpriteNode, enemigo: secondBody.node as SKSpriteNode)
        }
        
        if ( node1.name=="barco" && node2.name=="submarino")
        {println(node1.name! + " y  " + node2.name! + " losser" )
            submarinoColisionaConBarco(firstBody.node as SKSpriteNode, enemigo: secondBody.node as SKSpriteNode)
        }
        
    }
    
    // Cuando colisionan torpedo y enemigo los destruimos e incrementamos la puntuacion
    func torpedoColisionaConBarco(torpedo:SKSpriteNode, enemigo:SKSpriteNode) {
        puntosTotales++
        puntosLabel.text = String(puntosTotales)
        println("barco tocado")
        explotarSubmarino(enemigo)
        torpedo.removeFromParent()
        enemigo.removeFromParent()
    }
    
    // Cuando colisiona un barco con el submarino destruimos el barco y bajamos vida de submarino
    func submarinoColisionaConBarco(submarino:SKSpriteNode, enemigo:SKSpriteNode) {
        vidaTotal -= 10
        if vidaTotal <= 0 {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = GameOver(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        vidaLabel.text = String(vidaTotal)
        println("submarino tocado")
        explotarSubmarino(enemigo)
        //submarino enemigo
        submarino.removeFromParent()
    }
    
    func explotarSubmarino (enemigo:SKSpriteNode) {
        let efectoExplosion = SKEmitterNode(fileNamed: "explosion.sks")
        efectoExplosion.zPosition = 5
        efectoExplosion.setScale(0.4)
        efectoExplosion.position = enemigo.position
        addChild(efectoExplosion)
        // Sonido de destruccion del barco
        runAction(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
    }
    
    func disparar() {
        torpedo = SKSpriteNode(imageNamed: "torpedo")
        //0.2=>0.1
        torpedo.setScale(0.1)
        torpedo.zPosition = 1
        torpedo.position = CGPointMake(submarino.position.x + 70, submarino.position.y - 15)
        torpedo.name = "torpedo"
        //////////////
        torpedo.physicsBody = SKPhysicsBody(rectangleOfSize: torpedo.size)
        torpedo.physicsBody?.dynamic = true
        torpedo.physicsBody?.categoryBitMask = PhysicsCategory.Torpedo
        torpedo.physicsBody?.contactTestBitMask = PhysicsCategory.Barco
        torpedo.physicsBody?.collisionBitMask = PhysicsCategory.None
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        //////////////
        
        addChild(torpedo)
        
        let mover = SKAction.moveToX(size.width + torpedo.size.width, duration: 2.0)
        let eliminar = SKAction.removeFromParent()
        torpedo.runAction(SKAction.sequence([mover, eliminar]))
    }
    
    func prismaticos() {
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(0.66)
        prisma.zPosition = 2
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(prisma)
    }
    
    func crearEscenario() {
        for var indice = 0; indice < 2; ++indice {
            let fondo = SKSpriteNode(imageNamed: "mar4")
            fondo.position = CGPoint(x: indice * Int(fondo.size.width), y: 0)
            fondo.name = "fondo"
            fondo.zPosition = 0
            addChild(fondo)
        }
    }
    
    // Moviento del mar
    func scrollHorizontal() {
        self.enumerateChildNodesWithName("fondo", usingBlock: { (nodo, stop) -> Void in
            if let fondo = nodo as? SKSpriteNode {
                fondo.position = CGPoint(
                    x: fondo.position.x - self.velocidadFondo,
                    y: fondo.position.y)
                
                if fondo.position.x <= -fondo.size.width {
                    fondo.position = CGPointMake(
                        fondo.position.x + fondo.size.width * 2,
                        fondo.position.y)
                }
            }
        })
    }
    
    override func update(currentTime: NSTimeInterval) {
        scrollHorizontal()
    }
}