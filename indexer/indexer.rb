class CommonIndexer

  add_indexer_initialize_hook do |indexer|

    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['jsonmodel_type'] == 'top_container'
        doc['indicator_u_stext'] = CommonIndexer.generate_permutations_for_indicator(record['record']['indicator'])
      end
    }


    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['jsonmodel_type'] == 'resource'
        doc['display_string'] = (0..3).map {|n| record['record']["id_#{n}"]}.compact.join(" ") + ' -- ' + record['record']['title']
      end
    }

  end


  def self.generate_permutations_for_indicator(indicator)
    return [] if indicator.nil?
    [
      indicator,
      indicator.gsub(/[[:punct:]]+/, " "),
      indicator.gsub(/[[:punct:] ]+/, ""),
      indicator.scan(/([0-9]+|[^0-9]+)/).flatten(1).join(" ")
    ].uniq
  end

end
