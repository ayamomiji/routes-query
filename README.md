Routes Query
============

Provides a rake task to query Rails routes easier.

Install
-------

Just download the rake task file and move it to `lib/tasks/`.

Example
-------

Given a routes.rb like this:

    resource :profile

    resources :boards do
      resources :posts do
        get :search, :on => :collection

        resources :comments
      end
    end

    resources :announces do
      resources :comments
    end

    root :to => 'main#index'

When I run `rake routes:query Q=com` (or `rake rq Q=com`)

Then it responds these:

        board_post_comments GET    /boards/:board_id/posts/:post_id/comments(.:format)          {:action=>"index", :controller=>"comments"}
        board_post_comments POST   /boards/:board_id/posts/:post_id/comments(.:format)          {:action=>"create", :controller=>"comments"}
     new_board_post_comment GET    /boards/:board_id/posts/:post_id/comments/new(.:format)      {:action=>"new", :controller=>"comments"}
    edit_board_post_comment GET    /boards/:board_id/posts/:post_id/comments/:id/edit(.:format) {:action=>"edit", :controller=>"comments"}
         board_post_comment GET    /boards/:board_id/posts/:post_id/comments/:id(.:format)      {:action=>"show", :controller=>"comments"}
         board_post_comment PUT    /boards/:board_id/posts/:post_id/comments/:id(.:format)      {:action=>"update", :controller=>"comments"}
         board_post_comment DELETE /boards/:board_id/posts/:post_id/comments/:id(.:format)      {:action=>"destroy", :controller=>"comments"}
          announce_comments GET    /announces/:announce_id/comments(.:format)                   {:action=>"index", :controller=>"comments"}
          announce_comments POST   /announces/:announce_id/comments(.:format)                   {:action=>"create", :controller=>"comments"}
       new_announce_comment GET    /announces/:announce_id/comments/new(.:format)               {:action=>"new", :controller=>"comments"}
      edit_announce_comment GET    /announces/:announce_id/comments/:id/edit(.:format)          {:action=>"edit", :controller=>"comments"}
           announce_comment GET    /announces/:announce_id/comments/:id(.:format)               {:action=>"show", :controller=>"comments"}
           announce_comment PUT    /announces/:announce_id/comments/:id(.:format)               {:action=>"update", :controller=>"comments"}
           announce_comment DELETE /announces/:announce_id/comments/:id(.:format)               {:action=>"destroy", :controller=>"comments"}

When I run `rake routes:query C=p A=c`

Then it responds these:

               profile POST /profile(.:format)                       {:action=>"create", :controller=>"profiles"}
    search_board_posts GET  /boards/:board_id/posts/search(.:format) {:action=>"search", :controller=>"posts"}
           board_posts POST /boards/:board_id/posts(.:format)        {:action=>"create", :controller=>"posts"}


Then it responds these:

You can use Q for match anything, C for match controllers, A for match actions, P for match paths, N for match names (helpers),
