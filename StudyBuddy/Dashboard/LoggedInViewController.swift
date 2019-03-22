//
//  LoggedInViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 2/28/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoggedInViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var ref : DatabaseReference!
    var classList = [Class]()
    var gradeCount = 0.0
    var classCount = 0.0
    var unitCount = 0
    var pulsatingLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var classCollection: UICollectionView!
    @IBOutlet weak var gpaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classCollection.dataSource = self
        self.classCollection.delegate = self
        // Do any additional setup after loading the view.
    }
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.175
        animation.duration = 0.90
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let center = CGPoint(x:view.center.x,y:view.center.y - 180)
        // Track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 90, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 12
        //        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.fillColor = UIColor(displayP3Red: 0, green: 148/255, blue: 219/255, alpha: 1.0).cgColor
        pulsatingLayer.position = center
        view.layer.addSublayer(pulsatingLayer)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(displayP3Red: 118/255, green: 134/255, blue: 139/255, alpha: 1.0).cgColor
        trackLayer.lineWidth = 12
                trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.white.cgColor
        trackLayer.position = center
        view.layer.addSublayer(trackLayer)
        
        
        animatePulsatingLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(displayP3Red: 115/255, green: 247/255, blue: 197/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 12
        shapeLayer.strokeEnd = 0
                shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(gpaLabel);
        view.addSubview(unitsLabel);
        loadClasses()
        animateCircle()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func determineGPAPercentage(){
        
    }
    @objc private func animateCircle(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/\(uid!)/classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let classesDict = snapshot.value as? [String:AnyObject] {
                for (_,classesElement) in classesDict {
                    //                    print(todoElement);
                    let classValue = Class()
                    classValue.name = classesElement["name"] as? String
                    classValue.grade = classesElement["grade"] as? Double
                    classValue.units = classesElement["units"] as? Int
                    self.gradeCount += self.determinePointValue(gradePercentage: classValue.grade!)
                    self.unitCount += classValue.units!
                    self.classCount += 1
                }
            }
            let val = self.gradeCount / self.classCount
            let percentage = CGFloat(val)/CGFloat(4)
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = percentage
            basicAnimation.duration = 1.5
            basicAnimation.fillMode = kCAFillModeForwards
            basicAnimation.isRemovedOnCompletion = false
            self.shapeLayer.add(basicAnimation, forKey:"basic")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
    }
    func determinePointValue(gradePercentage: Double) -> Double{
        if(gradePercentage >= 93.0){
            return 4.0
        }
        else if(gradePercentage >= 90){
            return 3.7
        }
        else if(gradePercentage >= 87){
            return 3.3
        }
        else if(gradePercentage >= 83){
            return 3.0
        }
        else if(gradePercentage >= 80){
            return 2.7
        }
        else if(gradePercentage >= 77){
            return 2.3
        }else if(gradePercentage >= 73){
            return 2.0
        }
        else if(gradePercentage >= 70){
            return 1.7
        }
        else if(gradePercentage >= 67){
            return 1.3
        }
        else if(gradePercentage >= 63){
            return 1.0
        }
        else if(gradePercentage >= 60){
            return 0.7
        }else{
            return 0.0
        }
    }
    func determineGradeString(gradePercentage: Double) -> String{
        if(gradePercentage >= 93.0){
            return "A"
        }
        else if(gradePercentage >= 90){
            return "A-"
        }
        else if(gradePercentage >= 87){
            return "B+"
        }
        else if(gradePercentage >= 83){
            return "B"
        }
        else if(gradePercentage >= 80){
            return "B-"
        }
        else if(gradePercentage >= 77){
            return "C+"
        }else if(gradePercentage >= 73){
            return "C"
        }
        else if(gradePercentage >= 70){
            return "C-"
        }
        else if(gradePercentage >= 67){
            return "D+"
        }
        else if(gradePercentage >= 63){
            return "D"
        }else if(gradePercentage >= 60){
            return "D-"
        }
        else{
            return "F"
        }
    }
    func loadClasses(){
        gradeCount = 0.0
        unitCount = 0
        classCount = 0.0
        self.classList.removeAll()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/\(uid!)/classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let classesDict = snapshot.value as? [String:AnyObject] {
                for (_,classesElement) in classesDict {
                    //                    print(todoElement);
                    let classValue = Class()
                    classValue.name = classesElement["name"] as? String
                    classValue.grade = classesElement["grade"] as? Double
                    classValue.units = classesElement["units"] as? Int
                    classValue.uniqueId = classesElement["key"] as? String
                    if classesElement["weights"] != nil{
                        classValue.weights = classesElement["weights"] as? [String]
                    }else{
                        classValue.weights = nil
                    }
                    if classesElement["grades"] != nil{
                        classValue.classGrades = classesElement["grades"] as? [Grade]
                    }else{
                        classValue.classGrades = nil
                    }
                    self.gradeCount += self.determinePointValue(gradePercentage: classValue.grade!)
                    self.unitCount += classValue.units!
                    self.classCount += 1
                    self.classList.append(classValue)
                }
            }
            self.classList.sort { (first, second) -> Bool in
                guard let firstRank = first.name?.lowercased() else { return true }
                guard let secondRank = second.name?.lowercased() else { return false }
                return firstRank < secondRank
            }
            self.classCollection.reloadData()
            let tempValue = self.gradeCount/self.classCount
            let value = Double(round(100*tempValue)/100)
            if(value > 0){
                self.gpaLabel.text = String(value)
            }else{
                self.gpaLabel.text = "0";
            }
            self.unitsLabel.text = self.unitCount.description + " Units"
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = classCollection.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath) as! ClassCollectionCell
        cell.title.text = classList[indexPath.row].name
        cell.gradeLabel.text = (classList[indexPath.row].grade?.description)! + "%"
        cell.bigGrade.text = determineGradeString(gradePercentage: classList[indexPath.row].grade!)
        cell.layer.cornerRadius = 5
//        cell.layer.backgroundColor = UIColor.init(cgColor: CGColor)
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classVC = self.storyboard!.instantiateViewController(withIdentifier: "detailedClass") as! DetailedClassView
                classVC.classValue = classList[indexPath.row]
        self.navigationController?.pushViewController(classVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 20), height: CGFloat(100))
    }
    
    @IBAction func unwindToDash(segue: UIStoryboardSegue){}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
