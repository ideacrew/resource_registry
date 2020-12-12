# frozen_string_literal: true
require 'dry/monads'
require 'rgl/adjacency'
require 'rgl/implicit'

module ResourceRegistry
  module Operations
    module Graphs
      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(namespaces, registry)
          graph = yield create(namespaces, registry)
          # yield validate(graph)
          Success(graph)
        end

        private

        def create(namespaces, registry)
          graph = registry['feature_graph'] if registry.key?('feature_graph')
          graph ||= ::RGL::DirectedAdjacencyGraph.new
          @vertex_dir ||= {}
          namespaces.each do |namespace|
            namespace_vertices = namespace_to_vertices(namespace)
            namespace_vertices.each_index do |index|
              if namespace_vertices[index + 1].present?
                graph.add_edge(namespace_vertices[index], namespace_vertices[index+1])
              else
                graph.add_vertex(namespace_vertices[index])
              end
            end
          end

          # validate graph

          Success(graph)
        end

        def validate(graph)
          # graph.acyclic? && directed?
          # return error message with cycles when acyclic failed
        end

        # TODO: Output graph when its successful dotted graph in console/log

        def namespace_to_vertices(namespace)
          paths = namespace[:path].dup
          vertex_path = []
          while true
            current = paths.shift
            vertex_path.push(current)
            (vertices ||= []) << (paths.empty? ? find_or_create_vertex(vertex_path, namespace) : find_or_create_vertex(vertex_path))
            break if paths.empty?
          end
          vertices
        end

        def find_or_create_vertex(vertex_path, namespace_hash = {})
          vertex_key = digest_key_for(vertex_path)
          return @vertex_dir[vertex_key] if @vertex_dir[vertex_key]
          @vertex_dir[vertex_key] = ResourceRegistry::Namespace.new(namespace_hash.merge(key: vertex_key.to_sym, path: vertex_path))
        end

        def digest_key_for(vertex_path)
          Digest::MD5.hexdigest(vertex_path.map(&:to_s).join('_')).slice(0..9)
        end
      end
    end
  end
end
