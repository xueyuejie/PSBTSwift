//
//  P2WSHAddress.swift
//
//
//  Created by 薛跃杰 on 2024/1/25.
//

import Foundation
import Bech32

public class P2WSHAddress: Address {
    public override init(_ data: [UInt8]) {
        super.init(data)
    }

    public override func getVersion(network: Network) -> Int {
        return 0
    }
    
    public override func getAddress(network: Network) -> String {
        return Bech32().encode(network.bech32AddressHrp, values: Data(data), encoding: Bech32.Encoding.bech32)
    }

    public override func getScriptType() -> ScriptType {
        return .P2WSH
    }

    public func getOutputScriptDataType() -> String {
        return "Witness Script Hash"
    }
    
    public func fromProgram(program: [UInt8]) -> P2WSHAddress {
        return P2WSHAddress(Data(program).sha256().bytes)
    }
}
