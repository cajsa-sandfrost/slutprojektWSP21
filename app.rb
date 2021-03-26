require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'byebug'

enable :sessions

get('/') do
  slim(:register)
end

post('/') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]

  if (password == password_confirm) 
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new('db/db.db')
    db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
    redirect('/chat')

  else 
     "lösenorden matchade inte"
  end
end 

get('/hem') do 
  slim(:hem)
end 

post('/hem') do
  id = session[:id]
  zodiacid = params[:zodiac]
  db = SQLite3::Database.new('db/db.db')
  db.execute("UPDATE users SET zodiacid = #{zodiac}")
  p ditt stjärntecken är #{zodic}
end 

#UPDATE Users SET weight = 160, desiredWeight = 45 where id = 1;

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
    slim(:"/hem", locals:{users: result})
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
  id = session[:id]
  content = params[:content]
  db = SQLite3::Database.new('db/db.db')
  db.execute("INSERT INTO post (content, userid) VALUES (?,id)",content, userid)
  name = db.execute("SELECT username FROM users WHERE userid = id", username).first
  h2 #{name}
  p #{content} 
end 


post('/chat') do
  id = session[:id]
  content = params[:content]
  db = SQLite3::Database.new('db/db.db')
  db.execute("INSERT INTO post (content, userid) VALUES (?,id)",content, userid)
  name = db.execute("SELECT username FROM users WHERE userid = id", username).first
  h2 #{name}
  p #{content} 
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

