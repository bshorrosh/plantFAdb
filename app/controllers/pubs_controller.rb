class PubsController < ApplicationController
  require "unicode_utils/upcase"
  load_and_authorize_resource  
  # GET /publications
  def index

    if ActiveRecord::Base.connection.adapter_name.downcase =~ /.*sqlite.*/
      @pubs = @pubs.order(sort_column + ' ' + sort_direction + ", pubs.id ASC")
    else
      @pubs = @pubs.order(sort_column + ' ' + sort_direction + " nulls last, pubs.id ASC")
    end
      @pubs = @pubs.joins("join (
        select count(distinct(r.id)) result_count, p.id pub_id
        from results r
          join datasets d on d.id = r.dataset_id
          join plants_pubs pl_tbl on pl_tbl.id = d.plants_pub_id
          join pubs p on pl_tbl.pub_id = p.id
          join measures m on m.id = r.measure_id
        where r.published_at is not null
          and unit in ('GLC-Area-%','weight-%')
          AND m.type in ('FattyAcid','Parameter')
        group by p.id) res on res.pub_id = pubs.id ")
                 
    if (params[:plant_id] && @plant=Plant.find_by(id: params[:plant_id].to_i))
      @pubs = @pubs.where(id: PlantsPub.where(plant_id:params[:plant_id]).select(:pub_id))
    end
    
    if params[:genus].present? && params[:species].present?
      @species = Species.new(params[:genus],params[:species])
      plant_ids = @species.plants.select("plants.id")
      species_pub_ids = PlantsPub.where(plant_id: plant_ids).select("distinct(plants_pubs.pub_id)")
      @pubs = @pubs.where(id:  species_pub_ids) 
    end
    
    if(params[:query])
      q = UnicodeUtils.upcase(params[:query])
      @pubs = @pubs.where('
        upper(wos_year) LIKE ?
        OR upper(wos_authors) LIKE ?
        OR upper(wos_journal) LIKE ?
        OR upper(wos_volume) LIKE ?
        OR upper(wos_pages) LIKE ?
        OR upper(wos_uid) LIKE ?
        OR upper(wos_title) LIKE ?
        OR upper(abstract) LIKE ?
        OR upper(doi) LIKE ?',
        "%#{q}%","%#{q}%","%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%" )
    end
    
    unless params[:title_query].blank?
      q = UnicodeUtils.upcase(params[:title_query])
      @pubs = @pubs.where("upper(wos_title) like ?","%#{q}%")
    end
    
    unless params[:author_query].blank?
      q = UnicodeUtils.upcase(params[:author_query])
      @pubs = @pubs.where("upper(wos_authors) like ?","%#{q}%")
    end
    
    unless params[:abstract_query].blank?
      q = UnicodeUtils.upcase(params[:abstract_query])
      @pubs = @pubs.where("upper(abstract) like ?","%#{q}%")
    end
    
    unless params[:journal_query].blank?
      q = UnicodeUtils.upcase(params[:journal_query])
      @pubs = @pubs.where("upper(wos_journal) like ?","%#{q}%")
    end
    
    unless params[:year_query].blank?
      q = UnicodeUtils.upcase(params[:year_query])
      @pubs = @pubs.where("upper(wos_year) like ?","%#{q}%")
    end

    @pubs = @pubs.published.select("pubs.*, res.result_count")
                 
    respond_to do |format|
      # Base html query
      format.html{ @pubs = @pubs.page params[:page]}
      # CSV download
      format.csv{
        render_csv do |out|
          out << CSV.generate_line([
            "ID","WOS_Authors","WOS_Year","WOS_Title","WOS_Journal","WOS_Volume","WOS_Pages",
            "DOI","WOS_UID","Abstract","URL",
            "SOFA Authors","SOFA Year","SOFA Journal","SOFA Volume","SOFA Page",
            "SOFA TABS"
            ])
          @pubs.find_each do |item|
            all_pubs = [item]+item.original_pubs
            out << CSV.generate_line([
              (can? :edit, item) ? "=HYPERLINK(\"#{root_url}js_redirect.html?page=#{edit_pub_path(item.id)}\",\"#{item.id}\")" : item.id,
              item.wos_authors,
              item.wos_year,
              item.wos_title,
              item.wos_journal,
              item.wos_volume,
              item.wos_pages,
              item.doi,
              item.wos_uid,
              item.abstract,
              item.url,
              all_pubs.map(&:authors).join("; "),
              all_pubs.map(&:year).join("; "),
              all_pubs.map(&:journal).join("; "),
              all_pubs.map(&:volume).join("; "),
              all_pubs.map(&:page).join("; ")
            ]+item.sofa_tabs.map{|tab|"=HYPERLINK(\"#{tab.sofa_url}\",\"#{tab.sofa_tab_id||'#'}\")"})
          end
        end
      }
    end
  end

  def condense_doi
    result = Pub.condense_doi
    text = "Condense Complete:<br/><br/>
        Beginning Pub Count: #{result[:begin_count]}<br/>
        --<br/>
        Pub with DOI: #{result[:found]}<br/>
        Pub with unique DOI: #{result[:unique]}<br/>
        --<br/>
        Condensed: #{result[:removed]} <br/>
        New: #{result[:created]}<br/>
        --<br/>
        Ending Pub Count: #{result[:end_count]}
      "
    Rails.logger.info { text }
    redirect_to pubs_path, notice: text
  end
  
  def condense_wos
    result = Pub.condense_wos
    text = "Condense Complete:<br/><br/>
        Beginning Pub Count: #{result[:begin_count]}<br/>
        --<br/>
        Pub with UID: #{result[:found]}<br/>
        Pub with unique UID: #{result[:unique]}<br/>
        --<br/>
        Condensed: #{result[:removed]} <br/>
        New: #{result[:created]}<br/>
        --<br/>
        Ending Pub Count: #{result[:end_count]}
      "
    Rails.logger.info { text }
    redirect_to pubs_path, notice: text
  end
  
  # GET /publications/1
  def show
    @plants_pubs = @pub.published? ? @pub.plants_pubs.published : @pub.plants_pubs
    @plants_pubs = @plants_pubs.includes(:plant, datasets: [results: [:measure]])
                               #.where("results.unit in ('GLC-Area-%','weight-%')")
                               #.where("measures.type in ('FattyAcid','Parameter')")
                               #.group(PlantsPub.columns.map{|c| "plants_pubs.#{c.name}"}+["plants.genus","plants.species"])
                        
  end

  # GET /publications/new
  def new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications
  def create
    @pub.user_id = current_user.try(:id)
    if @pub.draft_creation
      redirect_to @pub, notice: 'A draft of the new Publication was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /publications/1
  def update
    @pub.attributes = resource_params
    if @pub.draft_update
      redirect_to @pub, notice: 'A draft of the Publication update was saved.'
    else
      render :edit
    end
  end

  # DELETE /publications/1
  def destroy
    if @pub.plants_pubs.empty?  
      @pub.draft_destruction
      redirect_to pubs_url, notice: 'Publication marked for destruction.'
    else
      redirect_to pubs_url, notice: 'Publication still has data. You must move or delete all publication tables first.'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def resource_params
      params.require(:pub).permit(:doi,:wos_uid,:wos_title,:wos_year,:wos_authors,:wos_journal,:wos_volume,:wos_pages,
      :year, :authors, :journal, :volume, :page, :url, :abstract)
    end
  
    def sort_column
      col = ['wos_authors','wos_year', 'wos_title', 'wos_journal', 'wos_volume','doi','wos_uid', 'result_count'].find{|c| c==params[:sort]}
      col || "pubs.wos_authors, pubs.wos_year"
    end
end