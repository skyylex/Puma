## Getting Started

Hi! Welcome to Puma, a pure Swift build tool utilities designed to easy mobile application development and deployment. Unlike other command line tools, Puma is designed to be used as a Swift package, which means it is just Swift code and you have total control over the program.

The recommended way to integrate Puma is via [Swift Package Manager](https://swift.org/package-manager/), although you are free to use any package manager that you like.

## Run Puma as standalone executable

### Creating executable with Swift Package Manager

With Swift Package Manager, started by creating an executable and add Puma as a dependency

```sh
mkdir MyBuildTool
cd MyBuildTool
swift package init --type executable
```

Inside your `Package.swift`, add Puma as dependencies

```swift
import PackageDescription

let package = Package(
    name: "Puma",
    platforms: [.macOS("10.15")],
    products: [
        .library(name: "MyBuildTool", targets: ["MyBuildTool"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pumaswift/Puma.git",
            .upToNextMajor(from: "0.0.1")
        )
    ]
)
```

Go to MyBuildTool/Sources/MyBuildTool/main.swift and start using tasks from Puma

```swift
import Foundation
import Puma
import PumaCore
import PumaiOS

run {
    PrintWorkingDirectory()
    
    RunScript {
        $0.script = "echo 'Hello Puma'"
    }
    
    SetVersionNumber {
        $0.isEnabled = false
        $0.versionNumberForAllTargets("1.1")
    }
    
    SetBuildNumber {
        $0.isEnabled = false
        $0.buildNumberForAllTargets("2")
    }
    
    Build {
        $0.isEnabled = false
        $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
        $0.buildsForTesting = true
    }
}
```

Now build and run, Swift Package Manager wil fetch all dependencies and build your executable

```sh
swift build
swift run
```

### Frameworks inside Puma

Puma is declared as a library, where Puma is the facade, and it includes some other dependencies. If you use a class or method from a framework, you need to import the correct one.

In the code sample above, we use `run` method from `Puma`, `PrintWorkingDirectory`, `RunScript` from `PumaCore` and `SetVersionNumber`, `SetBuildNumber`, `Build` from `PumaiOS`. This separation of concerns makes it easier to develop and consume, as well as makes extending feasible.

```swift
import Foundation
import Puma
import PumaCore
import PumaiOS
```

- Puma: The facade, which exposes convenient `run` function, and includes other frameworks
- PumaCore: Contains the core utilities, Task protocol and some core tasks
- PumaiOS: Contains iOS related tasks.
- PumaAndroid: Contains Android related tasks. TBD
- PumaExtra: Contains extra tasks. TBD

For more information, read our [Task and workflow](TaskAndWorkflow.md) guide.

## Run Puma as macOS command line application

Another way to consume Puma is via Xcode. Create a macOS command line application and add Puma via Swift Package Manager in Xcode. This is the same way Puma is developed via [TestPuma](https://github.com/pumaswift/Puma/tree/develop/Example/TestPuma), for more information, read our [Develop](./Develop.md) guide.

