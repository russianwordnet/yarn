class SubsumptionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if @assignment = SubsumptionAssignment.for_user(current_user).first
      @answer = @assignment.answers.build
    end
  end

  def answer
    params[:subsumption_answer][:answer] = params[:subsumption_answer][:answer].presence
    @answer = SubsumptionAnswer.new(params[:subsumption_answer])
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Спасибо! Хочется ещё?'
    else
      flash[:error] = 'Что-то сломалось.'
    end

    redirect_to subsumptions_url
  end
end
