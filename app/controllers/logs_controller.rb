class LogsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @log = Log.new(worked_at: Time.zone.today)
  end

  def create
    @log = Log.new(log_params)

    if @log.save
      flash[:notice] = "Logged #{@log.decorate.summary}"
      track_event("Capacity Logged", {
        worked_at: @log.worked_at,
        amount: @log.decorate.amount,
        billable: @log.billable,
        project_name: @log.project.name,
        project_id: @log.project.id
      })
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    log = current_account.logs.find(params[:id])
    if log
      log.destroy
      flash[:notice] = "Deleted log for #{log.decorate.summary}"
    else
      flash[:error] = "Couldn't delete that log"
    end

    redirect_to root_path
  end

  def log_params
    params.require(:log).permit(:quality, :amount, :worked_at, :do_not_bill)
      .merge(account: current_account, project: Project.find(params[:project_id]))
  end
  private "log_params"
end
