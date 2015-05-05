require 'uri'

class BoxSearchController < ApplicationController

  set_access_control  "view_repository" => [:index, :search, :linker_search, :typeahead]

  def index
  end


  class MissingTermException < Exception; end


  def search
    begin
      results = perform_search
    rescue MissingTermException
      return render :text => I18n.t("plugins.box_search.no_term_message"), :status => 500
    end

    render_aspace_partial :partial => "box_search/results", :locals => {:results => results}
  end


  def typeahead
    search_params = params_for_backend_search

    render :json => Search.all(session[:repo_id], search_params)
  end


  def linker_search
    @search_data = Search.all(session[:repo_id], params_for_backend_search.merge({"facet[]" => SearchResultData.BASE_FACETS.concat(params[:facets]||[]).uniq}).merge({"q" => solr_escape(params["q"])}))

    respond_to do |format|
      format.json {
        render :json => @search_data
      }
      format.js {
        if params[:listing_only]
          render_aspace_partial :partial => "search/listing"
        else
          render_aspace_partial :partial => "search/results"
        end
      }
      format.html {
        render "search/do_search"
      }
    end
  end



  private


  include ApplicationHelper


  SOLR_CHARS = '+-&|!(){}[]^"~*?:\\/'

  def solr_escape(s)
    return unless s
    pattern = Regexp.quote(SOLR_CHARS)
    s.gsub(/([#{pattern}])/, "\#{\1}")
  end


  def perform_search
    search_params = params_for_backend_search.merge({
                                                      'type[]' => ['top_container']
                                                    })

    filters = []

    search_params['q'] = "indicator_u_stext:#{solr_escape(params['indicator'])}" unless params['indicator'].blank?
    filters.push({'collection_uri_u_sstr' => params['collection_resource']['ref']}.to_json) if params['collection_resource']

    if filters.empty? && !search_params.has_key?('q')
      raise MissingTermException.new
    end

    unless filters.empty?
      search_params = search_params.merge({
                                            "filter_term[]" => filters
                                          })
    end

    container_search_url = "#{JSONModel(:top_container).uri_for("")}/search"
    JSONModel::HTTP::get_json(container_search_url, search_params)
  end



end

