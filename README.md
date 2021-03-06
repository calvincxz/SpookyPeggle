# SpookyPeggle

<p align="center">
<img src=Images/Home.PNG width=70% height=40%>
</p>

## Credits
1. <a href="https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle">Code to determine point in triangle adapted from here</a>
2. <a href="http://www.jeffreythompson.org/collision-detection/line-circle.php">Code to determine intersection of line with circle adapted from here</a>
3. <a href="https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector">Math formula for reflection vector</a>
4. <a href="https://www.freepik.com/free-photos-vectors/background">Background vector created by freepik - www.freepik.com</a>
5. <a href="https://soundcloud.com/zebestian/sets/halloween-music-pack-2019">Background Music created by Zebestian</a>
6. <a href="https://www.deviantart.com/ry-spirit/art/Pikaboo-569364686">Pikachu image created by Ry-Spirit</a>
8. <a href="https://www.gamedevmarket.net/asset/halloween-icons/">General halloween icons by Kandles</a>
9. <a href="https://opengameart.org/content/won-orchestral-winning-jingle">Sound effect for win</a>
10. <a href="https://freesound.org/people/pinkyfinger/sounds/">Peg hit sound effects by pinkyfinger</a>
11. <a href="https://opengameart.org/">Other sound effects</a>

## Dev Guide
[Developer Guide](DeveloperGuide.md)

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
* Pan gesture only works in the UIView covered by the background image
* Any pan gesture with translation in x < 0 should cause cannon to rotate left
* Any pan gesture with translation in x > 0 should cause cannon to rotate right
* Cannon should not be able to rotate further than 70 degrees from its initial position (either left or right)

### Win and Lose Conditions
* Win conditions
    * When there are no more orange pegs remaining
    * Ball exits gameplay
* Lose conditions
    * Ball count reaches 0 when ball exits gameplay
    * There are still orange pegs left

### Prevention of ball getting stuck
* Pegs are removed when it gets hit by the ball for 20 times in a single round
* This prevents the ball from getting stuck

### Selecting a Game Master
* There are 3 Game Masters to choose 
    1. Bat (Spooky Blast)
        * Releases a smoke near the power-up peg which lights up nearby pegs
    2. Pumpkin (Spooky Ball)
        * Turns the ball into a spooky ball which enters the game play area
        from the top after exit
        * The bucket is blocked during this time
    3. Wizard (Fire Ball)
        * Turns the ball into a fireball for one turn
        * Fireball lights up all pegs it passes through along the way, but does not collide with any pegs

### Home Menu
* There should be 2 buttons available to transition to the next screen.
    1. `Level Design` button
    2. `Play` button

### Level Design
1. Gestures
    * Single tap (add)
    * Long press (delete)
    * Pan (drag)
    * Pinch (resize)
    * Rotation (rotate)

2. Back button should transition to the main menu
3. Start button should start a new game with the current design
4. Save button should allow you to save the current design. The name of the level design should be alphanumerical
5. Load button should transition to the level selection screen
6. Reset should clear all the pegs on the screen.

### Level Selection
1. Gestures
    * Single tap (play)
    * Long press (delete)
2. There should be 3 preloaded levels


## Level Designer Additional Features
* Selection of peg by a single tap is required before rotation or resize
* The selected peg should light up
* Tapping near the edges may not work, always tap near the centre of the peg

### Peg Rotation
* Rotation gesture using 2 fingers
    * Rotation gesture clockwise causes peg to rotate clockwise
    * Rotation gesture anti-clockwise causes peg to rotate anti-clockwise

### Peg Resizing
* Pinch gesture using 2 fingers
    * Pinch with fingers moving closer causes peg to become smaller
    * Pinch with fingers moving apart causes peg to become larger

### Simultaneous Peg Rotation and Resize 
* Pinch and rotation gestures are recognized simultaneously
* It is possible to rotate and resize peg at the same time

## Bells and Whistles
1. Halloween Theme
    * Added/replaced images and sounds to match the theme
2. Level Selection
    * Level previews are available via screenshots
    * Implemented using collection view
3. Concept of Game Masters
    * Game masters can be selected in the home menu
    * Game master decides the power-up effect of the green peg
4. Modified Power-ups
    * Added smoke effect for "space blast"
    * Added shadow glow for "spooky ball"
5. Added NPC in game to share tips/messages with player
    * When power-up effect is in play
    * Close to winning
6. Added music/sound
    * Background music
    * Sound effects for cannon/pegs lighting/winning the game/etc
7. Added display for status of orange pegs
    * Shows number of orange pegs hit
8. Score system
    * Awards score based on peg type of pegs hit
    * Gives free ball when exceeding a certain score for the round
9. Added Power-ups
    * Turns ball into a fireball
    * Fireball which does not collide with pegs but light up all pegs along its way
10. Added Purple pegs which gives score boost
    * Increases chance of free ball
11. Added End Game Screen

## Tests
[Test Plan](TestPlan.md)

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

The MVC architecture for the previous problem sets is generally correct and continues to be relevant for this problem set. However, one problem of my previous model design was that the shape of the peg was not considered. Therefore, extension of pegs to different shapes required additional modification. This was also the main problem I faced for this problem set. I should have abstracted out the shape property for the pegs as a class for the `PhysicsEngine`. This is because the functions to check for collision and intersection are actually the same for the `LevelDesignerController` and `PeggleGameEngine`.

If I were to redo the application, I would still use my current design, but include the shape class at the start to allow for easy extension. I believe the design for my `LevelDesignerController` and `PeggleGameEngine` can also be improved and further abstracted since they are quite long in length.
