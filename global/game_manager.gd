# this script will hold the overall game state

extends Node

signal victory

var Screens = {
	MAIN_MENU = 'res://screens/main_menu.tscn',
	GAME = 'res://game/game.tscn',
	GAME_OVER = 'res://gui/GameOverScreen.tscn',
}


enum GameState {
	SPLASH,
	MAIN_MENU,
	GAME,
	PAUSED,
	GAME_OVER
}

var _current_state: int = GameState.SPLASH setget _set_current_state
var _previous_state: int


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	
func start_game():
	transition_to(GameState.GAME)
	
	
	
func game_over():
	transition_to(GameState.GAME_OVER)
	

# change the state to the next
func transition_to(new_state: int) -> void:
	match new_state:
		GameState.MAIN_MENU:
			_current_state = new_state
			SceneLoader.goto_scene(Screens.MAIN_MENU)
		
		GameState.GAME:
			if _current_state in {GameState.MAIN_MENU: true, GameState.SPLASH: true, GameState.GAME: true, GameState.GAME_OVER: true}:
				_current_state = new_state
				
				SceneLoader.goto_scene(Screens.GAME)
		
		GameState.GAME_OVER:
			if _current_state in {GameState.GAME: true}:
				_current_state = new_state
				SceneLoader.goto_scene(Screens.GAME_OVER)


func _set_current_state(new_state:int) -> void:
	_previous_state = _current_state
	_current_state = new_state
