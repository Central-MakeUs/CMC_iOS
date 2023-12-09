//
//  CheckMyAttendanceCell.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class CheckMyAttendanceCell: UITableViewCell {
		static let reuseIdentifier = "CheckMyAttendanceCell"
		
		// MARK: - UI
		private lazy var allView: UIView = {
				let view = UIView()
				view.translatesAutoresizingMaskIntoConstraints = false
				view.backgroundColor = .clear
				return view
		}()
		
		private lazy var mainImageView: UIImageView = {
				let imageView = UIImageView()
				imageView.translatesAutoresizingMaskIntoConstraints = false
				imageView.backgroundColor = .clear
				imageView.contentMode = .scaleAspectFit
				return imageView
		}()
		
		private lazy var eventStyleLabel: UILabel = {
				let label = UILabel()
				label.translatesAutoresizingMaskIntoConstraints = false
				label.backgroundColor = .clear
				label.textColor = .white
				label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
				return label
		}()
		
		private lazy var eventInfoLabel: UILabel = {
				let label = UILabel()
				label.translatesAutoresizingMaskIntoConstraints = false
				label.backgroundColor = .clear
				label.textColor = .white
				label.numberOfLines = 2
				label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
				return label
		}()
		
		private lazy var eventDataLabel: UILabel = {
				let label = UILabel()
				label.translatesAutoresizingMaskIntoConstraints = false
				label.backgroundColor = .clear
				label.textColor = .systemColorGrayGray300
				label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
				return label
		}()
		
		private lazy var seperatorView: UIView = {
				let view = UIView()
				view.translatesAutoresizingMaskIntoConstraints = false
				view.backgroundColor = .systemColorGrayGray600
				return view
		}()
		
		private lazy var eventTimeLabel: UILabel = {
				let label = UILabel()
				label.translatesAutoresizingMaskIntoConstraints = false
				label.backgroundColor = .clear
				label.textColor = .systemColorGrayGray300
				label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
				return label
		}()
		
		private lazy var devider: UIView = {
				let view = UIView()
				view.translatesAutoresizingMaskIntoConstraints = false
				view.backgroundColor = .separatorPrimaryDark
				return view
		}()
		
		private var disposeBag = DisposeBag()
		
		// MARK: - Initialize
		
		override init(
				style: UITableViewCell.CellStyle,
				reuseIdentifier: String?
		) {
				super.init(style: style, reuseIdentifier: reuseIdentifier)
				setAddSubviews()
				setAddConstraints()
				self.backgroundColor = .black
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		//MARK: - Methods
		private func setAddSubviews() {
				self.contentView.addSubview(allView)
				self.allView.addSubview(mainImageView)
				self.allView.addSubview(eventStyleLabel)
				self.allView.addSubview(eventInfoLabel)
				self.allView.addSubview(eventDataLabel)
				self.allView.addSubview(seperatorView)
				self.allView.addSubview(eventTimeLabel)
				self.allView.addSubview(devider)
		}
		
		private func setAddConstraints() {
				NSLayoutConstraint.activate([
						
						allView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
						allView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
						allView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
						allView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
						
						mainImageView.topAnchor.constraint(equalTo: self.allView.topAnchor),
						mainImageView.leadingAnchor.constraint(equalTo: self.allView.leadingAnchor),
						mainImageView.widthAnchor.constraint(equalToConstant: 84),
						mainImageView.heightAnchor.constraint(equalToConstant: 84),
						
						eventStyleLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor),
						eventStyleLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 16),
						
						eventInfoLabel.topAnchor.constraint(equalTo: eventStyleLabel.bottomAnchor, constant: 4),
						eventInfoLabel.leadingAnchor.constraint(equalTo: eventStyleLabel.leadingAnchor),
						eventInfoLabel.trailingAnchor.constraint(equalTo: self.allView.trailingAnchor),
						
						eventDataLabel.bottomAnchor.constraint(equalTo: self.allView.bottomAnchor),
						eventDataLabel.leadingAnchor.constraint(equalTo: eventStyleLabel.leadingAnchor),
						
						seperatorView.leadingAnchor.constraint(equalTo: eventDataLabel.trailingAnchor, constant: 6),
						seperatorView.centerYAnchor.constraint(equalTo: eventDataLabel.centerYAnchor),
						seperatorView.heightAnchor.constraint(equalToConstant: 8),
						seperatorView.widthAnchor.constraint(equalToConstant: 1),
						
						eventTimeLabel.leadingAnchor.constraint(equalTo: seperatorView.trailingAnchor, constant: 6),
						eventTimeLabel.bottomAnchor.constraint(equalTo: self.allView.bottomAnchor),
						
						devider.leadingAnchor.constraint(equalTo: self.allView.leadingAnchor),
						devider.trailingAnchor.constraint(equalTo: self.allView.trailingAnchor),
						devider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
						devider.heightAnchor.constraint(equalToConstant: 1)
				
				])
		}
		
		func configureCell(eventList: CSEventListModel) {
				if eventList.isCaption {
						eventStyleLabel.text = "real_time_captioning".localized()
						eventStyleLabel.textColor = UIColor(hex: 0x55A5F6)
						eventInfoLabel.text = eventList.title
						eventDataLabel.text = onlyDate(data: eventList.dateAtUtc)
						eventTimeLabel.text = onlyTime(data: eventList.dateAtUtc)
						mainImageView.image = UIImage(named: "_24x24Caption")
				} else {
						eventStyleLabel.text = "_scoreboard_info_default".localized()
						eventStyleLabel.textColor = UIColor(hex: 0x93DC00)
						eventInfoLabel.text = eventList.title
						eventDataLabel.text = onlyDate(data: eventList.dateAtUtc)
						eventTimeLabel.text = onlyTime(data: eventList.dateAtUtc)
						if let data = eventList.thumbNail {
								mainImageView.image = UIImage(data: data)
						}
				}
		}
		
		private func bind() {
				
		}
		
}

extension CSEventTableViewCell {
		
		func onlyDate(data: String) -> String {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
				let date = dateFormatter.date(from: data)
				dateFormatter.dateFormat = "dd MMM. yyyy"
				dateFormatter.locale = Locale(identifier: "en_US_POSIX")
				let dateString = dateFormatter.string(from: date ?? Date())
				return dateString
		}
		
		func onlyTime(data: String) -> String {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
				let date = dateFormatter.date(from: data)
				dateFormatter.dateFormat = "HH:mm"
				let dateString = dateFormatter.string(from: date ?? Date())
				return dateString
		}
}
