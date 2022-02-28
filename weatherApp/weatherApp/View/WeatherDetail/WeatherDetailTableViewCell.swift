//
//  WeatherDetailTableViewCell.swift
//  weatherApp
//
//  Created by abc on 2022/02/01.
//

import UIKit
import RxSwift

class WeatherDetailTableViewCell: UITableViewCell {
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.numberOfLines = 0
    label.textColor = .white
    label.text = "도시이름 : "
    return label
  }()
  
  lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var stackView: UIStackView = {
    let stackview = UIStackView(arrangedSubviews: [titleLabel, iconImageView])
    stackview.translatesAutoresizingMaskIntoConstraints = false
    stackview.axis = .vertical
    stackview.spacing = 0
    stackview.distribution = .fill
    stackview.alignment = .leading
    stackview.backgroundColor = .clear
    return stackview
  }()
  
  var disposeBag = DisposeBag()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
      self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
    disposeBag = DisposeBag()
  }

}

