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

describe ReviewItemsController do

  # This should return the minimal set of attributes required to create a valid
  # ReviewItem. As you add validations to ReviewItem, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all review_items as @review_items" do
      review_item = ReviewItem.create! valid_attributes
      get :index
      assigns(:review_items).should eq([review_item])
    end
  end

  describe "GET show" do
    it "assigns the requested review_item as @review_item" do
      review_item = ReviewItem.create! valid_attributes
      get :show, :id => review_item.id
      assigns(:review_item).should eq(review_item)
    end
  end

  describe "GET new" do
    it "assigns a new review_item as @review_item" do
      get :new
      assigns(:review_item).should be_a_new(ReviewItem)
    end
  end

  describe "GET edit" do
    it "assigns the requested review_item as @review_item" do
      review_item = ReviewItem.create! valid_attributes
      get :edit, :id => review_item.id
      assigns(:review_item).should eq(review_item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ReviewItem" do
        expect {
          post :create, :review_item => valid_attributes
        }.to change(ReviewItem, :count).by(1)
      end

      it "assigns a newly created review_item as @review_item" do
        post :create, :review_item => valid_attributes
        assigns(:review_item).should be_a(ReviewItem)
        assigns(:review_item).should be_persisted
      end

      it "redirects to the created review_item" do
        post :create, :review_item => valid_attributes
        response.should redirect_to(ReviewItem.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved review_item as @review_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewItem.any_instance.stub(:save).and_return(false)
        post :create, :review_item => {}
        assigns(:review_item).should be_a_new(ReviewItem)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewItem.any_instance.stub(:save).and_return(false)
        post :create, :review_item => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested review_item" do
        review_item = ReviewItem.create! valid_attributes
        # Assuming there are no other review_items in the database, this
        # specifies that the ReviewItem created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ReviewItem.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => review_item.id, :review_item => {'these' => 'params'}
      end

      it "assigns the requested review_item as @review_item" do
        review_item = ReviewItem.create! valid_attributes
        put :update, :id => review_item.id, :review_item => valid_attributes
        assigns(:review_item).should eq(review_item)
      end

      it "redirects to the review_item" do
        review_item = ReviewItem.create! valid_attributes
        put :update, :id => review_item.id, :review_item => valid_attributes
        response.should redirect_to(review_item)
      end
    end

    describe "with invalid params" do
      it "assigns the review_item as @review_item" do
        review_item = ReviewItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewItem.any_instance.stub(:save).and_return(false)
        put :update, :id => review_item.id, :review_item => {}
        assigns(:review_item).should eq(review_item)
      end

      it "re-renders the 'edit' template" do
        review_item = ReviewItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewItem.any_instance.stub(:save).and_return(false)
        put :update, :id => review_item.id, :review_item => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested review_item" do
      review_item = ReviewItem.create! valid_attributes
      expect {
        delete :destroy, :id => review_item.id
      }.to change(ReviewItem, :count).by(-1)
    end

    it "redirects to the review_items list" do
      review_item = ReviewItem.create! valid_attributes
      delete :destroy, :id => review_item.id
      response.should redirect_to(review_items_url)
    end
  end

end
