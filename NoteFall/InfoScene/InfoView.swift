import UIKit

class InfoView: UIView {
    
    private let welcomeLabel = Label(withText: Localization.welcomeToNotefall, size: 16, weight: .bold, alignment: .left)
    private let infoLabel = Label(withText: "The object of the game is to play or sing the note displayed before it disappears off the screen. Score more points by hitting as many correct notes as possible! \n\n Adjust the different settings on the Settings page to fit your instrument.", size: 16)
    
    private let supportLabel = Label(withText: "Support: notefall@swatland.dev", size: 12, weight: .bold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        layer.cornerRadius = 24
        
        setupLabels()
    }
    
    private func setupLabels() {
        addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(supportLabel)
        NSLayoutConstraint.activate([
            supportLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32),
            supportLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            supportLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
