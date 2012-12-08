require_dependency 'simple_pages/application_controller'

module SimplePages
  class PagesController < ApplicationController
    before_filter :authenticate_session!, except: [:show]
    load_resource class: 'SimplePages::Page', only: [:index]
    before_filter :new_page, only: [:new, :create]
    load_resource class: 'SimplePages::Page', find_by: :url, only: [:show, :edit, :update, :destroy]

    authorize_resource class: 'SimplePages::Page', except: [:show]

    def index
      @pages = @pages.paginate page: params[:page]
      respond_with @pages
    end

    def show
      respond_with @page
    end

    def new
      load_page_options
      @page.author = session_user
      respond_with @page
    end

    def edit
      load_page_options
    end

    def create
      @page.save
      if @page.invalid?
        load_page_options
      end
      respond_with @page
    end

    def update
      @page.update_attributes params[:page]
      if @page.invalid?
        load_page_options
      end
      respond_with @page
    end

    def destroy
      @page.destroy
      respond_with @page
    end

    protected

    def new_page
      @page = SimplePages::Page.new params[:page]
    end

    def load_page_options
      load_author_options
      load_page_layout_at_options
    end

    private

    def load_author_options
      load_authors
      @author_options = @authors.map do |author|
        [author.name, author.simple_page_owner_option]
      end
    end
  end
end
