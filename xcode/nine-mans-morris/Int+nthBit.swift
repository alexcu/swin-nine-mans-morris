//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// Extension to Swift's Integer class
///
extension Int {
    ///
    /// Returns the n'th bit of this integer
    ///
    func nthBit(n: Int) -> Int {
        return (self >> n) & 1
    }
}