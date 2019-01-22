//
//  ViewController.swift
//  MathFrac
//
//  Created by Thomas Etcheverria on 16/11/2018.
//  Copyright © 2018 Belette Team. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    
    var question : String = ""
    var answer : String = ""
    var raw_data : [Int] = []//[n1,n2,d1,d2,f,g]
    var counter : Int = 0
    var count_ok : Int = 0
    let html_start = "<!DOCTYPE html><html><head><title>MathJax TeX Test Page</title><script type=\"text/javascript\" async  src=\"my-mathjax/MathJax.js?config=TeX-AMS_CHTML\"></script></head><body>  <div style=\"font-size: 100pt; color: black;\">$$";
    let html_end = "$$</div></body></html>";
    var n1 = 0
    var n2 = 0
    var d1 = 0
    var d2 = 0
    
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var numerateur: UITextField!
    @IBOutlet weak var denominateur: UITextField!
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var switch_multiplication: UISwitch!
    @IBOutlet weak var switch_addition: UISwitch!
    @IBOutlet weak var switch_division: UISwitch!
    
    @IBAction func button_division(_ sender: UISwitch) {
        switch_multiplication.setOn(false, animated: true)
        switch_addition.setOn(false, animated: true);
        reload()
    }
    @IBAction func button_addition(_ sender: UISwitch) {
        switch_multiplication.setOn(false, animated: true);
        switch_division.setOn(false, animated: true);
        reload()
    }
    @IBAction func button_multiplication(_ sender: UISwitch) {
        switch_addition.setOn(false, animated: true);
        switch_division.setOn(false, animated: true);
        reload()
    }

    
    @IBAction func essai() {
        // obtention valeur numerateur et denominateur
        let num = Int(numerateur.text ?? "0") ?? 0
        let denom = Int(denominateur.text ?? "0") ?? 0
        let num_resultat = raw_data[0]
        let denom_resultat = raw_data[1]
        if denom == 0{
            denominateur.backgroundColor = UIColor.red
            return
        }
        // test des valeurs pour egalites de fractions
        if (denom*num_resultat == denom_resultat*num){
            numerateur.backgroundColor = UIColor.green
            denominateur.backgroundColor = UIColor.green
        }else{
            if (max(denom, denom_resultat)%min(denom,denom_resultat)==0){
                denominateur.backgroundColor = UIColor.orange
            }
        }
    }

    @IBAction func help_me() {
        if (switch_addition.isOn){
            help_me_addition()
        }
    }
    
    func help_me_addition(){
        var aide = "Le facteur est " + String(d2/d1)+".\n";
        if (d2 != raw_data[1]){
            aide += "\nIl faudra simplifier la fraction."
        }
        // create the alert
        let alert = UIAlertController(title: "Aide", message: aide, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func solution_me() {
        load_me(content: answer)
    }
    
    
    @IBAction func reload() {
        denominateur.backgroundColor = UIColor.white
        numerateur.backgroundColor = UIColor.white
        chooseValue()
        load_me(content: question)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chooseValue()
        load_me(content : question)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func gcd(A: Int,B: Int) -> Int {
        var t = 0
        var a = A
        var b = B
        while a%b != 0 {
            t = b;
            b = a%b;
            a = t;
        }
        return b
    }
    
    func load_me(content:String){
        let path = Bundle.main.bundlePath
        let baseURL = NSURL.fileURL(withPath: path)
        webview.loadHTMLString(html_start + content + html_end, baseURL: baseURL)
    }
    
    func chooseValue(){
        if (switch_addition.isOn){
            addition()
        }
        if (switch_multiplication.isOn){
            multiplication()
        }
        if (switch_division.isOn){
            division()
        }
    }
    
    func addition(){
        let facteur = [2,3,4,5,6,7,8,9,10,11,12,13];
        let numerateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        let denominateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
        let f = facteur.randomElement()!;
        n1 = numerateur.randomElement()!;
        n2 = numerateur.randomElement()!;
        d1 = denominateur.randomElement()!;
        d2 = d1*f;
        let signe = ["-","+"].randomElement()!;
        
        question = "\\dfrac{" + String(n1) + "}{"+String(d1)+"} "+signe+" \\dfrac{"+String(n2)+"}{"+String(d2)+"}"
        
        answer = "\\begin{align*}"
        answer += "\\dfrac{" + String(n1) + "}{"+String(d1)+"} "+signe+" \\dfrac{"+String(n2)+"}{"+String(d2)+"}"
        
        answer += "& = " + "\\dfrac"
        answer += "{" + String(n1) + "\\times" + String(f) + "}"
        answer += "{" + String(d1) + "\\times" + String(f) + "}"
        answer += signe + "\\dfrac{"+String(n2)+"}{"+String(d2) + "}\\\\"
        
        answer += " & = " + "\\dfrac{" + String(n1*f) + "}{"+String(d1*f)+"} "+signe+" \\dfrac{"+String(n2)+"}{"+String(d2)+"} \\\\"
        answer += " & = " + "\\dfrac{"+String(n1*f) + signe + String(n2)+"}{"+String(d2)+"} \\\\"
        var newNum = 0
        if (signe == "+"){
            newNum = n1*f + n2
        }
        else{
            newNum = n1*f - n2
        }
        answer += " & = " + "\\dfrac{"+String(newNum)+"}{"+String(d2)+"}\\\\"

        let G = gcd(A: newNum,B: d2)
        if (G != 1){
            answer += "& = " + "\\dfrac{" + String(newNum) + "\\div" + String(G) + "}{" + String(d2) + "\\div" + String(G) + "} \\\\"
            answer += "& = " + "\\dfrac{" + String((newNum) / G) + "}{" + String(d2/G) + "}"
        }
        answer += "\\end{align*}";
        
        raw_data = [newNum/G,d2/G]
    }
    
    func multiplication(){
        let numerateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        let denominateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        n1 = numerateur.randomElement()!;
        n2 = numerateur.randomElement()!;
        d1 = denominateur.randomElement()!;
        d2 = denominateur.randomElement()!;
        
        question = "\\dfrac{" + String(n1) + "}{"+String(d1)+"} \\times \\dfrac{"+String(n2)+"}{"+String(d2)+"}";
        
        answer = "\\begin{align*}"
        answer += "\\dfrac{" + String(n1) + "}{"+String(d1)+"} + \\dfrac{"+String(n2)+"}{"+String(d2)+"}"
        
        answer += "& = \\dfrac{" + String(n1) + "\\times" + String(n2) + "}{"+String(d1)+"\\times"+String(d2)+"}\\\\"
        answer += "& = \\dfrac{" + String(n1*n2) + "}{"+String(d1*d2)+"}\\"
        let G = gcd(A: n1*n2,B: d1*d2)
        if (G != 1){
            answer += "\\\\ & = " + "\\dfrac{" + String(n1*n2) + "\\div" + String(G) + "}{" + String(d1*d2) + "\\div" + String(G) + "} \\\\"
            answer += "& = " + "\\dfrac{" + String(n1*n2/G) + "}{" + String(d1*d2/G) + "}"
        }
        answer += "\\end{align*}";
        
        raw_data = [n1*n2/G, d1*d2/G]
    }
    
    func division(){
        let numerateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        let denominateur = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        n1 = numerateur.randomElement()!;
        n2 = numerateur.randomElement()!;
        d1 = denominateur.randomElement()!;
        d2 = denominateur.randomElement()!;
        
        question = "\\dfrac{" + String(n1) + "}{"+String(d1)+"} \\div \\dfrac{"+String(n2)+"}{"+String(d2)+"}";
        
        answer = "\\begin{align*}"
        answer += "\\dfrac{" + String(n1) + "}{"+String(d1)+"} \\div \\dfrac{"+String(n2)+"}{"+String(d2)+"}"
        answer += "\\dfrac{" + String(n1) + "}{"+String(d1)+"} \\times \\dfrac{"+String(d2)+"}{"+String(n2)+"}"

        answer += "& = \\dfrac{" + String(n1) + "\\times" + String(d2) + "}{"+String(d1)+"\\times"+String(n2)+"}\\\\"
        answer += "& = \\dfrac{" + String(n1*d2) + "}{"+String(d1*n2)+"}\\"
        let G = gcd(A: n1*d2,B: d1*n2)
        if (G != 1){
            answer += "\\\\ & = " + "\\dfrac{" + String(n1*d2) + "\\div" + String(G) + "}{" + String(d1*n2) + "\\div" + String(G) + "} \\\\"
            answer += "& = " + "\\dfrac{" + String(n1*d2/G) + "}{" + String(d1*n2/G) + "}"
        }
        answer += "\\end{align*}";
        
        raw_data = [n1*d2/G, d1*n2/G]
    }
    
}

