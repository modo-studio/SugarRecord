import Foundation

extension String {

  static var documentDirectory: String {
      return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  }
  
}
