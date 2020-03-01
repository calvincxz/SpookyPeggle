# Developer Guide for *SpookyPeggle* 
## Architecture + Class Diagram
<p align="center">
<img src=Images/Architecture+ClassDiagram.png width=70% height=70%>
</p>

## Architecture
The **Architecture Diagram** given above explains the high-level design of *SpookyPeggle*. Given below is a quick overview of each component

1. `Controller`
	* Connects the model and view
	* Recognizes gestures from views and updates model accordingly
	* Gets notified when model changes takes place and updates view accordingly (Game Engine)
2. `Model`
	* Encapsulate data and basic behaviours
	* Contains information that are persistent 
3. `View`
	* Can be intialized by user or from a `Model`
	* In charge of the images displayed to the user
	* Does not contain logic
4. `PhysicsEngine`
	* An external framework in charge of object interactions in a physical world
	* Used by the `GamePlayController`
5. `Helper`
	* Music, storage, game display effects, etc

## Controller
Each controller is in-charge of the game screen that the user sees. There are 5 controllers in total, each managing a different view. More details about each controller are given below.

### HomeViewController
The `HomeViewController` controls the main menu page for *SpookyPeggle* . It is the first view that the user sees.
  
<p align="center">
<img src=Images/Home.PNG width=70% height=40%>
</p>

* Game master buttons
	* Allows selections of game masters
* `LevelDesign` button segues to: `LevelDesignerController`  
* `Play` button segues to: `LevelSelectionViewController` 

#### LevelDesignerController
The `LevelDesignerController` controls level design screen to allow users to design their own
*SpookyPeggle* level.

<p align="center">
<img src=Images/LevelDesign.png width=70% height=40%>
</p>

* Handles user gestures for peg modification in level designer
* Buttons for palette peg selection
* Buttons for transitions to other game screens
	1. `LevelSelectionViewController` via load button
	2. `GamePlayController` via start button
	3. `HomeViewController` via menu button
	


### LevelSelectionViewController
The `LevelSelectionViewController` controls level selection screen.
Its behaviours depends on the previous screen of the user before arriving here. 
If user came from `LevelDesignerController`, selecting a level will segue back to `LevelDesignerController`
If user came from `HomeViewController`, selecting a level will segue to `GamePlayController` 

<p align="center">
<img src=Images/LevelSelect.png width=70% height=40%>
</p>

* Handles user gestures for selecting and deleting a game level
* `Back` button to segue to previous controller

### GamePlayViewController
The `GamePlayViewController` controls game play screen. It works closely with the `PeggleGameEngine`
via a `ContactDelegate` protocol to provide an accurate simulation of movements/collisions in the game
* `PeggleGameEngine` 
* Buttons for transitions to other game screens
	1. Go back to `LevelSelectionViewController` or `LevelDesignerController` via back button

<p align="center">
<img src=Images/GamePlay.png width=70% height=40%>
</p>

### EndGameViewController
The `EndGameViewController` controls end game screen after player wins/loses the game.
* Buttons for transitions to other game screens
	1. `GamePlayController` via replay button
	2. `HomeViewController` via home button

<p align="center">
<img src=Images/EndGame.png width=70% height=40%>
</p>
