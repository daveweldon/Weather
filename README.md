# Weather

A project to display 5 day weather forecast data, from the openweathermap API.

##How to run/build
All pods have been included in the repository, to guard against the unlikely chance that a version of a pod may no longer available. I have made the assumption that the test should use the latest version of Swift (Swift 4), taking in to account the date that the challenge was published and the reference to swift 3. The app can be run from Xcode 9 by pressing the run/ or test buttons.

##Known Issues
* Slow search for locations - Although data has been loaded in to realm, starting the location search is still slow. I believe this is because the database connection is slow to initialise because of the amount of data. Given more time, I would investigate this further, possibly moving the search to it's own thread, so it no longer blocks the UI. Ideally, these results would be on a server somewhere.
* I could have created tests for the view controller, as there is still some logic that would benefit from testing.
* The UI isn't as pretty as it could be and could do with a few hints as to the user being able to scroll. It would also make sense to surface more weather data, so that users can gain more of a feel for the hourly increments (nobody will scroll through 40 pages). Given more time, I would have mocked something up in Sketch, with the data fields that are returned from the API.

##Frameworks
* RealmSwift - Chosen because it is a widely used database that allowed me to speed up the loading and searching of locations. The JSON file that I downloaded was 20mb+ and string comparison would have created a poor user experience.
* ObjectMapper - Saves me the effort of having to map view objects by hand, saving me time and increasing code readability.
* PKHUD - Easy to use activity indicator. Could have used the built in alternative, but decided to use PKHUD instead.
* SDWebImage - Widely used image loaded. Reliable and saves time when loading images for the UI.

<img width="504" alt="screen shot 2017-10-09 at 23 08 45" src="https://user-images.githubusercontent.com/554325/31360662-55b89920-ad47-11e7-8518-40e44e2c5ca2.png">
