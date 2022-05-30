//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Volha Furs on 17.05.22.
//

import UIKit
import AVFoundation

class WeatherViewController: UIViewController {
    
    var player: AVPlayer?
    let basckgroundImage = UIImageView()
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var currentFeelsLikeLabel: UILabel!
    private var hourlyArray: [Current] = []
    private var dailyArray: [Daily] = []
    var cityName: String = ""
    var lat: Float = 0
    var lon: Float = 0
    var collectionView: UICollectionView!
    var dailyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundVideo()
        updateWeatherInfo()
        setupHourlyCollectionView()
        setupDailyTableView()
        print(lat)
        print(lon)
    }
    
    private func setupBackgroundVideo() {
            let path = Bundle.main.path(forResource: "Background", ofType: "mp4")
            player = AVPlayer(url: URL(fileURLWithPath: path!))
            player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.view.layer.insertSublayer(playerLayer, at: 0)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
            player!.seek(to: CMTime.zero)
            player!.play()
            self.player?.isMuted = true
        }
        
        @objc func playerItemDidReachEnd() {
            player!.seek(to: CMTime.zero)
        }
    
    private func updateUI(responce: WeatherResponse) {
        let currentTemp = responce.current.temp
        let currentDescription = responce.current.weather[0].weatherDescription
        let feelsLike = responce.current.feelsLike
        cityNameLabel.text = cityName
        currentTempLabel.text = "\(String(Int(currentTemp)))°"
        currentDescriptionLabel.text = "\(currentDescription)"
        currentFeelsLikeLabel.text = "feels like: \(String(Int(feelsLike)))°"
        self.hourlyArray = responce.hourly
        self.collectionView.reloadData()
        self.dailyArray = responce.daily
        self.dailyTableView.reloadData()
    }
    
    private func setupDailyTableView() {
        self.dailyTableView = UITableView()
        let tableWidth: CGFloat = view.bounds.width - 50
        let tableHight: CGFloat = view.bounds.height / 2
        dailyTableView.frame = CGRect(x: view.bounds.midX - tableWidth / 2,
                                      y: view.bounds.midY + tableHight / 5,
                                 width: tableWidth,
                                 height: tableHight)
        dailyTableView.backgroundColor = .clear
        dailyTableView.alpha = 0.7
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "cell")
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        view.addSubview(dailyTableView)
    }
    
    private func setupHourlyCollectionView () {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.itemSize = CGSize(width: view.bounds.width / 5, height: view.bounds.width / 5)
        let collectionViewWidth: CGFloat = view.bounds.width - 50
        let collectionViewHight: CGFloat = view.bounds.height / 6
        let collectionViewFrame = CGRect(x: view.bounds.midX - collectionViewWidth / 2,
                                         y: view.bounds.midY - collectionViewHight / 2,
                                         width: collectionViewWidth,
                                         height: collectionViewHight)
        self.collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowlayout)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.backgroundColor = .systemGray5
        collectionView.backgroundColor = .clear
        collectionView.alpha = 0.7
        collectionView.layer.cornerRadius = 15
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func updateWeatherInfo() {
        let stringURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=4071dfd02cf6a99c04643a273e442a29&units=metric"
           guard let url = URL(string: stringURL) else {
               return
           }
           let request = URLRequest(url: url)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let data = data {
                   let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                   print(weatherResponse)
                   guard let weatherResponse = weatherResponse else {return}
                   DispatchQueue.main.async { [self] in
                       updateUI(responce: weatherResponse)
                   }
               }
           }
           task.resume()
       }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HourlyCollectionViewCell
        cell.updateCollectionViewCell(with: hourlyArray[indexPath.row])
        cell.backgroundColor = .gray
        cell.alpha = 0.7
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyArray.count / 2
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dailyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        cell.updateDailyTableViewCell(with: dailyArray[indexPath.row])
        cell.backgroundColor = .gray
        cell.alpha = 0.7
        return cell
    }
}
