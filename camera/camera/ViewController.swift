//
//  ViewController.swift
//  camera
//
//  Created by Mateus Rodrigues Santos on 01/07/19.
//  Copyright © 2019 Mateus Rodrigues Santos. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreImage

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let contexto = CIContext()
    var imagemURL:URL?
    var imagem:UIImage?
    
    @IBOutlet weak var apresentadorImagem: UIImageView!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

      
    }
    
    @IBAction func filtroTres(_ sender: Any) {
        filtro(3)
    }
    
    @IBAction func filtroDois(_ sender: Any) {
        filtro(2)
    }
    
    @IBAction func filtroUm(_ sender: Any) {
        filtro(1)
    }
    
    func filtro(_ indice: Int){
        //Carregando imagem para processamento
        switch indice {
        case 1:
            if imagemURL != nil{
                let originalCIImage = CIImage(contentsOf: imagemURL!)
                
                let sepiaCIImage = sepiaFilter(originalCIImage!, intensity:0.9)
                
                self.apresentadorImagem.image = UIImage(ciImage: sepiaCIImage!)
            }
        case 2:
            if imagemURL != nil{
                let originalCIImage = CIImage(contentsOf: imagemURL!)
                
                let colorMapImage = colorMapFilter(originalCIImage!,originalCIImage!)
                
                self.apresentadorImagem.image = UIImage(ciImage: colorMapImage!)
            }
        case 3:
            if imagemURL != nil{
                let originalCIImage = CIImage(contentsOf: imagemURL!)
                
                let colorMapImage = pinchDistortion(originalCIImage!,300.00,0.50)
                
                self.apresentadorImagem.image = UIImage(ciImage: colorMapImage!)
            }
        default:
            print("ninguem")
        }
   
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func colorMapFilter(_ input: CIImage,_ gradientImage: CIImage) -> CIImage? {
        let colorMap = CIFilter(name:"CIColorMap")
        colorMap?.setValue(input, forKey: "inputImage")
        colorMap?.setValue(gradientImage, forKey: "inputGradientImage")
        return colorMap?.outputImage
    }
    
    func pinchDistortion(_ input: CIImage,_ radianos: CGFloat,_ escala: CGFloat) -> CIImage?{
        let pinchDistortion = CIFilter(name: "CIPinchDistortion", parameters: ["inputImage" : input,
           "inputCenter": CIVector(x: 150, y: 150),
           "inputRadius": radianos,
           "inputScale":escala])
        return pinchDistortion?.outputImage
    }
    
    

    @IBAction func salvarFoto(_ sender: Any) {
        if let imageData = apresentadorImagem.image?.jpegData(compressionQuality: 1){
            let compressed = UIImage(data: imageData)
        
            UIImageWriteToSavedPhotosAlbum(compressed!, nil, nil, nil)
        }
    }
    
    @IBAction func abrirBiblioteca(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            let biblioteca = UIImagePickerController()
            biblioteca.delegate = self
            biblioteca.sourceType = .photoLibrary
            biblioteca.allowsEditing = true
            self.present(biblioteca, animated: false, completion: nil)
        }
    }
    
    @IBAction func abrirCamera(_ sender: Any) {
        //Ver se o dispositivo é capaz de acessar o conteúdo do enum selecionado, no caso: foi o camera(UIImagePickerController.SourceType.camera)
        if
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            //1- Criando uma variável câmera
            let camera = UIImagePickerController()
            //2- Selecionando um delegate para a câmera
            camera.delegate = self
            //3-Selecionando o tipo da interface
            camera.sourceType = .camera
            //4-Dizendo se a imagem será editável, quando tirar a foto
            camera.allowsEditing = true
            //5-Selecionando as mídias que a camera vai utilizar
            camera.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.camera)!
            //6-Definindo uma qualidade para video
            camera.videoQuality = UIImagePickerController.QualityType.typeHigh
            
            camera.showsCameraControls = true
            //6-Apresentando a view na tela
            self.present(camera, animated: false, completion: nil)
            
      
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        var videoObtido:NSURL?
        var fotoEditada:UIImage?
        var fotoOriginal:UIImage?
        
        if let imagemEditada = info[UIImagePickerController.InfoKey.editedImage]{
            fotoEditada = imagemEditada as? UIImage
            self.imagem = fotoEditada
            self.imagemURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        }

        if let imagemOriginal = info[UIImagePickerController.InfoKey.originalImage]{
            fotoOriginal = imagemOriginal as? UIImage
            self.imagem = fotoOriginal
            self.imagemURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        }
        
        if let video = info[UIImagePickerController.InfoKey.mediaURL]{
            videoObtido = video as? NSURL
        }
        
        if fotoEditada != nil && fotoOriginal != nil{
            apresentadorImagem.image = fotoEditada
            dismiss(animated: true, completion: nil)
        }else{
            apresentadorImagem.image = fotoOriginal
            dismiss(animated: true, completion: nil)
        }
        
        
        
        if videoObtido != nil{
            let player = AVPlayer(url: videoObtido!  as URL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            
            playerController.view.frame = CGRect(x: 88, y: 557, width: 240, height: 128)
            
            dismiss(animated: true, completion: nil)
            
            self.view.addSubview(playerController.view)
            self.addChild(playerController)
        }
        
        
       print(info[UIImagePickerController.InfoKey.imageURL])
        print("Imagem url \(self.imagemURL)")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

}

