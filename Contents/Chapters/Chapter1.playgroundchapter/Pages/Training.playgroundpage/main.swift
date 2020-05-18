/*:

  # Training
  Before we jump into the game, let's find out what machine learning really is.

*/
import LiveViews
import PlaygroundSupport
/*:

  ## So, what is Machine Learning? 🤔
  Our ability to experience, learn and improve on tasks is part of being human. By the time we are born, there is almost nothing we know and almost nothing we can do ourselves. But pretty soon we are learning and getting better day by day. But so can computers. That's called Machine Learning. It combines statistics and computer science so that computers are able to learn how to do a particular task without being programmed to do so. Just like our brain uses knowledge and experience to improve a task. Let's say you need a computer that can recognize the difference between a picture of a dog and a picture of a cat.
  
  ### And how?
  You might start by feeding it pictures and telling it which picture is which animal. A machine that is written to learn looks in the data for statistical patterns that will allow it to recognize a cat or dog in the future. It would be able to find out on its own that cats have shorter noses and dogs come in a larger variety of sizes, and then display this information numerically ordered in space. But the key is that it's the machine, not the programmer, that can identify these patterns and define the algorithm by which the future data will be sorted. But of course there will be some mistakes. The more data the computer receives, the better its algorithm will be fine-tuned and the more precise its predictions will be. Machine learning is already widely used. For example, it's being used in FaceID to automatically recognize a certain face. Another example is text-to-speech recognition, which you may be familiar with.

  ## Get ready to run the code 🏃‍♂️
  On this page, you'll be able to train your writing skills before jumping into the game. Just try out your favorite numbers or even your favorite letters if you have any. It's up to you. 😉
  
  Follow the code instructions below to get started. 👇

*/
func setupView() {
    let trainingViewController = TrainingViewController()
    PlaygroundPage.current.liveView = trainingViewController
    //#-hidden-code
    PlaygroundPage.current.assessmentStatus = .pass(message: nil)
    //#-end-hidden-code
}

// Call setupView() here
/*#-editable-code Tap to enter code*//*#-end-editable-code*/
//: When you're ready, hit "Run my code" to see the result. 🤟