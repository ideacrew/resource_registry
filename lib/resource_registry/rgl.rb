# frozen_string_literal: true

module RGL
  # Extend RGL library with useful methods
  class DirectedAdjacencyGraph

    def forest
      self
    end

    def trees
      vertices - edges.map{|edge| edge[1]}.uniq
    end

    def trees_with_features
      edges_with_features = self.edges.select{|edge| edge.to_a.any?{|ele| ele.feature_keys.present?}}
      edges_with_features.collect(&:source).uniq - edges_with_features.collect(&:target).uniq
    end

    def vertices_for(options)
      return options[:starting_namespaces] if options[:starting_namespaces].present?
      return trees_with_features unless options[:include_no_features_defined]
      trees
    end
  end
end