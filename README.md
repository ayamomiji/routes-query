Routes Query
============

Provides a rake task to query Rails routes easier.

Support Rails 3.0, 3.1

Install
-------

Just download the rake task file and move it to `lib/tasks/`.

or:

    curl https://raw.github.com/ayamomiji/routes-query/master/routes-query.rake > lib/tasks/routes-query.rake

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

When I run `rake routes:query Q=com` (or `rake rq Q=com`, `rake routes:query[com]`, `rake rq[com]`)

Then it responds these:

        board_post_comments GET    /boards/:board_id/posts/:post_id/comments(.:format)          C: comments, A: index
        board_post_comments POST   /boards/:board_id/posts/:post_id/comments(.:format)          C: comments, A: create
     new_board_post_comment GET    /boards/:board_id/posts/:post_id/comments/new(.:format)      C: comments, A: new
    edit_board_post_comment GET    /boards/:board_id/posts/:post_id/comments/:id/edit(.:format) C: comments, A: edit
         board_post_comment GET    /boards/:board_id/posts/:post_id/comments/:id(.:format)      C: comments, A: show
         board_post_comment PUT    /boards/:board_id/posts/:post_id/comments/:id(.:format)      C: comments, A: update
         board_post_comment DELETE /boards/:board_id/posts/:post_id/comments/:id(.:format)      C: comments, A: destroy
          announce_comments GET    /announces/:announce_id/comments(.:format)                   C: comments, A: index
          announce_comments POST   /announces/:announce_id/comments(.:format)                   C: comments, A: create
       new_announce_comment GET    /announces/:announce_id/comments/new(.:format)               C: comments, A: new
      edit_announce_comment GET    /announces/:announce_id/comments/:id/edit(.:format)          C: comments, A: edit
           announce_comment GET    /announces/:announce_id/comments/:id(.:format)               C: comments, A: show
           announce_comment PUT    /announces/:announce_id/comments/:id(.:format)               C: comments, A: update
           announce_comment DELETE /announces/:announce_id/comments/:id(.:format)               C: comments, A: destroy

When I run `rake routes:query C=p A=c`

Then it responds these:

               profile POST /profile(.:format)                       C: profiles, A: create
    search_board_posts GET  /boards/:board_id/posts/search(.:format) C: posts, A: search
           board_posts POST /boards/:board_id/posts(.:format)        C: posts, A: create

You can use Q for match anything, C for match controllers, A for match actions, P for match paths, N for match names (helpers),
