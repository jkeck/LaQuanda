class CategoryController < ApplicationController
  
  def index
    @categories = Category.find(:all)
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:message] = "Category #{@category.name} added"
    else  
      flash[:error] = "Category not added"
    end
    redirect_to :controller=>"category"
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    Category.update(params[:category][:id],params[:category])
    flash[:message] = "#{params[:category][:name]} category updated"
    redirect_to :controller=>"category"
  end
  
  def destroy
    category = Category.find(params[:id])
    flash[:message] = "#{category[:name]} has be removed"
    category.destroy
    redirect_to :controller=>"category"
  end
  
  def list
    @questions = Category.find(params[:id]).questions
    render "question/index"
  end
  
  def random
    category = Category.find(params[:id])
    @question = find_random(category.questions)
    if @question.nil?
      flash[:error] = "No more random questions in the #{category.name} category. You need to <a href='/category/clear_history/#{category[:id]}'>clear the #{category.name} history</a>."
      redirect_to :controller=>"category"
    else
      @question.last_asked = "#{Date.today}"
      @question.save
      render "question/random"
    end
  end
  
  def clear_history
    category = Category.find(params[:id])
    category.questions.each do |question|
      question.last_asked = ""
      question.save
    end
    flash[:message] = "#{category.name} history cleared"
    redirect_to :controller=>"category"
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
