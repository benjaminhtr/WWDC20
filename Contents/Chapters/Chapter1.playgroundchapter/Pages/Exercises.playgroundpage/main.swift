/*:

  # Exercises
  You know the fundamentals of Machine Learning. Congrats! 🎉 Want to go a little further?

*/
import LiveViews
import PlaygroundSupport
/*:

  ## Convolutional Neural Network
  As you have already experienced, the Playground is able to recognize your handwriting. This is possible through a so-called Convolutional Neural Network. As the name suggests, it's a biologically inspired neural network. It's usually used for artificial intelligence technologies, especially for processing image or audio data.

  ## The EMNIST database
  Now we know what a Convolutional Neural Network is, but what is the EMNIST database?

  As you have already learned from the previous page, we need data. A lot of data. That’s why I have chosen EMNIST, because it fits perfectly with our problem we are trying to solve. It’s a huge database with 814,255 images of all letters of the alphabet, including upper and lower case, and numbers from 0-9. The EMNIST database is an extension of the MNIST database created in 1999, which only contains numbers. To be able to train our model, we have several layers.
  
  [Read more](https://www.nist.gov/itl/products-and-services/emnist-dataset) 👈

  ### Some examples of EMNIST characters
  ![Some EMNIST characters](emnist-example.png)

  ### The layers of our model
  ![EMNIST model layers](emnist-layers.png)

  ## Get ready to run the code 🏃‍♂️
  This page offers you the opportunity to apply the training from the previous page. A word is given to you, which you write into the fields one by one. If you have done everything correctly, you will receive 5 points. To get started, just follow the code instructions below. Good luck! 🍀
  - Note: Try to reach 25, 50 or even 100 points.

*/
func setupView() {
    let exercisesViewController = ExercisesViewController()
    PlaygroundPage.current.liveView = exercisesViewController
    //#-hidden-code
    PlaygroundPage.current.assessmentStatus = .pass(message: nil)
    //#-end-hidden-code
}

// Call setupView() here
/*#-editable-code Tap to enter code*//*#-end-editable-code*/
//: When you're ready, hit "Run my code" to see the result. ✌️