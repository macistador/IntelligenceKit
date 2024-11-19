// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IntelligenceKit",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "IntelligenceKit", targets: ["IntelligenceKit"]),
        .library(name: "IntelligenceKit-MlxLlm", targets: ["IntelligenceKit-MlxLlm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift", from: "0.18.1"),
        .package(url: "https://github.com/huggingface/swift-transformers", branch: "preview")
    ],
    targets: [
        .target(name: "IntelligenceKit-MlxLlm",
                dependencies: [
                    .product(name: "MLX", package: "mlx-swift"),
                    .product(name: "MLXFast", package: "mlx-swift"),
                    .product(name: "MLXFFT", package: "mlx-swift"),
                    .product(name: "MLXLinalg", package: "mlx-swift"),
                    .product(name: "MLXNN", package: "mlx-swift"),
                    .product(name: "MLXOptimizers", package: "mlx-swift"),
                    .product(name: "MLXRandom", package: "mlx-swift"),
                    .product(name: "Transformers", package: "swift-transformers")
                ],
                path: "Sources/IntelligenceKit-MlxLlm"),
        .target(name: "IntelligenceKit",
                dependencies: [
                    .target(name: "IntelligenceKit-MlxLlm"),
                    .product(name: "Transformers", package: "swift-transformers")
                ],
                path: "Sources/IntelligenceKit"),
    ]
)
