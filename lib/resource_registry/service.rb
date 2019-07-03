module ResourceRegistry
  class CreateProfile
    attr_reader :validate_article, :persist_article

    def initialize(validate_article, persist_article)
      @validate_article = validate_article
      @persist_article = persist_article
    end

    def call(params)
      result = validate_article.call(params)

      if result.success?
        persist_article.call(params)
      end
    end
  end
end