# frozen_string_literal: true

RSpec.shared_examples_for "an action that requires authentication" do
  context "with no authenticated user" do
    before { sign_out(:user) }

    it "should not succeed" do
      subject.call
      if controller.is_navigational_format?
        expect(response).to redirect_to(login_path)
      else
        expect(response.response_code).to eq(401)
      end
    end
  end
end

RSpec.shared_examples_for "an admin action that requires authentication" do
  context "with no authenticated user" do
    before { sign_out(:user) }
    it { should respond_with_status(:not_found) }
  end

  context "with an authenticated non-admin user" do |non_admin_user: :bob|
    before { sign_in(users(non_admin_user)) }
    it { should respond_with_status(:not_found) }
  end
end

RSpec.shared_examples_for "an action that requires authorization" do |unauthorized_user: :mallory|
  context "when not authorized" do
    before { sign_in(users(unauthorized_user)) }
    it { should respond_with_status(:not_found) }
  end
end

RSpec.shared_examples_for "an action that responds with" do |*acceptable_formats|
  acceptable_formats.each do |acceptable_format|
    context "expecting a response in #{acceptable_format} format" do
      let(:format) { acceptable_format }
      it { should_not respond_with_status(:not_acceptable) }
    end
  end

  (%i(html js json xml csv) - acceptable_formats.collect(&:to_sym)).each do |unacceptable_format|
    context "expecting a response in #{unacceptable_format} format" do
      let(:format) { unacceptable_format }
      it { should respond_with_status(:not_acceptable) }
    end
  end
end

RSpec.shared_examples_for "an action that requires" do |*resources|
  resources.each do |resource|
    context "with an invalid or missing #{resource}" do
      let(resource) { double(id: "does_not_exist", to_param: "does_not_exist", reload: nil) }
      it { should respond_with_status(:missing) }
    end
  end
end

