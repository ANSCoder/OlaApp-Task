# OlaApp-Task
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org)

This repository contains a **OlaApp-Task** based on Web APIs.
User can see pre fetch car list and able to see the car inside 
the mapView with details.

Application having basic functionality for the Car grouping inside the Map View with custom annotation image.

Car list displaying in the View forms not directly horizontally presented in a short from once user tap on it. 
App will start to display details about the car. 🚗 

*This is the one pager 📟  application and truly handy in a single page.*

- **Concept of the application** - App will fetch the users current location based on location it will display the 
Available rental cars.
Application having functionalists for the display Car type like Mini, Luxury, Premium.
Based on selection use can view the cars details and able to do booking.


<p align="center">
  <img src="https://user-images.githubusercontent.com/19596311/68887351-d9b36180-073e-11ea-8c46-a0210f15190e.png" width="250">
  <img src="https://user-images.githubusercontent.com/19596311/68887352-da4bf800-073e-11ea-870e-458764e52eb0.png" width="250">
  <img src="https://user-images.githubusercontent.com/19596311/68887354-da4bf800-073e-11ea-9eb9-a159078ce705.png" width="250">
</p>
<br>
<br>

## Features 

- [x] Map View  
- [x] Car Details
- [x] Car Types
- [x] Book car


## Requirements

- iOS 13.1+
- Xcode 11.1

### Project Structure
 
 
    ├─ Common 
      ├─ StoryBoarded
      ├─ LoadingViewController
      ├─ ImageProvider
      ├─ Extensions
      ├─ ANCustomView
    ├─ Networking
    ├─ Home
      ├─ Remote 
      ├─ Model
      ├─ ViewModel
      ├─ View (ViewController, Cell, Annotation View)
      
      
  ## Swift Package Manager
    
    - RxSwift
    
```swift
    dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
  ],
  targets: [
    .target(name: "OlaApp-Task", dependencies: ["RxSwift", "RxCocoa"])
  ]
```

## Architecture

* MVVM [Model View ViewModel]

  This project completely developed in MVVM design patten.
  

  
## Image Downloading & Cache 
  * This class will be responsible for the downloading image asynchronously & cache.

```swift
import UIKit


struct ImageProvider {
    
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    internal var cache = NSCache<NSURL, UIImage>()

    
    //MARK: - Fetch image from URL and Images cache
    func loadImages(from url: NSURL, completion: @escaping (_ image: UIImage) -> Void) {
        downloadQueue.async(execute: { () -> Void in
            if let image = self.cache.object(forKey: url) {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            
            do{
                let data = try Data(contentsOf: url as URL)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: url)
                        completion(image)
                    }
                } else {
                    print("Could not decode image")
                }
            }catch {
                print("Could not load URL: \(url): \(error)")
            }
        })
    }
}

```


## Networking 🚀

   Inside this application networking handling by Endpoint. It is responsible for the creation of URL path.
   
```swift

struct Endpoint {
    let path: String
    
    enum Errors: Error {
        case invalidURL
    }
}


extension Endpoint {

    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "www.mocky.io"
        components.path = path
        return components.url
    }
}

extension Endpoint{
    static func fetchVehicleList() -> Endpoint{
        return Endpoint(
            path: "/v2/5dc3f2c13000003c003477a0"
        )
    }
}

```

 * Networking  wrapper completely written Generic it's capable for handle any kind of response data.
 
 
 ```swift
 typealias Networking = (Endpoint) -> Future<Data>

extension URLSession {
    func request(_ endpoint: Endpoint) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()
        
        // Immediately reject the promise in case the passed
        // endpoint can't be converted into a valid URL
        guard let url = endpoint.url else {
            promise.reject(with: Endpoint.Errors.invalidURL)
            return promise
        }
        
        let task = dataTask(with: url) { data, _, error in
            // Reject or resolve the promise, depending on the result
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        task.resume()
        
        return promise
    }
}
 ```
 
 
 ## Remote class
 
    Inside this class created `loadProduct()` function for the specific path it’s could be based on URL request.
    Return type required to define here `Future<Vehicles>`.
 
 ```swift
 struct VehicleLoader {
    
    private let networking: Networking
    
    init(networking: @escaping Networking = URLSession.shared.request) {
        self.networking = networking
    }
    
    func loadProduct() -> Future<Vehicles> {
        return networking(.fetchVehicleList()).decoded()
    }
}
 ```
 
 
  * Use of this wrapper inside the project 
  
  
```swift 
let vehicleLoader = VehicleLoader()
vehicleLoader.loadProduct().observe { result in
                switch result{
                case .success(let values):
                    debugPrint(values)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
```

## JSONDecoding
   Model inside this application are using the `Codable` protocol. 
   Response from Network request in a from of Data decoding by `extension Future`. 
   
```swift
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

extension Future where Value == Data {
    func decoded<T: Decodable>() -> Future<T> {
        return transformed{ try newJSONDecoder().decode(T.self, from: $0) }
    }
}
```

## Storyboarded 
    This Protocol basically using for the UIViewController initialization.

```swift 
protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
```
 * Use of it.
 
```swift
 let mapViewController = MapViewController.instantiate()
```




##  UI Components & Apple APIs

- [x] Storyboard 
- [x] Coadable Protocol
- [x] UICollectionView
- [x] UIAlertController
- [x] MKMapView
- [x] UIStackView


## UIViewController Extension 
   This is using for display the Loadingview which works with the `RxBinder` for add and remove form UIViewController.

```swift
extension UIViewController{
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public var isAnimating: Binder<Bool> {
        let loadingViewController = LoadingViewController()
        
        return Binder(self, binding: {[weak self] (vc, active) in
            if active {
                self?.add(loadingViewController)
            } else {
                loadingViewController.remove()
            }
        })
    }
}
```


## 👤 Author

**Anscoder** [(Anand Nimje)](https://twitter.com/anand8402) 




    
