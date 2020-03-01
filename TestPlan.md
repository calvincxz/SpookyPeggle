# Test Plan

## Integration Test
### Integration Tests for Main Menu
* Test game master selector buttons
  * `Pumpkin` should be selected by default
  * There should be only 1 selected button at any time
  * The selected button should be lighted with yellow colour in background
* Test game transition button
  * Level Design
    * Transition to `Level Design` (see tests below)
  * Play
    * Transition to `Level Selection` (see tests below)

### Integration Tests for Level Design
* Test palette
  * Blue peg selector should be selected by default.
  * All peg selectors (blue, orange, green, delete)
    * Long pressing on a peg selector will produce the same effect as a single tap after long press ends
    * When tapped, it should darken, all other peg selectors should fade
    * When the same peg selector is tapped, nothing should happen
    * When a different peg selector is tapped, the previous one should fade, and the newly selected one should darken
  * Switch button should toggle peg selector shape
    * When peg selectors are circles, pressing the switch should turn them to triangles and vice versa
    * Peg selector with the same colour as previous should be selected
    
* Test gestures
  * All gesture are not recognized near the edges of the background image
  * When a peg selector is selected (except the peg eraser), tapping on the screen should create the peg at that location
    * The location that is tapped determines the centre of the newly created peg
    * If the system determines that new peg created will overlaps with an existing peg, nothing should happen (new peg will not be created)
    * Tapping near the edge of the screen will not create a peg since the peg will be out-of-bounds/ image will be clipped
    * Tapping outside the gameplay area should not create pegs (gameplay area refers to the background image)
    
  * When the peg eraser is selected, 
    * Tapping on a peg should remove it from screen
    * If peg does not exist at location, nothing happens when tapped at that location
    
  * Dragging a peg should move the peg around (unaffected by peg selector)
    * Dragging does not work when starting from the bottom edges of a peg (10-20% of its total height)
    * Dragging a peg to an out-of-bounds location should cause it to be stuck at the edge of the screen
    * Dragging a peg to an location with an overlapping peg is allowed
    * Dragging to valid locations is still possible even after user drags to palette region. (Peg will be stuck at edge, but user can move his finger back to the valid locations and peg will still follow)
    * The selected peg should default back to its initial position only if the drag gesture ENDS at an invalid location
      
  * Long pressing on a peg for more than 1s should remove the peg (unaffected by peg selector)
    * Long press outside the gameplay area should not remove pegs (gameplay area refers to the background image)

  * Pinching should resize a peg
    * Pinch gesture does not need to be within peg
    * Peg must be selected by a single tap before resizing (Peg should light up upon being selected)
    * Pinch with fingers moving closer causes peg to become smaller
    * Pinch with fingers moving apart causes peg to become larger

  * Rotation gesture using 2 fingers
    * Circular pegs cannot be rotated
    * Gesture does not need to be within peg
    * Peg must be selected by a single tap before resizing (Peg should light up upon being selected)
    * Rotation gesture clockwise causes peg to rotate clockwise
    * Rotation gesture anti-clockwise causes peg to rotate anti-clockwise

  * Simultaneous Peg Rotation and Resize 
  * Pinch and rotation gestures are recognized simultaneously
  * It is possible to rotate and resize peg at the same time
    
* Test action buttons
  * Menu Button
    * Transitions to `Main Menu` (see tests above)
  * Reset button
    * When tapped, all pegs on the screen should disappear

  * Save button
    * When tapped, an alert window will appear, prompting the user to specify a level name for saving (default name should be "Untitled" unless it was a previously loaded file, then it will be the loaded file name)
      * When user clicks "cancel", save window disappears and nothing happens (pegs should remain)
      * When user clicks "save", save window disappears
        * File name such as "PreloadLevel1" cannot be used since it is identical to the preloaded level name.
        * Invalid file name (file name must be alpha-numerical only)
          * Save alert window will mention invalid file name, and prompt user to specify new name
          
        * Duplicate file name, overwrite window appears, asking if user wishes to overwrite original file
          * When user clicks "overwrite", overwrite window disappears and file should be overwritten
          * When user clicks "cancel", overwrite window disappears and nothing happens (pegs should remain)
          
        * If save fails due to encoding/file directory issues, an error alert will show on screen
        * Save success would result in screenshot of level being taken
        * Any error in taking/saving screenshot should be shown via UIAlert
      
  * Load button
    * Transitions to `Level Selection` (See tests below)
  * Start button
    * Starts game by transitioning to `Game Play` (See tests below)
    * The pegs currently on the board should be loaded to the new screen

### Integration Tests for `Level Selection`
* Test initialization
  * There should be 3 preloaded levels
  * All previously saved level should also be loaded
  * Only levels with a valid screenshot will be loaded
* Test gestures
  * Selecting level to play
    * Single tap the cell with the image
    * Transitions to `Game Play` or `LevelDesign` depending on previous screen
  * Delete level
    * Long press > 1s should delete the image
    * There should be a delete confirmation
    * Preloaded levels cannot be deleted

* Test Button
  * Back button
    * Returns to previous screen (Either `Level Design` or `Main Menu`) 

### Integration Tests for `Game Play`
* Starting the level
  * Level should be loaded with pegs from `Level Design` or `Level Selection`
  * Starting ball count should be 10
  * Starting score should be 0
  * Cannon direction should be face down
  * Orange pegs status should show near bottom right of screen
    * Status shown as ratio of (Total lighted / Total)

* Test pan gesture for Ball Launch (cannon rotation for direction of initial ball velocity)
  * Pan gesture only works in the UIView covered by the background image.
  * Cannon and ball should be vertically aligned and facing downwards by default
  * Cannon should not be able to rotate further than 70 degrees from its initial position (either left or right)
  * Any pan gesture with translation in x < 0 should cause cannon to rotate left
  * Any pan gesture with translation in x > 0 should cause cannon to rotate right
  * Pan gestures with multiple fingers is not recognized.
  * Cannon direction should remain unchanged when ball is reloaded in the same level.
    
* Test single tap gesture (starts the game by firing the ball)
  * Tap gesture only works in the UIView covered by the background image.
  * When game is in progress (another ball is in play), nothing should happen after single tap
  * When ball count > 0 and no ball is in play, single tap should fire the cannon
    * Ball should start moving
    * Ball count shown should decrease by 1
  * After a single tap, ball should move in direction of the cannon, affected by some slight acceleration downwards
    
* Test game play (when ball is in game)
  * Ball Movement
    * Ball should obey the rules of physics. Since it is always subjected to a downwards acceleration, it will eventually exit via the bottom of the area.
    * After ball reaches the bottom, it should be removed from screen, and all lighted pegs should also slowly fade out within 1s.
    * Ball velocity in y direction downwards is capped.

  * Ball Collision
    * Ball should collide with the sides of screen bound(left and right), and with other pegs in game.
    * Ball should not collide with top bound or cannon
    * Side collision: After collision with the sides of the gameplay area, the velocity in the horizontal direction of the ball should be reversed, and the ball should now travel in the opposite horizontal direction. Velocity in the vertical direction remains unchanged.(E.g. when ball hits the left wall, it should move to the right, while still moving down)
    * Peg collision: Since all pegs are static objects, they will not move upon collision with the ball. Instead, the ball will retain most of its energy and be reflected in another direction 

  * Peg Lighting
    * All pegs should be non-lighted at the start of the game.
    * Once the ball touches a peg, the peg should light up.
    * Once a peg is lit, it should remain lit until the ball exits.
    * When the ball hits a lighted peg, nothing should change visually.

  * Power-up
    * When a green peg is lighted for the first time, power up should active
    * `Bat`
      * Smoke effect created in a radius surrounding the green peg (radius is 3 * default peg diameter)
      * All pegs whose centre is hit by the smoke should light up
      * Effect only happens once
    * `Pumpkin`
      * Ball turns into spooky ball for 1 additional turn
      * Re-enters game after bottom exit with the same velocity, acceleration
      * Power-up is cumulative (hitting 2 green pegs will cause power-up to last for 2 turns)
    * `Wizard`
      * Ball turns into fireball for the next turn
      * The fireball ignores collision of pegs, but lights them up after phasing through them
      * FPS drops when fireball effect is in play
      * Power-up is cumulative (hitting 2 green pegs will cause power-up to last for 2 turns)

  * Peg Removal 
    * After ball reaches the bottom, it should be removed from screen 
      * All lighted pegs should also slowly fade out within 1s
    * If a peg gets hit more than 20 times in one round, it will be removed from play since
      it is likely to be causing a ball to be stuck

  * Bucket
    * Bucket should move left and right
    * Velocity should be reversed in x-direction after collision with wall
    * Bucket will phase through pegs near bottom game-play screen
    * Bucket hole is blocked when "spooky ball" power-up is activated
    * Bucket is not totally open (ball may still collide with bucket top near the sides)
      * Free ball when ball enter buckets
      * Free ball message will be displayed

  * Ball exits but not win/lose
    * Ball disappears from bottom
    * Ball reappears in the cannon
    * Score should be updated
    * All lighted pegs should disappear
    * All remaining pegs should not be lighted
    * There exists at least 1 orange peg in game

  * Winning/losing the game
    * Win
      * When there are no more orange pegs after ball exits
    * Lose
      * When ball count reaches 0 and there are orange pegs left
    * Transitions to `End Game`

* Test action buttons
  * Score display
  * Back button
    * Returns to the previous screen (`Level Design` or `Level Selection`)


### Integration Tests for `End Game`
* Game message
  * Win/lose message should be shown accordingly
  * Score should be displayed below the message
* Test buttons
  * Replay button should bring user to replay previous level
  * Home button should bring user to home menu