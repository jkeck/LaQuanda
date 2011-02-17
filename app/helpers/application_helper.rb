# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def recently_asked?(question)
    question.last_asked == "#{Date.today}" or question.last_asked == "#{Date.today - 1}"
  end
  def random_left(questions)
    i = 0
    questions.each do |question|
      unless recently_asked?(question)
        i += 1
      end
    end
    i
  end
  
  def application_name
    "LaQuAndA"  
  end  
  
  def now_showing?
    params[:showing] == "true" or params[:action] == "random" 
  end
end
