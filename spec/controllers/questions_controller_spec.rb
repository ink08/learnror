require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_question) { create(:question, user: other_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5, user: user) }
    before { get :index }

    it 'assigns all questions to array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end


  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, question: attributes_for(:question) }.to change(user.questions, :count).by(1)
      end

      it 'redirect to question path' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(assigns(:question))
      end

    end

    context 'with invalid attributes' do
      it 'question not saved' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'with valid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'saves new attributes for @question' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end

    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq "My Question's title"
        expect(question.body).to eq "My Question's body"
      end
    end

    context 'not owned question' do
      before { patch :update, id: other_question, question: { title: 'new title', body: 'new body' }, format: :js }

      it 'does not change question attributes' do
        other_question.reload
        expect(other_question.title).to eq "My Question's title"
        expect(other_question.body).to eq "My Question's body"
      end

    end

  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    it 'deletes question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
