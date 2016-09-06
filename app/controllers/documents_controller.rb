require 'elasticsearch/dsl'

class DocumentsController < ApplicationController
  include Elasticsearch::DSL
  include SearchHelper

  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    definition = search do
      sort do
        by :release_date, order: 'asc'
      end
      query do
        match_all
      end
    end
    response = client.search index: 'movies', body: definition
    hits = response.fetch('hits')
    @documents = hits.fetch('hits').collect do |hit|
      Document.new(hit_to_hash(hit))
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    logger.ap({source: 'DocumentsController#update', params: params, document_params: document_params}, :debug)
    respond_to do |format|
      if true # @document.update(document_params)
        format.html { redirect_to document_path(@document.id), notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def client
    @client ||= Elasticsearch::Client.new log: true
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.new(get_document_attributes(params[:id]))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.fetch(:document, {}).permit(
        :id,
        :title,
        :capsule,
        :release_date,
        :vod_date,
        :blu_ray_date,
        :premium_date,
        :watched,
        :tags)
  end

end
