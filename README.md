# Books

Simple lightweight iOS app for discovering books. 

### Summary
The app consists of two basic scenes, one for listing books from NYTimes Best-sellers list and their API and a second scene for displaying more info of a single selected book and navigating to its preview if found so you can read a small chunk.
Previews are available for older boooks only, so you have to choose an older date to get to preview a book. 
  
The code demonstrates the use of a CleanSwift architecture scheme in Swift and its possible extension/combination with SwiftUI Views. Unit, snapshot, integration and UI testing are used in combination to cover the full functionality and achieve a high coverage rate.


### App lifecycle
No scene support, use of UIApplicationDelegate.

The AppDelegate creates a window and a Router object.
The Router then displays a dummy Splash ViewController while making the Dependencies container and initializing the objects shared between the different screens: APIClient, Persistency & Routing for now, all connected through their corresponding protocols for better decoupling and testing.

Dependency injection is done by initialization. After all dependencies are created, the dummy splash is dismissed and all VCs from now on are CleanSwift VIP ones. The dependency container is passed to each VC in its initialization method which configures all VIP parts using the container when needed.  


### External dependencies
 SPM only:
- SnapKit - for easy autolayout by code
- Kingfisher - image async load & cache
- SnapshotTesting
- Fakery - faking data


### Data
The Books API from NY Times is used to fetch some simple books listing by date:
https://developer.nytimes.com/docs/books-product/1/overview
The BooksAPIStore uses it to fetch NY Times "hardcover-fiction" listing.
Another BooksFakeryStore is also available for working with completely fake data.

Then the OpenLibrary Books API is used inside the book Detail to link to the book preview if any: 
https://openlibrary.org/dev/docs/api/books


### Scenes

![Scenes](https://user-images.githubusercontent.com/1202386/161102595-8f14235d-4077-4d7c-9343-344dde6503d5.png)

- ##### Splash:
 A dummy scene visible during the initial setup
- ##### List:
 Fetches books through the BooksWorker & lists them in a table. Provides a date selector so you can scroll back through time and check the best-sellers of the selected date. Paging functionality was previously implemented but now removed, as the NYTimes API returns a small amount of books in each request. 
- ##### Detail:
  Simple scene displaying more info of a single book. Fetches the book preview URL and displays a button to display the preview in Safari if found.  A custom modal presentation is used to present & dismiss this scene.
   Another flavor of the same scene is implemented in SwiftUI. The SwiftUI view follows a simple MVVM scheme with a simplistic ViewModel as a first approximation, as there is no real interaction or dynamic data loading yet in this view.  
   The switch between the flavors of the Detail scene is done in ListRouter through the boolean property 'useSwiftUIDetail'.


### Architecture

The basic scheme of the CleanSwift architecture used is displayed in the graph below:

![CleanVIP](https://user-images.githubusercontent.com/1202386/160439487-c1a73443-486f-4f66-a3d2-0ba7c6ae8ea2.png)

Scenes are driven by the ViewController and the rest of the elements are configured upon its initialization. The dependency injection is done by initialization.



### Workers & Stores
  Workers are initialized and retained in the interactors. Dependencies objects are injected to them along with specific stores for them to combine. In our simple case, a single BooksWorker is used to fetch the books listing. A books store for fetching books and an element for persisting them is injected through protocols for better decoupling.



### Testing
* Unit testing is carried out for all VIP scene elements written in Swift, focusing on the input/output protocols of each element. Unit tests are provided for basic elements not belonging to scenes as well, as the BooksWorker & the global Router.
* The SwiftUI BookDetailView is tested through snapshots for each possible view state. Snapshot testing is carried out for List scene & Detail scene in swift as well for their basic states.

* Integration tests mock JSONs and return them to the APIClient to assert that the scenes behave correctly with success & error returns.    

* A simple UI test is written on top of it all to assure correct launch and navigation through the scenes.



### Possible improvements:
* Nicer appearence & UI details
* Add Amazon button to Swift Detail flavour, preview button to SwiftUI Detail flavor
* Persist favorites and recover them in a new scene 
* Cancel task when changing date 
