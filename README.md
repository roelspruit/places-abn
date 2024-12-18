# ABN AMRO iOS Assignment - Roel Spruit

Thank you for taking the time to evaluate my implementation of the iOS Developer hiring assignment for ABN AMRO. I've spent time building an app that matches the requirements while trying to match my personal level of quality. My intention while building this app was to give an example of my approach to such relatively small apps while also leaving room for more advanced approaches if such an app would grow to be more complex in the future. Below I have written down some of the choices and compromises I made during this process but I would love to have an opportunity to discuss my thoughts more in depth.

## Requirements
The WikiPlaces app was built on Xcode 16.1 as some of the features I use in the codebase actually require that version (such as the new Swift Testing framework). 

The requirements for building and running the Wikpedia app are written down in the [repositories readme file](https://github.com/wikimedia/wikipedia-ios).

## Technical decisions
- **Architecture**. I chose to stick to a simple MVVM architecture. The amount of logic in the ViewModel of the main list is not huge and for such a small app with a single view I think this is appropriate. Often the architecture of the apps I work on have been predetermined by the teams I work with but in general I tend to prefer setups where the amount of boilerplate code is minimal. My main concerns when making architecture decisions are always the readability,  complexity and testability of the code.
- **Dependency injection**. I'm using standard initializer-based dependency-inject due to the simplicity of the app. On a larger scale this would lead to a lot of complexity in the call sites of these initialzers and I would consider other approaches such as `EnvironmentObject` or third party libraries like `Swinject`.
- **Test coverage**. I used this opportunity to try out the relatively new [Swift Testing Framework](https://developer.apple.com/xcode/swift-testing/) to write a comprehensive set of unit tests for the most important parts of the app. Namely the view model of the list of locations and the network request and JSON decoding. I have experience with UI Tests and Snapshot Tests as well but I didn't have time to write these for this project.
- **Automated mock generation**. I'm used to using a tool like `SwiftyMocky` or `Mockolo` to automatically generate mocks based on protocols. That seemed like overkill for this simple application and the time I had to build it. For now I wrote simple manual mocks. See `LocationServiceMock` for an example. A benefit of this is that some of these mocks can also be used to create meaningful SwiftUI previews.
- **Networking**. I wrote a tiny network layer that does requests via `URLSession` and decodes a type. This class is abstracted via a protocol so this layer can be mocked during unit tests as well.
- **Accessibility**. I did a check to see if the app is usable with VoiceOver and added relevant improvements in certain places like accessibility hints, voiceover reading order changes and focus state improvements for views like error messages that "suddenly appear"
- **Wikipedia app changes**. I modified the wikipedia app as requested. I ran into an issue once I added the handling for the new places-tab-with-a-coordinate deeplink. The app might cold start as a response to the deep link and the mapview was not loaded and ready to handle the coordinate change. I had to build a small mechanism to "remember" the desired coordinate change and perform it once the view has loaded. You can find this code by searching on `afterViewLoadActions`


## TODO List
This is a list I used as an improvised kanban board to keep track of my progress and the level of completeness of the app

-  Download places from remote JSON file
    - [x] Progress indicator 
    - [x] Handle download / parsing errors
- Display places in list
    - [x] Handle missing name    
    - [x] Retry loading in error state
- Open place in Wikipedia app
    - [x] Construct and open link based on custom URL Scheme
    - [x] incorrect content (like invalid coordinate for single item)
    - [x] Handle new activity in Wikipedia app
    - [x] Handle situation where Wikipedia app is not installed
    - [x] Fix Crash when wikipedia app is not open yet
- Selecting custom location
    - [x] Enter custom coordinate
    - [x] Validate custom coordinate
- [x] Check test coverage
- [x] Accessibility Review
- [x] Add relevant comments as explanation
- [x] Write down notable choices in readme file
- [x] Clean up design
- Assignment feedback
    - [x] Perform complete concurrency check and fix warnings
    - [x] Separate View into components
    - [x] Extra accessibility check
    - [x] Localisation (for a11y improvements)
- [x] Form accessibility improvements
    - [x] Not able to jump between fields with VoiceOver
    - [x] Not able to finish filling in the form with VoiceOver