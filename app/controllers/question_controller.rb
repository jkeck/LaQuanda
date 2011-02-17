class QuestionController < ApplicationController
  
  def index
    @questions = Question.find(:all)
  end
  
  def show
    @question = Quesiton.find(params[:id])
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(params[:question])
    if @question.save
      flash[:notice] = "Record added"
    else  
      flash[:error] = "Record Not Saved"
    end
    redirect_to :controller=>"question"
  end
  
  def edit
    @question = Question.find(params[:id])  
  end
  
  def update
    params[:question][:category_ids] ||= []  
    Question.update(params[:question][:id],params[:question])
    flash[:message] = "#{params[:question][:question]} updated"
    redirect_to :controller=>"question"
  end
  
  def destroy
    question = Question.find(params[:id])
    flash[:message] = "#{question[:question]} has be removed"
    question.destroy
    redirect_to :controller=>"question"
  end
  def clear_history
    question = Question.find(params[:id])
    question.last_asked = ""
    question.save
    flash[:message] = "#{question.question} has had it's history cleared."
    redirect_to :controller=>"question"
  end
  
  def clear_all_history
    Question.update_all("last_asked = ''")
    flash[:message] = "All question history cleared."
    redirect_to root_path
  end
  
  def random
    @question = find_random(Question.find(:all))
    if @question.nil?
      flash[:error] = "No more random questions.  You should <a href='/question/clear_all_history'>clear your history</a>."
      redirect_to root_path
    else
      @question.last_asked = "#{Date.today}"
      @question.save
      render "question/random"
    end
  end

  def search
    respond_to do |format|
      format.xml do
        render :layout=>false
      end
      format.html do        
        if params[:type] == "autocomplete"
          query = params[:q].split(" ").join("%")
          @questions = Question.find(:all,:conditions=>['question LIKE ?', "%#{query}%"])
          q = [params[:q]]
          r = []
          @questions.each do |question|
            r << question.question
          end
          q << r
          render :json=>q
        else
          @questions = Question.find(:all,:conditions=>['question = ?', "#{params[:q]}"])
          render "question/index"  
        end
      end
    end
  end
  
  protected
  
  def find_random(questions)
    qs = questions.map{|q| q if (q.last_asked != "#{Date.today}" and q.last_asked != "#{Date.today - 1}") }.compact
    return nil if qs.empty?
    question = qs[rand(qs.length)]
    if question.last_asked == "#{Date.today}" or question.last_asked == "#{Date.today - 1}"
      find_random(qs)
    else
      question  
    end
  end
end
