/*:

  # Introduction
  Welcome to my WWDC20 Swift Student Challenge submission. You’re about to learn the fundamentals of Machine Learning and what you can achieve with it. Let’s jump right in! 🤩

*/
import LiveViews
import PlaygroundSupport
/*:

  ## About the playground
  The idea behind this playground is to help people who are experiencing problems with writing. This mainly concerns children in primary school or people like my father. He, like many others, suffers from multiple sclerosis, an autoimmune disease. Above all he has immense difficulties with writing. In order to help him and many others, I've chosen Machine Learning, since it's the only way to make computers our assistants. I'm sure you've heard of it before, but don't worry if you haven't. On the [next page](@next), I’ll tell you more about it.
  
  ## About this page
  This page has nothing special to reveal. If you're still interested in looking at it, follow the code instructions below. See you on the [next page](@next). 😎
*/
func setupView() {
    let introductionViewController = IntroductionViewController()
    PlaygroundPage.current.liveView = introductionViewController
    //#-hidden-code
    PlaygroundPage.current.assessmentStatus = .pass(message: "### You actually did it! 🥳")
    //#-end-hidden-code
}

// Call setupView() here
/*#-editable-code Tap to enter code*//*#-end-editable-code*/
//: When you're ready, hit "Run my code" to see the result. 🤙