//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Volha Furs on 25.05.22.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var daylabel = UILabel()
    var iconDayImageView = UIImageView()
    var dayNightLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        daylabel = UILabel()
        iconDayImageView = UIImageView()
        dayNightLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let dayWidth: CGFloat = contentView.bounds.width / 8
        let dayHeight: CGFloat = contentView.bounds.height
        daylabel.frame = CGRect(x: contentView.bounds.minX + dayWidth / 2,
                                y: contentView.bounds.midY - dayHeight / 2,
                                width: dayWidth,
                                height: dayHeight)
//        daylabel.backgroundColor = .yellow
        contentView.addSubview(daylabel)
        
        let iconWidth: CGFloat = contentView.bounds.height
        let iconHeight: CGFloat = contentView.bounds.height
        iconDayImageView.frame = daylabel.frame.offsetBy(dx: dayWidth, dy: 0)
        iconDayImageView.frame.size = CGSize(width: iconWidth,
                                             height: iconHeight)
//        iconDayImageView.backgroundColor = .red
        contentView.addSubview(iconDayImageView)
        
        let dayNightWidth: CGFloat = contentView.bounds.width / 2
        let dayNightHeight: CGFloat = contentView.bounds.height
        dayNightLabel.frame = iconDayImageView.frame.offsetBy(dx: iconWidth * 2, dy: 0)
        dayNightLabel.frame.size = CGSize(width: dayNightWidth,
                                          height: dayNightHeight)
        contentView.addSubview(dayNightLabel)
    }
    
    public func updateDailyTableViewCell(with item: Daily) {
        let date = Date(timeIntervalSince1970: Double(item.dt))
                let formatter = DateFormatter()
                        formatter.dateFormat = "EEEEEE"
                        formatter.calendar = Calendar(identifier: .iso8601)
                        formatter.locale = Locale.current
                        formatter.timeZone = .current
                    let localDate = formatter.string(from: date)
        daylabel.text = localDate
        
        iconDayImageView.image = UIImage(named: item.weather[0].icon)
        dayNightLabel.text = "night: \(String(Int(item.temp.night)))°  day: \(String(Int(item.temp.day)))°"
    }
}
