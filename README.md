# PSBTSwift

A comprehensive Swift library for Partially Signed Bitcoin Transaction (PSBT) operations, supporting BIP-174 and BIP-370 specifications.

## Features

- **PSBT Parsing & Serialization**: Full support for PSBT format (Base64 and Hex)
- **Transaction Operations**: Create, combine, and finalize PSBTs
- **Multi-Signature Support**: Handle partial signatures from multiple signers
- **Taproot Support**: Complete Taproot PSBT support including Schnorr signatures
- **HD Key Derivation**: BIP32 extended key support with derivation paths
- **Script Validation**: Comprehensive script type detection and validation

## Requirements

- Swift 5.5+
- iOS 13.0+ / macOS 10.15+

## Installation

### Swift Package Manager

Add PSBTSwift to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xueyuejie/PSBTSwift.git", from: "1.0.0")
]
```

## Usage

### Creating PSBT

```swift
import PSBTSwift

// Create PSBT from transaction
let transaction = Transaction()
// ... add inputs and outputs ...

let psbt = PSBT(transaction: transaction)
```

### Parsing PSBT

```swift
import PSBTSwift

// Parse from Base64
let psbt = try PSBT.fromBase64String(base64String)

// Parse from Hex string
let psbt = try PSBT.fromString(strPSBT: "70736274ff...")

// Check if string is valid PSBT
let isValid = PSBT.isPSBT(s: base64String)
```

### Signing PSBT

```swift
import PSBTSwift

// Get PSBT input
let input = psbt.psbtInputs[0]

// Sign with HD key
let key = try ExtendedKey.fromDescriptor(descriptor: "xprv...")
let signature = try input.signWithKey(key: key)

// Add partial signature
input.partialSignatures[pubKey] = signature
```

### Combining PSBTs

```swift
import PSBTSwift

// Combine multiple PSBTs
let combinedPsbt = PSBT(transaction: transaction)
try combinedPsbt.combine(psbts: [psbt1, psbt2, psbt3])

// Or combine single PSBT
try psbt.combine(psbt: otherPsbt)
```

### Finalizing PSBT

```swift
import PSBTSwift

// Check if PSBT is finalized
if psbt.isFinalized() {
    // Extract final transaction
    let finalTx = try psbt.extractTransaction()
}

// Check if PSBT is signed
if psbt.isSigned() {
    // Ready to finalize
}
```

### Serialization

```swift
import PSBTSwift

// Serialize to Base64
let base64 = try psbt.toBase64String()

// Serialize to Hex
let hex = try psbt.toString(isFromUnisat: true)

// Serialize with options
let bytes = try psbt.serialize(
    includeXpubs: true,
    includeNonWitnessUtxos: true,
    isFormUnisat: true
)
```

### Fee Calculation

```swift
import PSBTSwift

// Get transaction fee
if let fee = psbt.getFee() {
    print("Transaction fee: \(fee) satoshis")
}
```

### Signature Verification

```swift
import PSBTSwift

// Verify all signatures
try psbt.verifySignatures()

// Check if has signatures
let hasSigs = psbt.hasSignatures()
```

### Input/Output Operations

```swift
import PSBTSwift

// Move input position
try psbt.moveInput(fromIndex: 0, toIndex: 1)

// Move output position
try psbt.moveOutput(fromIndex: 0, toIndex: 1)

// Get key derivation info
if let derivation = psbt.getKeyDerivation(publicKey: extendedKey) {
    print("Path: \(derivation.path)")
    print("Fingerprint: \(derivation.masterFingerprint)")
}
```

### Script Types

```swift
import PSBTSwift

// Supported script types:
// - P2PKH (Pay to Public Key Hash)
// - P2SH (Pay to Script Hash)
// - P2WPKH (Pay to Witness Public Key Hash)
// - P2WSH (Pay to Witness Script Hash)
// - P2TR (Pay to Taproot)
```

### Taproot Support

```swift
import PSBTSwift

// Check if input is Taproot
if input.isTaproot() {
    // Access Taproot key path signature
    if let sig = input.tapKeyPathSignature {
        // Schnorr signature
    }
    
    // Access Taproot leaf scripts
    let leafScripts = input.tapLeafScript
}
```

## Dependencies

- **CryptoSwift**: Cryptographic operations
- **Secp256k1Swift**: Elliptic curve cryptography
- **Bech32**: Bech32 address encoding
- **DataCompression**: Data decompression
- **swift-nio**: Non-blocking I/O
- **Base58Swift**: Base58 encoding
- **ASN1**: ASN.1 parsing

## Error Handling

```swift
import PSBTSwift

do {
    let psbt = try PSBT.fromBase64String(base64String)
    try psbt.verifySignatures()
    let tx = try psbt.extractTransaction()
} catch let error as PSBTError {
    switch error {
    case .message(let msg):
        print("PSBT error: \(msg)")
    case .unknow:
        print("Unknown error")
    }
}
```

## PSBT Structure

```swift
// Global PSBT data
psbt.transaction        // Unsigned transaction
psbt.version            // PSBT version
psbt.extendedPublicKeys // BIP32 extended public keys
psbt.psbtInputs         // PSBT inputs array
psbt.psbtOutputs        // PSBT outputs array
```

## License

MIT License
