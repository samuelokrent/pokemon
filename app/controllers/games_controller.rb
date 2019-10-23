class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :pick_deck, :choose]

  def home
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new(name: params[:name])
    @game.build_player_one
    @game.build_player_two
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    Rails.logger.debug game_params.inspect
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        Rails.logger.debug "SAVE"
        format.html { redirect_to pick_deck_game_path(@game) }
      else
        Rails.logger.debug "NOT SAVE: #{@game.errors.full_messages.inspect}"
        format.html { render :new }
      end
    end
  end

  def pick_deck
    @pokemon = PokemonBase.all.sample(100)
  end

  def choose
    @pokemon = PokemonBase.find(params[:pokemon_base_id])
    @player = params[:player_number].to_s == "1" ?
      @game.player_one : @game.player_two
    @card = PokemonCard.create(player: @player, pokemon_base: @pokemon)
    if @player.player_type == "student"
      @question = MultipleChoiceQuestion.last
    end
  end

  def answer_mega_question
    @player = Player.find(params[:player_id])
    @card = PokemonCard.find(params[:card_id])
    if params[:question_type] == "multiple-choice"
      @question = MultipleChoiceQuestion.find(params[:question_id])
      if params[:multiple_choice_answer] == @question.correct_answer
        @card.update_attribute(:mega, true)
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
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
