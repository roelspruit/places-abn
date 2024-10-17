# ABN AMRO iOS Assignment - Roel Spruit

## TODO
-  Download places from remote JSON file
    - [x] Progress indicator 
    - [x] Handle download / parsing errors
- Display places in list
    - [x] Handle missing name    
    - [x] Retry loading in error state
- Open place in Wikipedia app
    - [ ] Construct and open link based on custom URL Scheme
    - [ ] incorrect content (like invalid coordinate for single item)
    - [ ] Handle new activity in Wikipedia app
    - [ ] Handle situation where Wikipedia app is not installed
- Selecting custom location
    - [ ] Enter custom coordinate
    - [ ] Validate custom coordinate
- [ ] Check test coverage
- [ ] Accessibility Review

## Purposefuly ignored topics
- Localization. I'm using hardcoded strings in all views right now
- No automated mock generation. I'm used to using a tool like SwiftyMocky to generate mocks based on protocols but that seemed like overkill for this simple application and the time I had to build it. For now I wrote simple manual mocks. See `MockLocationService` for an example. This mock is also used to create useful SwiftUI previews.
- No pull to refresh. If the locations are loaded in the list I consider that "good enough" for now. If they fail to load however, the user does get the option of retrying.
