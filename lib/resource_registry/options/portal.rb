module ResourceRegistry
  module Options
    class Portal < Dry::Struct 
      transform_keys(&:to_sym)

      attribute :key,       Types::Symbol


      def call(params)
      end

    end
  end
end