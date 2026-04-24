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

---

# PSBTSwift 中文文档

一个全面的比特币部分签名交易（PSBT）Swift 库，支持 BIP-174 和 BIP-370 规范。

## 功能特性

- **PSBT 解析与序列化**：完整支持 PSBT 格式（Base64 和 Hex）
- **交易操作**：创建、合并和完成 PSBT
- **多签支持**：处理来自多个签名者的部分签名
- **Taproot 支持**：完整的 Taproot PSBT 支持，包括 Schnorr 签名
- **HD 密钥派生**：支持 BIP32 扩展密钥和派生路径
- **脚本验证**：全面的脚本类型检测和验证

## 系统要求

- Swift 5.5+
- iOS 13.0+ / macOS 10.15+

## 安装方式

### Swift Package Manager

在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/xueyuejie/PSBTSwift.git", from: "1.0.0")
]
```

## 使用示例

### 创建 PSBT

```swift
import PSBTSwift

// 从交易创建 PSBT
let transaction = Transaction()
// ... 添加输入和输出 ...

let psbt = PSBT(transaction: transaction)
```

### 解析 PSBT

```swift
import PSBTSwift

// 从 Base64 解析
let psbt = try PSBT.fromBase64String(base64String)

// 从 Hex 字符串解析
let psbt = try PSBT.fromString(strPSBT: "70736274ff...")

// 检查字符串是否为有效 PSBT
let isValid = PSBT.isPSBT(s: base64String)
```

### 签名 PSBT

```swift
import PSBTSwift

// 获取 PSBT 输入
let input = psbt.psbtInputs[0]

// 使用 HD 密钥签名
let key = try ExtendedKey.fromDescriptor(descriptor: "xprv...")
let signature = try input.signWithKey(key: key)

// 添加部分签名
input.partialSignatures[pubKey] = signature
```

### 合并 PSBT

```swift
import PSBTSwift

// 合并多个 PSBT
let combinedPsbt = PSBT(transaction: transaction)
try combinedPsbt.combine(psbts: [psbt1, psbt2, psbt3])

// 或合并单个 PSBT
try psbt.combine(psbt: otherPsbt)
```

### 完成 PSBT

```swift
import PSBTSwift

// 检查 PSBT 是否已完成
if psbt.isFinalized() {
    // 提取最终交易
    let finalTx = try psbt.extractTransaction()
}

// 检查 PSBT 是否已签名
if psbt.isSigned() {
    // 可以完成
}
```

### 序列化

```swift
import PSBTSwift

// 序列化为 Base64
let base64 = try psbt.toBase64String()

// 序列化为 Hex
let hex = try psbt.toString(isFromUnisat: true)

// 带选项序列化
let bytes = try psbt.serialize(
    includeXpubs: true,
    includeNonWitnessUtxos: true,
    isFormUnisat: true
)
```

### 手续费计算

```swift
import PSBTSwift

// 获取交易手续费
if let fee = psbt.getFee() {
    print("交易手续费: \(fee) satoshis")
}
```

### 签名验证

```swift
import PSBTSwift

// 验证所有签名
try psbt.verifySignatures()

// 检查是否有签名
let hasSigs = psbt.hasSignatures()
```

### 输入/输出操作

```swift
import PSBTSwift

// 移动输入位置
try psbt.moveInput(fromIndex: 0, toIndex: 1)

// 移动输出位置
try psbt.moveOutput(fromIndex: 0, toIndex: 1)

// 获取密钥派生信息
if let derivation = psbt.getKeyDerivation(publicKey: extendedKey) {
    print("路径: \(derivation.path)")
    print("指纹: \(derivation.masterFingerprint)")
}
```

### 脚本类型

```swift
import PSBTSwift

// 支持的脚本类型：
// - P2PKH（支付到公钥哈希）
// - P2SH（支付到脚本哈希）
// - P2WPKH（支付到见证公钥哈希）
// - P2WSH（支付到见证脚本哈希）
// - P2TR（支付到 Taproot）
```

### Taproot 支持

```swift
import PSBTSwift

// 检查输入是否为 Taproot
if input.isTaproot() {
    // 访问 Taproot 密钥路径签名
    if let sig = input.tapKeyPathSignature {
        // Schnorr 签名
    }
    
    // 访问 Taproot 叶脚本
    let leafScripts = input.tapLeafScript
}
```

## 依赖库

- **CryptoSwift**: 加密操作
- **Secp256k1Swift**: 椭圆曲线加密
- **Bech32**: Bech32 地址编码
- **DataCompression**: 数据解压缩
- **swift-nio**: 非阻塞 I/O
- **Base58Swift**: Base58 编码
- **ASN1**: ASN.1 解析

## 错误处理

```swift
import PSBTSwift

do {
    let psbt = try PSBT.fromBase64String(base64String)
    try psbt.verifySignatures()
    let tx = try psbt.extractTransaction()
} catch let error as PSBTError {
    switch error {
    case .message(let msg):
        print("PSBT 错误: \(msg)")
    case .unknow:
        print("未知错误")
    }
}
```

## PSBT 结构

```swift
// 全局 PSBT 数据
psbt.transaction        // 未签名交易
psbt.version            // PSBT 版本
psbt.extendedPublicKeys // BIP32 扩展公钥
psbt.psbtInputs         // PSBT 输入数组
psbt.psbtOutputs        // PSBT 输出数组
```

## 许可证

MIT License
