//
//  ViewController.swift
//  Banane
//
//  Created by Moritz Lechthaler on 17.02.22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var bananaPan: UIPanGestureRecognizer!
    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    private var chompPlayer: AVAudioPlayer?

    private var laughPlayer: AVAudioPlayer?

    func createPlayer(from filename: String) -> AVAudioPlayer? {
      guard let url = Bundle.main.url(
        forResource: filename,
        withExtension: "caf"
        ) else {
          return nil
      }
      var player = AVAudioPlayer()

      do {
        try player = AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
      } catch {
        print("Error loading \(url.absoluteString): \(error)")
      }

      return player
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1
        let imageViews = view.subviews.filter {
          $0 is UIImageView
        }

        // 2
        for imageView in imageViews {
          // 3
          let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
          )

          // 4
          tapGesture.delegate = self
          imageView.addGestureRecognizer(tapGesture)
          tapGesture.require(toFail: monkeyPan)
          tapGesture.require(toFail: bananaPan)
            let tickleGesture = TickleGestureRecognizer(
              target: self,
              action: #selector(handleTickle)
            )
            tickleGesture.delegate = self
            imageView.addGestureRecognizer(tickleGesture)

        }

        chompPlayer = createPlayer(from: "chomp")
        laughPlayer = createPlayer(from: "laugh")
    }
    
    @IBAction func handleTap(_ gesture: UITapGestureRecognizer) {
        chompPlayer?.play()
    }
    
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
      )

      // 3
      gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
          return
        }

        // 1
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200

        // 2
        let slideFactor = 0.1 * slideMultiplier
        // 3
        var finalPoint = CGPoint(
          x: gestureView.center.x + (velocity.x * slideFactor),
          y: gestureView.center.y + (velocity.y * slideFactor)
        )

        // 4
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)

        // 5
        UIView.animate(
          withDuration: Double(slideFactor * 2),
          delay: 0,
          // 6
          options: .curveEaseOut,
          animations: {
            gestureView.center = finalPoint
        })
    }

    
    @IBAction func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.rotated(
          by: gesture.rotation
        )
        gesture.rotation = 0
    }
    
    @IBAction func handlePinch(_ gesture: UIPinchGestureRecognizer){
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.scaledBy(
          x: gesture.scale,
          y: gesture.scale
        )
        gesture.scale = 1
    }
    
    @objc func handleTickle(_ gesture: TickleGestureRecognizer) {
      laughPlayer?.play()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }
}
