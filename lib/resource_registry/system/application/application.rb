module Application
  class Application #< Roda

    # plugin :error_handler

    # route do |r|
    #   r.on "admin" do
    #     r.run Admin::Application.freeze.app
    #   end

    #   r.run Main::Application.freeze.app
    # end

    # error do |e|
    #   Bugsnag.auto_notify e
    #   raise e
    # end

  end
end
