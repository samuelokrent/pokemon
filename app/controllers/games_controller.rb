class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, 
    :pick_deck, :choose, :answer_mega_question, :battle, :state, :battle_attack]
  skip_before_action :verify_authenticity_token

  def home
  end

  def show
    @game.update_state
    case @game.state
    when "building_decks"
      redirect_to pick_deck_game_path(@game)
    when "battle"
      redirect_to battle_game_path(@game)
    end
  end

  def find_or_new
    @game = begin Game.find_by_name(params[:name]) rescue nil end
    if @game
      redirect_to game_path(@game)
    else
      redirect_to new_game_path(name: params[:name])
    end
  end

  def new
    @game = Game.new(name: params[:name])
    @game.build_player_one
    @game.build_player_two
  end

  def create
    Rails.logger.debug game_params.inspect
    @game = Game.new(game_params)
    @game.state = "building_decks"

    if @game.save
      Rails.logger.debug "Created new game: #{@game.id}"
      @game.update_state
      redirect_to pick_deck_game_path(@game)
    else
      Rails.logger.debug "Could not create game: #{@game.errors.full_messages.inspect}"
      render :new
    end
  end

  def pick_deck
    @game.update_state
    if @game.state == "battle"
      redirect_to battle_game_url(@game)
    end
    @pokemon = PokemonBase.all.sample(40)
  end

  def choose
    @pokemon = PokemonBase.find(params[:pokemon_base_id])
    @player = @game.current_player
    @card = PokemonCard.create(player: @player, pokemon_base: @pokemon)
    if @player.player_type == "student"
      @question = MultipleChoiceQuestion.all.sample
    end
    @game.advance_turn
  end

  def answer_mega_question
    @player = Player.find(params[:player_id])
    @card = PokemonCard.find(params[:card_id])
    if params[:question_type] == "multiple-choice"
      @question = MultipleChoiceQuestion.find(params[:question_id])
      if params[:multiple_choice_answer] == @question.correct_answer
        @card.make_mega
      end
    end
  end

  def battle
    render layout: "battle"
  end

  def battle_attack
    @attack = Attack.find(params[:attack_id])
    @is_super_effective = params[:is_super_effective].present?
    @player = @game.current_player
    @attacked_card = @game.idle_player.active_card
    @attacked_card.apply_damage(@attack.damage(@is_super_effective))
    @game.advance_turn
  end

  def state
    render json: @game.to_hash.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(
        :name,
        player_one_attributes: [:name, :player_type],
        player_two_attributes: [:name, :player_type])
    end
end
