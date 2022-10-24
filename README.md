# StarWarsApi - Mobile Developer Test

[![develop](https://github.com/krishanp-1986/star-wars-plannet/actions/workflows/main.yml/badge.svg)](https://github.com/krishanp-1986/star-wars-plannet/actions/workflows/main.yml)

This project is the outcome of Sysco Labs developer Test. Tasks is to implement a mobile app that loads Planets and allows users to view the details.

<br>
<br>
<p align="center">
<img src = "README Files/normal.png" height = 300 width="150">
<img src = "README Files/selected.png" height = 300 width="150">
</p>

### Technical Description
Since this app is medium size, i have decided to implement using **MVVM** with reactive framework **RxSwift/RxCocoa**. UITableViewDiffableDataSource is used to manaage data and provide cell to UITableView. This app supports both offline and online data fetching. By default running the app in simulator will fetch from local json.
```
#if DEBUG
    return MockNetworkAgent()
#else
    return NetworkAgent()
#endif
```

To fetch data from api, change the **Build Configuration to Release**

Light weight Mobile Design System is used to showcase the knowledge in creating Design system. 


### Testing
Unit Tests are part of this assignment, and implemented using  [**Nimble/Quick**](https://github.com/Quick/Nimble), matcher framework for BDD. 
<br>
<br>
<img src = "README Files/coverage.png">

### Continuous Integration
Fastane is used with GihubActions to static analyse code with **SwiftLint**, run unit tests and build debug version of the app without archvining.
<br>
<br>
<img src = "README Files/git-actions.png">

### Instructions
- Clone this develop branch.
- Run **pod install** to install all the dependencies.
- By default this app runs the Mock service in debug mode. To enable live data fetching, run the app in release configuration.

###  Improvements
- Implement UITests and Snapshot testing.
- Improve code coverage
