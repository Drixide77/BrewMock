# BrewMock

A mockup iOS app done for a test (iPhone only).

### Files and Classes

- AppDelegate.swift: Contains the AppDelegate class. Holds the reference to DataModel.
- SceneDelegate.swift: Contains the default SeceneDelegate (iOS 13).
- MainViewController.swift: ViewController for the main view. It contains the code for both the View and ViewModel.
- DataModel.swift: Contains the Model code, along with the networking and the Beer data model class.
- BeerTableViewCell.swift: contains the class for the custom UITableView cells.

### Possible Improvements

- Use an LRUCache for the requests. This way we are limiting the amount of stored data while keeping the more relevant data when overwriting.
- More efficient sort algorithm and/or pre-sorting the current list.
- Better filtering for the search input.
- UI and design improvements. A detail view when selecting a beer.
