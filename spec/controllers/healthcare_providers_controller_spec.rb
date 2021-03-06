require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe HealthcareProvidersController do

  # This should return the minimal set of attributes required to create a valid
  # HealthcareProvider. As you add validations to HealthcareProvider, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all healthcare_providers as @healthcare_providers" do
      healthcare_provider = HealthcareProvider.create! valid_attributes
      get :index
      assigns(:healthcare_providers).should eq([healthcare_provider])
    end
  end

  describe "GET show" do
    it "assigns the requested healthcare_provider as @healthcare_provider" do
      healthcare_provider = HealthcareProvider.create! valid_attributes
      get :show, :id => healthcare_provider.id
      assigns(:healthcare_provider).should eq(healthcare_provider)
    end
  end

  describe "GET new" do
    it "assigns a new healthcare_provider as @healthcare_provider" do
      get :new
      assigns(:healthcare_provider).should be_a_new(HealthcareProvider)
    end
  end

  describe "GET edit" do
    it "assigns the requested healthcare_provider as @healthcare_provider" do
      healthcare_provider = HealthcareProvider.create! valid_attributes
      get :edit, :id => healthcare_provider.id
      assigns(:healthcare_provider).should eq(healthcare_provider)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HealthcareProvider" do
        expect {
          post :create, :healthcare_provider => valid_attributes
        }.to change(HealthcareProvider, :count).by(1)
      end

      it "assigns a newly created healthcare_provider as @healthcare_provider" do
        post :create, :healthcare_provider => valid_attributes
        assigns(:healthcare_provider).should be_a(HealthcareProvider)
        assigns(:healthcare_provider).should be_persisted
      end

      it "redirects to the created healthcare_provider" do
        post :create, :healthcare_provider => valid_attributes
        response.should redirect_to(HealthcareProvider.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved healthcare_provider as @healthcare_provider" do
        # Trigger the behavior that occurs when invalid params are submitted
        HealthcareProvider.any_instance.stub(:save).and_return(false)
        post :create, :healthcare_provider => {}
        assigns(:healthcare_provider).should be_a_new(HealthcareProvider)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        HealthcareProvider.any_instance.stub(:save).and_return(false)
        post :create, :healthcare_provider => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested healthcare_provider" do
        healthcare_provider = HealthcareProvider.create! valid_attributes
        # Assuming there are no other healthcare_providers in the database, this
        # specifies that the HealthcareProvider created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        HealthcareProvider.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => healthcare_provider.id, :healthcare_provider => {'these' => 'params'}
      end

      it "assigns the requested healthcare_provider as @healthcare_provider" do
        healthcare_provider = HealthcareProvider.create! valid_attributes
        put :update, :id => healthcare_provider.id, :healthcare_provider => valid_attributes
        assigns(:healthcare_provider).should eq(healthcare_provider)
      end

      it "redirects to the healthcare_provider" do
        healthcare_provider = HealthcareProvider.create! valid_attributes
        put :update, :id => healthcare_provider.id, :healthcare_provider => valid_attributes
        response.should redirect_to(healthcare_provider)
      end
    end

    describe "with invalid params" do
      it "assigns the healthcare_provider as @healthcare_provider" do
        healthcare_provider = HealthcareProvider.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HealthcareProvider.any_instance.stub(:save).and_return(false)
        put :update, :id => healthcare_provider.id, :healthcare_provider => {}
        assigns(:healthcare_provider).should eq(healthcare_provider)
      end

      it "re-renders the 'edit' template" do
        healthcare_provider = HealthcareProvider.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HealthcareProvider.any_instance.stub(:save).and_return(false)
        put :update, :id => healthcare_provider.id, :healthcare_provider => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested healthcare_provider" do
      healthcare_provider = HealthcareProvider.create! valid_attributes
      expect {
        delete :destroy, :id => healthcare_provider.id
      }.to change(HealthcareProvider, :count).by(-1)
    end

    it "redirects to the healthcare_providers list" do
      healthcare_provider = HealthcareProvider.create! valid_attributes
      delete :destroy, :id => healthcare_provider.id
      response.should redirect_to(healthcare_providers_url)
    end
  end

end
