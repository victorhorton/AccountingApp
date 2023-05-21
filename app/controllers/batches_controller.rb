class BatchesController < ApplicationController
	def index
    index_breadcrumbs
		@batches = Batch.eager_load(tranzactions: :entries).all
	end

	def create
		@batch = Batch.new(batch_params)

		if @batch.save
			redirect_to edit_batch_path(@batch)
		else
			redirect_to batches_path
		end
	end

  def update
    @batch = Batch.find(params[:id])

    if @batch.update(batch_params)
      success
      render json: {
        message: 'Success'
      }, status: :ok
    else
      error
      render json: {
        message: @batch.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.html  {
        edit_breadcrumbs
        @companies = Company.all
      }
      format.json  {
        @batch = Batch.eager_load(tranzactions: :entries).find(params[:id])
        render json: @batch, serializer: GeneralLedgerSerializer
      }
    end
  end

	private

  def success
    flash.notice = "Saved"
  end

  def error
    flash.alert = @batch.errors.full_messages.join(', ')
  end

  def index_breadcrumbs
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Batches", :batches_path
  end

  def edit_breadcrumbs
    index_breadcrumbs
    add_breadcrumb "Edit", edit_batch_path(params[:id])
  end

	def batch_params
		params.require(:batch).permit(
			:id,
			:name,
			:comment,
			:purpose,
			:posted_at,
      :deleted_at,
      tranzactions_attributes: [
        :id,
        :company_id,
        :date,
        :reference_number,
        :completed_at,
        :deleted_at,
        entries_attributes: [
          :id,
          :account_id,
          :entry_type,
          :amount,
          :designation,
          :description,
          :position,
          :deleted_at,
        ]
      ]
		)
	end
end
