# Books

### Summary
Simple lightweight iOS app listing books. It consists of two basic scenes, one for listing books and a second one for displaying more info of a single selected book. Demonstrates the use of a CleanSwift architecture scheme in Swift and its possible extension/combination with SwiftUI Views. Unit, snapshot and UI testing is used in combination to cover the full functionality.


### App lifecycle
No scene support, use of UIApplicationDelegate.
The AppDelegate creates a window and a Router object.
The Router then displays a dummy Splash scene while making the Dependencies container and initializing the objects shared between the different screens: APIClient, Persistency & Routing for now, all connected through their corresponding protocols for better decoupling and testing.


### Dependencies
External dependencies through SPM only:
- SnapKit - for easy autolayout by code
- Kingfisher - image async load & cache
- SnapshotTesting
- Fakery - faking data


### Data
The Books API from NY Times is used to fetch some simple books listing:
https://developer.nytimes.com/docs/books-product/1/overview
The BooksAPIStore uses it to fetch NY Times "combined-print-and-e-book-fiction" listing.
Another BooksFakeryStore is also available for working with completely fake data.


### Scenes

![Scenes](https://user-images.githubusercontent.com/1202386/161102595-8f14235d-4077-4d7c-9343-344dde6503d5.png)

- ##### Splash:
 a dummy scene visible during the initial setup
- ##### List:
 fetches books through the BooksWorker & lists them in a table. Paging functionality is implemented but disabled for the time being, as the NYTimes API does not provide long listings to implement paging with.
- ##### Detail:
  simple scene displaying more info of a single book - not any user interaction yet. Two flavors of the same scene are implemented: one in CleanSwift (working in *Detail_in_Swift* tag) and one in SwiftUI in main branch. A custom modal presentation is used to present & dismiss the CleanSwift flavor.


### Architecture

The basic scheme of the CleanSwift architecture used is displayed in the graph below:

![CleanVIP](https://user-images.githubusercontent.com/1202386/160439487-c1a73443-486f-4f66-a3d2-0ba7c6ae8ea2.png)

Scenes are driven by the ViewController and the rest of the elements are configured upon its initialization. The dependency injection is done by property and takes place on the corresponding router after initializing the VC and before loading and presenting its view.

The SwiftUI view follows a simple MVVM scheme with a simplistic ViewModel, as there is no real interaction or dynamic data loading yet in this view.



### Workers & Stores
  Workers are initialized and retained in the interactors. Dependencies objects are injected to them along with specific stores for them to combine. In our simple case, a single BooksWorker is used to fetch the books listing. A books store for fetching books and an element for persisting them is injected through protocols for better decoupling.
  Methods are declared for fetching book details & posting books but are not yet fully implemented.



### Testing
Unit testing is carried out for all VIP scene elements written in Swift, focusing on the input/output protocols of each element. The BooksWorker is tested using spies for the BooksStore & the persistency handler.
The SwiftUI BookDetailView is tested through snapshots for each possible view state. Snapshot testing is carried out for List scene & Detail scene in swift as well for their basic states.
A simple UI test is written on top of it all to assure correct launch and navigation through the scenes.
