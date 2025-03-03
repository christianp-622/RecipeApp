### Summary
The goal of this project was to demonstrate production-ready code suitable for an iOS team environment. I developed an application that fetches data and images from a custom endpoint, then displays the content using the modern SwiftUI framework. Key aspects of the project include:

Robust Networking:
- Fetching data and images from a custom API endpoint.
- Implementing Swift Concurrency to handle asynchronous code in a modern and efficient way.

Error Handling & Modularity:
- Building a multi-layered system that gracefully handles errors.
- Thoroughly testing every error case to ensure reliability.
- Designing the system in a modular fashion to promote maintainability and scalability.
  
Performance Optimization:
- Implementing a hybrid caching system to optimize network requests.

Below is a demo showcasing the UI along with detailed notes on my thought process, the trade-offs made during development, and the time taken to complete the project.

![RecipeAppRefresh](https://github.com/user-attachments/assets/32d8d9f8-241d-4066-8a92-0a763ed733be)
![RecipeAppError](https://github.com/user-attachments/assets/e5515960-a0e2-47b8-b1c7-e33bc07dd2f2)
<img width="265" alt="Screenshot 2025-02-10 at 12 05 41 AM" src="https://github.com/user-attachments/assets/0217e911-8b64-4fd9-947c-924cd2da8ed0" />


### Focus Areas
For this project, I chose to prioritize modularization, implementation of the cache system, and ensuring coverage of all error cases.

Modularization:

I wanted to ensure a solid separation of concerns. For disk operations, the FileManager handles file reading, writing, and other disk tasks, while CacheFileStorage manages cache-specific operations and error handling—allowing the cache to determine the appropriate response when issues arise. On the networking side, a similar structure is applied: the NetworkManager initiates basic network requests, and the APIService performs the heavy lifting by processing responses and managing errors. The ViewModel then takes care of any errors that occur. Achieving this clear separation required some significant refactoring, but it has resulted in a more modular and maintainable architecture.

Cache System: 

I wanted to optimize a normal caching system that may only use memory or only use disk, to have the ability to use both in the best scenarios. The benefit of having an On-Disk cache is that you have the ability to persist data. That is important so we don't have to make a totally new network request if the user ends up closing the application. All we have to do is retrieve the images from that cache and repopulate the Listview. Alternatively, An in-memory cache gives us quick access to the cached data. Reading from disk is an expensive operation. However the downside of the in memory cache is the lack of persistence as it gets destroyed with all other objects that were stored in memory once the app terminates. All this being said, I developed three caches: an on disk cache (required in the project description), an in memory cache (utilizes NSCache), and a hybrid cache (took the best of both worlds). All three caches conform to the same protocol, making it very simple and easy to swap them out. I would say a great design choice. I didn't do any performance testing, but with the way they are set up it wouldn't be too hard to test. 

Testing:

Testing is the most important aspect of ensuring app stability. I needed to ensure that my code was set up in such a way that allowed for dependency injection, to test modules that are crucial to the apps health. Not only that, it was important to cover as much code as possible. If anyone were to come in to work on this project, and alter behavior of the classes, they would be met with hopefully a failed test case to make them aware of the expected functionality. Tests help prevent regressions and facilitate future contributions. 

### Time Spent
I dedicated approximately 40-50 hours to the project, primarily during weekends, while managing a full-time job during the week. I didn't get to start working on this project until the weekend after I was asked to work on it due to very urgent tasks I had. 

### Trade-offs and Decisions
I wasn't able to spend as much time on the UI of the application as I would have liked. The backend was prioritized to ensure core functionality, even if it meant compromising on advanced UI features. I did face a trade off between creating an in memory cache or an on-disk cache. While the project specification called for an on-disk cache, I implemented a hybrid cache that leverages both on-disk persistence and the speed of an in-memory cache. This decision balanced performance with data persistence, despite the extra complexity.

### Weakest Part of the Project
While the UI is functional, it could be significantly enhanced by incorporating additional features, such as a filtering option, a search bar, and external links for the provided URLs. I believe that my approach to mocking could be more consistent as well. For instance, using standardized methods like didCall() or implementing a custom parameter matcher would ensure that the correct data is passed through. Overall, the mocks became somewhat disorganized, likely due to my familiarity with more structured frameworks like Cuckoo.

### Additional Information
Just general constraints with managing my time working on this application outside of work for my current position.

