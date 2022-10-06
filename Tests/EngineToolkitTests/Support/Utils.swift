extension Array where Element == UInt8 {
     func toHexString() -> String {
           var hexString: String = ""
           var count = self.count
           for byte in self
           {
               hexString.append(String(format:"%02x", byte))
               count = count - 1
               if count > 0
               {
                   hexString.append("")
               }
           }
           return hexString
     }
}

extension Array where Element == UInt8 {
    init(hex: String) {
        self.init()
        
        let utf8 = [Element.IntegerLiteralType](hex.utf8)
        for idx in stride(from: 0, to: utf8.endIndex, by: utf8.startIndex.advanced(by: 2)) {
            let byteHex = "\(UnicodeScalar(utf8[idx]))\(UnicodeScalar(utf8[idx.advanced(by: 1)]))"
            if let byte = UInt8(byteHex, radix: 16) {
                self.append(byte)
            }
        }
    }
}
