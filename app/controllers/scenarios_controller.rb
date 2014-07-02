class ScenariosController < ApplicationController
  def new
		@title = 'New Scenario'
		@page_id = 'scenario_creation'
		@scenario = Scenario.new
		@user = @scenario # For error form
  end

  def create
		@scenario = Scenario.new(params[:scenario])
		if @scenario.save
			flash[:success] = 'You have successfully made a new Scenario.'
			redirect_to root_url
		else
			@title = 'New Scenario'
			@page_id = 'scenario_creation'
			@user = @scenario # For error form
			render 'new'
		end
  end

	def edit
		@title = 'Edit Scenario'
		@page_id = 'scenario_creation'
		@scenario = Scenario.find(params[:id])
		@user = @scenario # For error form
	end
	
	def update
		@scenario = Scenario.find(params[:id])
		if @scenario.update_attributes(params[:scenario])
			flash[:success] = 'You have successfully edited the Scenario.'
			redirect_to root_url
		else
			@title = 'Edit Scenario'
			@page_id = 'scenario_creation'
			@user = @scenario # For error form
			render 'edit'
		end
	end
	
  def delete
		Scenario.find(params[:id]).destroy
		render inline: 'Done'
  end
end
