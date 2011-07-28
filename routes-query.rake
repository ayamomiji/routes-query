namespace :routes do
  desc 'Default routes task with more query options. Q=any C=controller A=action N=name P=path'
  task :query, [:q] => :environment do |task, args|
    Rails.application.reload_routes!
    all_routes = Rails.application.routes.routes

    path_to_name = {}

    all_routes.each do |route|
      path_to_name[route.path] = route.name.to_s if route.name.to_s.present?
    end

    if ENV['C']
      all_routes = all_routes.select{ |route| route.defaults[:controller] =~ Regexp.new(ENV['C'], 'i') }
    end

    if ENV['A']
      all_routes = all_routes.select{ |route| route.defaults[:action] =~ Regexp.new(ENV['A'], 'i') }
    end

    if ENV['N']
      all_routes = all_routes.select{ |route| route.name =~ Regexp.new(ENV['N'], 'i') }
    end

    if ENV['P']
      all_routes = all_routes.select{ |route| route.path =~ Regexp.new(ENV['P'], 'i') }
    end

    if ENV['Q'] || args[:q]
      (ENV['Q'] || args[:q]).split.each do |query|
        regexp = Regexp.new(query, 'i')
        all_routes = all_routes.select do |route|
          route.defaults[:controller] =~ regexp or
          route.defaults[:action] =~ regexp or
          route.name =~ regexp or
          route.path =~ regexp
        end
      end
    end

    routes = all_routes.collect do |route|

      reqs = route.requirements.dup
      reqs[:to] = route.app unless route.app.class.name.to_s =~ /^ActionDispatch::Routing/

      if reqs[:controller]
        reqs[:C] = reqs[:controller]
        reqs.delete :controller
      end

      if reqs[:action]
        reqs[:A] = reqs[:action]
        reqs.delete :action
      end

      reqs = reqs.empty? ? "" : reqs.map { |k, v| "#{k}: #{v}" }.join(', ')

      route_name = route.name.to_s
      route_name = path_to_name[route.path] || '(none)' if route_name.blank?

      {:name => route_name, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
    end

    routes.reject! { |r| r[:path] =~ %r{/rails/info/properties} } # Skip the route if it's internal info route

    name_width = routes.map{ |r| r[:name].length }.max
    verb_width = routes.map{ |r| r[:verb].length }.max
    path_width = routes.map{ |r| r[:path].length }.max

    routes.each do |r|
      puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
    end
  end
end

task :rq, [:q] => 'routes:query'
