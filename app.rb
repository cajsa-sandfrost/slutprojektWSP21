require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/') do
  slim(:register)
end

post('/') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]
  zodiacid = params[:zodiac]
  if (password == password_confirm) 
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new('db/db.db')
    db.execute('INSERT INTO users (username,pwdigest,zodiacid) VALUES (?,?,?)',username, password_digest,zodiacid)
    redirect('/chat')
  else 
     "lösenorden matchade inte"
  end
end 

get('/hem') do 
  slim(:hem)
end 

post('/hem') do
  zodiactext = params[:zodiactext]
  db = SQLite3::Database.new('db/db.db')
  db.execute('INSERT INTO users (zodiacid) VALUES (?)',zodiacid)
end 

get('/chat') do 
  slim(:chat)
end 

post('/login') do
  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new('db/db.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?", username).first
  pwdigest = result["pwdigest"]
  id = result["id"]

  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id 
    redirect('/hem')
  else 
    "FEL LÖSENORD!"
  end 
end

get('/login') do
 slim(:login) 
end 



get('/astro') do 
  slim(:astro)
end 

post('/astro') do 
  content = params[:content]
  db = SQLite3::Database.new('db/db.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM post WHERE content = ?", content).first
  id = result["postid"]
  db = execute('INSERT INTO post (content) VALUES (?)',content)
end 

post('/chat') do
   
  content = params[:content]
  db = SQLite3::Database.new('db/db.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM post WHERE content = ?", content).first
  id = result["postid"]
  db = execute('INSERT INTO post (content) VALUES (?)',content)
end 

#post('/login') do
  #username = params[:username]
  #password = params[:password]
  #db = SQLite3::Database.new('db/db.db')
  #db.results_as_hash = true
  #result = db.execute("SELECT * FROM users WHERE username = ?", username).first
  #pwdigest = result["pwdigest"]
  #id = result["userid"]

  #if BCrypt::Password.new(pwdigest) == password
    #session[:id] = id 
    #redirect('/todos')
  #else 
    #"FEL LÖSENORD!"
  #end 
#end

