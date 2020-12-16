module RGL
  class DirectedAdjacencyGraph

    def forest
      self
    end

    def trees
      vertices - edges.map{|edge| edge[1]}.uniq
    end

    def trees_with_features
      edges_with_features = self.edges.select{|edge| edge.to_a.any?{|ele| ele.feature_keys.present?}}
      edges_with_features.collect{|edge| edge.source}.uniq - edges_with_features.collect{|edge| edge.target}.uniq
    end

    def vertices_for(options)
      if ResourceRegistry::Navigation::NAMESPACE_OPTION_DEFAULTS == options
        trees
      elsif !options[:include_no_features_defined]
        trees_with_features
      end
    end
  end
end