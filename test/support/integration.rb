module Support
  module Integration
    def sign_in_as(user_type)
      create_sample_users

      visit login_path
      select user_type, :from => 'Login'
      fill_in 'Password', :with => 'temp123'
      click_button 'Log in'
    end

    def sign_out
      visit logout_path
    end

    def assert_css(css, options={})
      assert has_css?(css, options),
        "CSS #{css.inspect} with options #{options.inspect} does not exist"
    end

    def assert_current_path(expected_path)
      assert_equal expected_path, current_path
    end

    def assert_errors(*error_list)
      within "#errorExplanation" do
        error_list.each do |error_message|
          assert_content error_message
        end
      end
    end

    def assert_field(label, options={})
      assert has_field?(label, options),
        "Field #{label.inspect} with options #{options.inspect} does not exist"
    end

    def assert_no_field(label, options={})
      assert has_no_field?(label, options),
        "Field #{label.inspect} with options #{options.inspect} exists"
    end

    def assert_flash(message)
      assert has_css?('#flash', :text => message),
        "Flash #{message.inspect} does not exist in the page"
    end

    def assert_link(text)
      assert has_link?(text), "Link #{text} does not exist in the page"
    end

    def assert_no_link(text)
      assert has_no_link?(text), "Link #{text} exists in the page"
    end

    def assert_link_to(url, options={})
      assert_css "a[href='%s']" % url, options
    end

    def assert_content(content)
      assert has_content?(content), "Content #{content.inspect} does not exist"
    end

    def assert_no_content(content)
      assert has_no_content?(content), "Content #{content.inspect} exist"
    end

    def assert_title(title)
      within('title') do
        assert has_content?(title), "Title #{title.inspect} does not exist"
      end
    end

    def click_link_within(scope, text)
      within(scope) { click_link(text) }
    end

    def within(scope, prefix=nil)
      scope = '#' << ActionController::RecordIdentifier.dom_id(scope, prefix) if scope.is_a?(ActiveRecord::Base)
      super(scope)
    end

    def create_sample_users
      users = [ { :login => "admin",           :user_type => UserType::ADMIN },
                { :login => "check_in",        :user_type => UserType::CHECKIN },
                { :login => "check_out",       :user_type => UserType::CHECKOUT },
                { :login => "assignment_desk", :user_type => UserType::ASSIGNMENT },
                { :login => "pharmacy",        :user_type => UserType::PHARMACY } ]

      (1..5).each do |id|
        users << { :login      => "xray_#{id}",
                   :user_type  => UserType::XRAY,
                   :station_id => id }
      end

      users.each do |user|
        User.create( :login                  => user[:login],
                     :user_type              => user[:user_type],
                     :password               => "temp123",
                     :password_confirmation  => "temp123",
                     :x_ray_station_id       => user[:station_id] )
      end
    end
  end
end