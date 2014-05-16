require_relative 'acceptance_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user ) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer', js: true do
      save_and_open_page
      within 'form#new_answer' do
        fill_in 'Your Answer', with: 'My test answer'
        click_on 'Post Your Answer'
      end

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'My test answer'
      end
      save_and_open_page
      within 'form#new_answer' do
        expect(page).to_not have_content 'My test answer'
      end

    end

    scenario 'create invalid answer', js: true do
      click_on 'Post Your Answer'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content "can't be blank"
    end
  end

end