//
//  ImagePicker.swift
//  Twitter Clone
//
//  Created by mac on 3/22/25.
//
import SwiftUI

// 1. ImagePicker 选择图片配置
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    // 创建协调器
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // 创建UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary  // 设置图片来源为图库
        picker.allowsEditing = false // 是否允许编辑
        return picker
    }
    
    // 更新UIViewController，不需要在这个方法里做任何操作
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// Coordinator 类：处理UIImagePickerController的代理方法
extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // 选择图片后的回调
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.selectedImage = image  // 将选中的图片传递给绑定的变量
            parent.presentationMode.wrappedValue.dismiss()  // 关闭 picker
        }
        
        // 取消选择图片后的回调
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()  // 关闭 picker
        }
    }
}
