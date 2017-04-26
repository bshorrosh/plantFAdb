class PlantsController < ApplicationController
  require "unicode_utils/upcase"
  load_and_authorize_resource
  # GET /plants
  def index
    if ActiveRecord::Base.connection.adapter_name.downcase =~ /.*sqlite.*/
      @plants = @plants.order(sort_column + ' ' + sort_direction+", id asc")
    else
      @plants = @plants.order(sort_column + ' ' + sort_direction+" nulls last, id asc")
    end
    
    result_count = Result.viewable.published
                         .joins(:measure, dataset: [plants_pub: [:plant, :pub]])
                         .group("plants.id")
                         .select("count(distinct(results.id)) result_count, count(distinct(pubs.id)) pub_count, plants.id plant_id")
    
    oil_content = Result.viewable.published
                        .joins(:measure, dataset: [plants_pub: [:plant]])
                        .where("upper(measures.delta_notation)='OIL CONTENT'")
                        .group("plants.id")
                        .select("avg(results.value) avg_oil_content, plants.id plant_id")
    
    @plants = @plants.published
                     .joins("join (#{result_count.to_sql}) res on res.plant_id = plants.id")
                     .joins("left outer join (#{oil_content.to_sql}) oil_res on oil_res.plant_id = plants.id")
                     .where("res.result_count > 0")
                     .select("plants.*, res.pub_count, res.result_count, oil_res.avg_oil_content")

    if(params[:query])
      q = UnicodeUtils.upcase(params[:query])
      @plants = @plants.where('
        upper(sofa_name) LIKE ?
        OR upper(note) LIKE ?
        OR upper(sofa_family) LIKE ?
        OR upper(order_name) LIKE ?
        OR upper(family) LIKE ?
        OR upper(genus) LIKE ?
        OR upper(species) LIKE ?
        OR upper(tnrs_family) LIKE ?
        OR upper(tnrs_name) LIKE ?
        OR upper(common_name) LIKE ?
        OR upper(variety) LIKE ?
        OR upper(genus || \' \' || species) LIKE ?',
        "%#{q}%","%#{q}%","%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%","%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%"
      )
    end
    if params[:genus].present? && params[:species].present?
      @species = Species.new(params[:genus],params[:species])
      @plants = @plants.where(id: @species.plants)
    end

    respond_to do |format|
      # Base html query
      format.html{ @plants = @plants.page params[:page]}
      # CSV download
      format.csv{
        render_csv do |out|
          out << CSV.generate_line(["ID","Common Name","Genus", "Species", "Family", "Order", "Variety", "Tissue", "Tropicos URL", "Note",
            "TNRS Family", "TNRS Name", "Accepted Rank", "Matched Rank", "Name Status",
            "SOFA Family", "SOFA Name",
            "Publication Count","Result Count"])
          @plants.find_each(batch_size: 500) do |item|
            out << CSV.generate_line([
              (can? :edit, item) ? "=HYPERLINK(\"#{root_url}js_redirect.html?page=#{edit_plant_path(item.id)}\",\"#{item.id}\")" : item.id,
              item.common_name,
              item.genus,
              item.species,
              item.family,
              item.order_name,
              item.variety,
              item.tissue,
              item.tropicos_url,
              item.note,
              item.tnrs_family,
              item.tnrs_name,
              item.accepted_rank,
              item.matched_rank,
              item.name_status,
              item.sofa_family,
              item.sofa_name,
              item.pub_count,
              item.result_count
            ])
          end
        end
      }
    end
  end

  # GET /plants/1
  def show
    @fatty_acid_data = {}
    @parameter_data = {}
    @results = @plant.results.includes(:measure).order("measures.delta_notation").where(unit: ['GLC-Area-%','weight-%'])
    @results.where("measures.type = 'FattyAcid'").each do |result|
      next unless result.unit == 'GLC-Area-%' || result.unit == 'weight-%'
      @fatty_acid_data[result.measure_id]||={object:result.measure,values:[]}
      @fatty_acid_data[result.measure_id][:values]<<result.value.to_f.round(2)
    end
    @fatty_acid_data = @fatty_acid_data.map{|k,v| v}
    @results.where("measures.type = 'Parameter'").each do |result|
      @parameter_data["#{result.measure.delta_notation}#{result.unit ? ' - '+result.unit : ''}"]||=[]
      @parameter_data["#{result.measure.delta_notation}#{result.unit ? ' - '+result.unit : ''}"]<<result.value.round(2)
    end
  end

  # GET /plants/new
  def new
  end

  # GET /plants/1/edit
  def edit
  end

  # POST /plants
  def create
    @plant.user_id = current_user.try(:id)
    if @plant.draft_creation
      redirect_to @plant, notice: 'A draft of the new Plant was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /plants/1
  def update
    @plant.attributes = resource_params
    if @plant.draft_update
      redirect_to [:edit,@plant], notice: 'A draft of the Plant update was saved successfully.'
    else
      render :edit
    end
  end

  # DELETE /plants/1
  def destroy
    if @plant.plants_pubs.empty?  
      @plant.draft_destruction
      redirect_to plants_url, notice: 'Plant marked for destruction.'
    else
      redirect_to plants_url, notice: 'Plant still has data. You must move or delete all publication tables referencing this plant first.'
    end
  end
  
  def autocomplete_plant_name
    q = UnicodeUtils.upcase(params[:term]||'')
    plants = Plant.where('
        upper(sofa_name) LIKE ?
        OR upper(sofa_family) LIKE ?
        OR upper(sofa_family || \' \' || sofa_name) LIKE ?
        OR upper(genus) LIKE ?
        OR upper(species) LIKE ?
        OR upper(tnrs_family) LIKE ?
        OR upper(tnrs_name) LIKE ?
        OR upper(tnrs_family || \' \' || tnrs_name) LIKE ?
        OR upper(common_name) LIKE ?
        OR upper(variety) LIKE ?
        OR upper(genus || \' \' || species) LIKE ?
        OR upper(family || \' \' || genus || \' \' || species) LIKE ?
        OR upper(order_name || \' \' || family || \' \' || genus || \' \' || species) LIKE ?',
        "#{q}%","#{q}%","#{q}%", "#{q}%", "#{q}%", "#{q}%", "#{q}%","#{q}%", "#{q}%", "#{q}%", "#{q}%", "#{q}%", "#{q}%"
      )
    .order('genus, species, sofa_name').limit(15)
    render :json => plants.map { |plant| {:id => plant.id, :label => plant.detailed_name, :value => plant.display_name} }
  end
  
  private
    # Only allow a trusted parameter "white list" through.
    def resource_params
      params.require(:plant).permit(:common_name, :tnrs_family, :tnrs_name, :accepted_rank, :name_status, :matched_rank, :order_name, :family, :genus, :species, :tropicos_url, :note, :variety, :tissue)
    end
    
    def sort_column
      col = ['genus','species', 'common_name', 'family', 'order_name','avg_oil_content','pub_count', 'result_count'].find{|c| c==params[:sort]}
      col || "plants.genus, plants.species"
    end
end
