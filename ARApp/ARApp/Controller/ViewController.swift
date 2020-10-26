//
//  ViewController.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var enemyNodes = [SCNNode]()
    var bulletsNode = SCNNode()
    var currentEnemy = SCNNode()
    var fireNode = SCNNode()
    var player: AVAudioPlayer?
    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.scene.lightingEnvironment.contents = Enemy.scene!.lightingEnvironment.contents
        currentEnemy = setupEnemies()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateMap), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func configureSession() {
              if ARWorldTrackingConfiguration.isSupported {
                  let configuration = ARWorldTrackingConfiguration()
                  configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
                  sceneView.session.run(configuration)
              } else {
                  let configuration = AROrientationTrackingConfiguration()
                  sceneView.session.run(configuration)
              }
          }

    func setupEnemies() -> SCNNode {
        let enemyNode = Enemy()
        enemyNode.position = getRandomVector()
        enemyNodes.append(enemyNode)
        sceneView.scene.rootNode.addChildNode(enemyNode)
        return enemyNode
    }
    
    func getRandomVector() -> SCNVector3 {
        let z = Float.random(in: -6.0...6.0)
        let x = Float.random(in: -6.0...6.0)
        return  SCNVector3(x: x, y: getUserVector().1.y, z: z)
    }
    
    func shootBullet() {
        bulletsNode = Bullet()
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position
        let bulletDirection = direction
        bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
    }
    
    @IBAction func clickShootButton(_ sender: Any) {
        shootBullet()
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func displayEnemies() {
        let pos = getUserVector().1
        let center = CGPoint(x: mapView.bounds.maxX / 2, y: mapView.bounds.maxY / 2)
        let positionX = Int(center.x) + Int(currentEnemy.position.x - pos.x) * 11
        let positionY = Int(center.y) + Int(currentEnemy.position.z - pos.z) * 11
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: positionX - 2, y: positionY - 2, width: 5, height: 5))
        let layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.fillColor = UIColor.red.cgColor
        mapView.layer.addSublayer(layer)
    }
    
    func displayUserOnMap() {
        let centerPoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.maxY)
        let triangle = TriangleView(frame: CGRect(x: Int(centerPoint.x/2) - 4, y: Int(centerPoint.y/2) - 4, width: 7, height: 9))
        let userDirection = getUserVector().0
        let bearingRadians = atan2f(userDirection.z, userDirection.x)
        let bearingDegrees = bearingRadians * (180 / Float.pi) + 90
        
        triangle.rotate(angle: CGFloat(bearingDegrees))
        mapView.addSubview(triangle)
    }
    
    
    @objc func updateMap() {
        mapView.layer.sublayers = nil
        displayUserOnMap()
        displayEnemies()
    }
    
    func setupFireNode() {
         fireNode = Fire()
         enemyNodes.forEach { (node) in
             if node == currentEnemy  {
                 node.removeFromParentNode()
             }
         }
        fireNode.position = currentEnemy.position
         sceneView.scene.rootNode.addChildNode(fireNode)
     }
     
     func playSoundEffect() {
         guard let url = Bundle.main.url(forResource: "explosion", withExtension: "mp3") else { return }
         
         do {
             try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
             try AVAudioSession.sharedInstance().setActive(true)
             
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
     
             guard let player = player else { return }
             player.volume = 1.0
             player.play()
             
         } catch let error {
             print(error.localizedDescription)
         }
     }
}

extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue {
            print("Hit ship!")
            UIView.animate(withDuration: 0.1, animations: {
                self.bulletsNode.removeFromParentNode()
                self.setupFireNode()
                self.playSoundEffect()
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.fireNode.removeFromParentNode()
                    self.currentEnemy = self.setupEnemies()
                })
            }
        }
    }
}


