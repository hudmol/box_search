require 'uri'

class BoxSearchController < ApplicationController

  set_access_control  "view_repository" => [:index, :search]

  def index
  end


  class MissingFilterException < Exception; end


  def search
    begin
      results = perform_search
    rescue MissingFilterException
      return render :text => I18n.t("top_container._frontend.messages.filter_required"), :status => 500
    end

    render_aspace_partial :partial => "box_search/results", :locals => {:results => results}
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

    filters.push({'display_string' => params['indicator']}.to_json) unless params['indicator'].blank?
    filters.push({'collection_identifier_stored_u_sstr' => params['collection']}.to_json) unless params['collection'].blank?

    unless filters.empty?
      search_params = search_params.merge({
                                            "filter_term[]" => filters
                                          })
    end

    container_search_url = "#{JSONModel(:top_container).uri_for("")}/search"
    JSONModel::HTTP::get_json(container_search_url, search_params)
  end

end

