# Exercism App
Mac and iPad app for exercism. You can find us on [app store](https://apps.apple.com/ke/app/exercode/id6477780023?mt=12) 

## Architecture 
The current architecture is straightforward since most of the features built are very simple. It is however evolving with need. 
- `SwiftUI`:
  
    The app is primarily in SwiftUI. However, we borrowed some appkit components when SwiftUI was not sufficient. 
- `MVVM`:

  The app will essentially follow the MVVM pattern. 
### Architecture Diagram
![Exercism](https://user-images.githubusercontent.com/23118371/196192446-afc28329-f37e-4755-b50a-11cf314aa778.png)


### Getting Started

Running the project is fairly simple

1. Let's start by cloning the repository
2. Change the `Development Team` to a valid one to be able to run
3. Let the packages resolve
4. Then, Hit Build and Run the project

For additional information about the packages utilized in the app, please refer to the [brief documentation](/doc/01-dependencies.md).

For information on how to contribute, please refer to the [contributing documentation](CONTRIBUTING.md)
