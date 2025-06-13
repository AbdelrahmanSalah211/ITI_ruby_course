class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @articles = Article.where(archived: false)
  end

  def show
  end

  def new
  end

  def create
    @article.user = current_user
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  def report
    @article.increment!(:reports_count)
    if @article.reports_count >= 3
      @article.update(archived: true)
    end
    redirect_to @article, notice: 'Article reported'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :image)
  end
end
