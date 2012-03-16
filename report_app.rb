require 'rubygems'
require 'sinatra'
require 'config/database_setup'
require 'lib/models/users'
require 'lib/models/times'
require 'lib/models/projects'
require 'json'

enable :sessions

helpers do
  def require_login
    halt [404, "not_found"] unless session["user"]
    session["user"]
  end
  def require_user
    require_login
    halt [404, "not_found"] if session["user"] == "junior"
    session["user"]  
  end
  def current_user
    User.find_by_id(session['user'])
  end
end

get '/' do
  erb :first_registration
end

post '/first_registration' do
  users_log = params['first_login']
  users_pass = params['first_password']
 if users_log == "Junior" && users_pass == "qwe"
   session["user"] = "junior"
   redirect "/users/new"
 elsif User.find_by_login(users_log) 
   User.find_by_login(users_log).password == users_pass
   session["user"] = User.find_by_login(users_log).id
   redirect "/report"
 else
   puts "#{users_log.class} || #{users_pass.inspect}"
   User.find_by_login(users_log).to_json
   erb :button_try
 end
end


get '/users/new' do
  require_login 
  erb :second_registration
end

post '/users' do
     require_login
    if params['password_1'] != params['password_2']
      erb :button_try2
    else
      users_login = params['login']
      users_password1 = params['password_1']
      users_password2 = params['password_2']
      users_name = params['user_name']
      users_position = params['position']
      users_email = params['email']
      user = User.new(:login => users_login, :password => users_password1, 
      :user_name => users_name, :position => users_position, :email => users_email)
      user.save
      redirect "/"
  end
end


get '/logout' do
  session['user'] = nil
  redirect "/"
end

get '/new_project' do
  require_user
  erb :new_project
end

post '/projects' do
  names = params['name_project']
  descriptions = params['description']
  models = params['model']
  platforms = params['platform']
  project = Project.new(:name => names, :description => descriptions, 
  :model => models, :platform => platforms)
  project.save
  redirect "/report"
end

get '/times/new' do
  require_user 
  erb :new_times
end

post '/times/old' do
  require_user
  days = params['days']
  project = params['project']
  typetask = params['typetask']
  description = params['description']
  tasktime = params['tasktime']
  tasktime = TaskTime.new(:days => days, :project => project, :typetask => typetask, 
  :description => description, :tasktime => tasktime, :user => current_user)
  tasktime.save
  redirect "/report"
end

post '/serch_days' do 
  @projects = Project.all
  erb ':search_days.html'
end

get '/report' do 
  require_user
  day = params["day"]
  day = Date.today.strftime('%d.%m.%Y') unless day
  task_times = current_user.task_times.where(:days => day)
  @task_times = []
  @task_times[0] = task_times.find_all_by_typetask("self_development")
  @task_times[1] = task_times.find_all_by_typetask("working_time")
  @task_times[2] = task_times.find_all_by_typetask("extra_time")
  @task_times[3] = task_times.find_all_by_typetask("team_work")
  erb :report
end

post '/report_delete' do
del = TaskTime.find_by_id(params['id'])
del.destroy
redirect "/report"
end
