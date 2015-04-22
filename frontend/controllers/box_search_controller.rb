require 'uri'

class BoxSearchController < ApplicationController

  set_access_control  "view_repository" => [:index]

  def index
  end


  def bulk_operation_search
    begin
      results = perform_search
    rescue MissingFilterException
      return render :text => I18n.t("top_container._frontend.messages.filter_required"), :status => 500
    end

    render_aspace_partial :partial => "top_containers/bulk_operations/results", :locals => {:results => results}
  end


  private


  include ApplicationHelper

  def search_filter_for(uri)
    return {} if uri.blank?

    return {
      "filter_term[]" => [{"collection_uri_u_sstr" => uri}.to_json]
    }
  end


  def perform_search
    search_params = params_for_backend_search.merge({
                                                      'type[]' => ['top_container']
                                                    })

    filters = []

    filters.push({'collection_uri_u_sstr' => params['collection_resource']['ref']}.to_json) if params['collection_resource']
    filters.push({'collection_uri_u_sstr' => params['collection_accession']['ref']}.to_json) if params['collection_accession']

    filters.push({'container_profile_uri_u_sstr' => params['container_profile']['ref']}.to_json) if params['container_profile']
    filters.push({'location_uri_u_sstr' => params['location']['ref']}.to_json) if params['location']
    unless params['exported'].blank?
      filters.push({'exported_u_sbool' => (params['exported'] == "yes" ? true : false)}.to_json)
    end
    unless params['empty'].blank?
      filters.push({'empty_u_sbool' => (params['empty'] == "yes" ? true : false)}.to_json)
    end

    if filters.empty? && params['q'].blank?
      raise MissingFilterException.new
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

