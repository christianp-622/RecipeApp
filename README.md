### Summary: Include screen shots or a video of your app highlighting its features

![RecipeAppRefresh](https://github.com/user-attachments/assets/32d8d9f8-241d-4066-8a92-0a763ed733be)
![RecipeAppError](https://github.com/user-attachments/assets/e5515960-a0e2-47b8-b1c7-e33bc07dd2f2)
<img width="265" alt="Screenshot 2025-02-10 at 12 05 41 AM" src="https://github.com/user-attachments/assets/0217e911-8b64-4fd9-947c-924cd2da8ed0" />


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
For this project, I chose to prioritize modularization, implementation of the cache system, and ensuring coverage of all error cases.

Modularization:

I wanted to ensure a solid separation of concerns. For disk operations, the FileManager handles file reading, writing, and other disk tasks, while CacheFileStorage manages cache-specific operations and error handling—allowing the cache to determine the appropriate response when issues arise. On the networking side, a similar structure is applied: the NetworkManager initiates basic network requests, and the APIService performs the heavy lifting by processing responses and managing errors. The ViewModel then takes care of any errors that occur. Achieving this clear separation required some significant refactoring, but it has resulted in a more modular and maintainable architecture.

Cache System: 

I wanted to optimize a normal caching system that may only use memory or only use disk, to have the ability to use both in the best scenarios. The benefit of having an On-Disk cache is that you have the ability to persist data. That is important so we don't have to make a totally new network request if the user ends up closing the application. All we have to do is retrieve the images from that cache and repopulate the Listview. Alternatively, An in-memory cache gives us quick access to the cached data. Reading from disk is an expensive operation. However the downside of the in memory cache is the lack of persistence as it gets destroyed with all other objects that were stored in memory once the app terminates. All this being said, I developed three caches: an on disk cache (required in the project description), an in memory cache (utilizes NSCache), and a hybrid cache (took the best of both worlds). All three caches conform to the same protocol, making it very simple and easy to swap them out. I would say a great design choice. I didn't do any performance testing, but with the way they are set up it wouldn't be too hard to test. 

Testing:

Testing is the most important aspect of ensuring app stability. I needed to ensure that my code was set up in such a way that allowed for dependency injection, to test modules that are crucial to the apps health. Not only that, it was important to cover as much code as possible. If anyone were to come in to work on this project, and alter behavior of the classes, they would be met with hopefully a failed test case to make them aware of the expected functionality. Tests help prevent regressions and facilitate future contributions. 


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I dedicated approximately 30–40 hours to the project, primarily during weekends, while managing a full-time job during the week. I didn't get to start working on this project until the weekend after I was asked to work on it due to very urgent tasks I had. 

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I wasn't able to spend as much time on the UI of the application as I would have liked. The backend was prioritized to ensure core functionality, even if it meant compromising on advanced UI features. I did face a trade off between creating an in memory cache or an on-disk cache. While the project specification called for an on-disk cache, I implemented a hybrid cache that leverages both on-disk persistence and the speed of an in-memory cache. This decision balanced performance with data persistence, despite the extra complexity.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The UI could have been much stronger by adding multiple different features, such as a filter feature, search bar, external link for the provided URLs, etc… Additionally, I think I could have structured my Mocks in a more consistent manner, such as adding standard, didCall() or having a custom parameter matcher to esure currect data was passed through. In general I think they got a bit messy, but it may be because I am used to using a structured mocking framework, cuckoo.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Just general constraints with managing my time working on this application outside of work for my current position.

