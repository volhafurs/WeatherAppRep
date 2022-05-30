//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Volha Furs on 24.05.22.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    var timeLabel = UILabel()
    var hourlyIcon = UIImageView()
    var hourlyTemp = UILabel()
    
    override init(frame: CGRect) {
        timeLabel = UILabel()
        hourlyIcon = UIImageView()
        hourlyTemp = UILabel()
        
        super.init(frame: frame)
        contentView.addSubview(timeLabel)
        contentView.addSubview(hourlyIcon)
        contentView.addSubview(hourlyTemp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        let itemWidth: CGFloat = contentView.bounds.width - 10
        let itemHeight: CGFloat = contentView.bounds.height / 3
        
        timeLabel.frame = CGRect(x: contentView.bounds.midX - itemWidth / 2,
                                 y: contentView.bounds.minY,
                                 width: itemWidth,
                                 height: itemHeight)
        timeLabel.textAlignment = .center
        
        let iconWidth: CGFloat = contentView.bounds.height / 2.5
        let iconHeight: CGFloat = contentView.bounds.height / 2.5
        hourlyIcon.frame = timeLabel.frame.offsetBy(dx: contentView.bounds.height / 3.5, dy: itemHeight)
        hourlyIcon.frame.size = CGSize(width: iconWidth, height: iconHeight)
        hourlyTemp.textAlignment = .center
        
        hourlyTemp.frame = hourlyIcon.frame.offsetBy(dx: 0, dy: itemHeight)
        hourlyTemp.textAlignment = .center
        
    }
    
    public func updateCollectionViewCell(with item: Current) {
        let date = Date(timeIntervalSince1970: Double(item.dt))
                let formatter = DateFormatter()
                        formatter.dateFormat = "HH"
                        formatter.calendar = Calendar(identifier: .iso8601)
                        formatter.locale = Locale.current
                        formatter.timeZone = .current
                    let localDate = formatter.string(from: date)
        timeLabel.text = localDate
        
        hourlyIcon.image = UIImage(named: item.weather[0].icon)
        hourlyTemp.text = "\(String(Int(item.temp)))°"
    }
}
