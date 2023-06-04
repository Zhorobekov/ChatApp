//
//  Constants.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 01.03.2023.
//

import UIKit

enum Constants {
    
    enum Main {
        static let navigationTitle = "Channels"
        static let tabBarIcon = UIImage(systemName: "bubble.left.and.bubble.right")
    }
    
    enum Settings {
        static let title = "Settings"
        static let tabBarIcon = UIImage(systemName: "gear")
    }
    
    enum Profile {
        static let title = "My Profile"
        static let tabBarIcon = UIImage(systemName: "person.circle")
        static let editableNameTitle = "Name"
        static let editableNamePlaceholder = "Enter your name"
        static let editableBioTitle = "Bio"
        static let editableBioPlaceholder = "Enter your profile description"
        static let nameLabelDefaultValue = "No name"
        static let descriptionLabelDefaultValue = "No bio specified"
        static let personImage = UIImage(named: "person")
        static let ellipsisImage = UIImage(systemName: "ellipsis.circle")
    }
    
    enum Font {
        static let systemBold17 = UIFont.boldSystemFont(ofSize: 17)
        static let systemFont17 = UIFont.systemFont(ofSize: 17)
        static let systemBold22 = UIFont.boldSystemFont(ofSize: 22)
    }

    enum Alert {
        static let closeActionTitle = "Отмена"
        static let makePhotoActionTitle = "Сделать фото"
        static let chooseFromGalleryActionTitle = "Выбрать из галереи"
        static let download = "Загрузить"
        static let cameraAccessAlertTitle = "Доступ к камере запрещен"
        static let cameraAccessAlertMessage = "Необходимо разрешить доступ к камере для установки фот"
        static let settingsActionTitle = "Настройки"
    }
    
    enum Conversation {
        static let topNavigationColor = UIColor.systemGray5
        static let avatarImageViewSize = CGSize(width: 50, height: 50)
        static let nameLabelFont = UIFont.systemFont(ofSize: 11)
        static let chevronImage = UIImage(named: "chevron.left")
        static let sendFieldPlaceholder = NSAttributedString(string: "Type message",
                                                             attributes: [.foregroundColor: UIColor.systemGray])
        static let arrowUpImage = UIImage(systemName: "arrow.up")
    }
    
    enum ThemeButton {
        static let lightImageName = "lightThemeImage"
        static let darkImageName = "darkThemeImage"
        static let dayString = "Day"
        static let darkString = "Dark"
        static let chekmarkImage = UIImage(named: "checkmarkSelectedImage")
        static let chekmarkImageSize = CGSize(width: 20, height: 20)
    }
    
    enum ConversationCell {
        static let containerTopPadding: CGFloat = 15.5
    }
    
    static let navigationTitle = "My Profile"
    static let editButtonTitle = "Edit"
    static let cancelButtonTitle = "Cancel"
    static let addPhotoButtonTitle = "Add photo"
}
