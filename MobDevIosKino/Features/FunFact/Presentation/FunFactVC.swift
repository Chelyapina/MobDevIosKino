import UIKit
class FunFactVC : UIViewController {
    
    let factText = UILabel()
    
    override func loadView()
    {
        super.loadView() // для инициализации
    }
    override func viewDidLoad()
    {
        super.viewDidLoad() // для инициализации
        
        factText.text = ""
        //factText.backgroundColor
    }
}
