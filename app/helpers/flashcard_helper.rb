module FlashcardHelper
  def show_new_card_js
    <<-JS
      $('#flashcard_container').html('#{escape_javascript(render :partial => "flashcard", :object => @flashcard)}');
      $('#buttons').html('#{escape_javascript(render :partial => 'test')}');
    JS
  end

  def update_page_js
    <<-JS
      $('#due').html('#{@user.due_flashcards_count}');
      $('#energy').html('#{@user.energy}');
      $('#answer_container').html('#{escape_javascript(render :partial => 'answer')}');
    JS
  end
end
